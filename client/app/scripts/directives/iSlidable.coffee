###
Handles drag operations- done globally to enable sliding action that starts on an element but continues across the window
###
class DragManager
    constructor: ->
        @_reset()
        @_$window = $(window)
        @_$body = $('body')

    ###
    Private: reset the drag manager and related document styles (cursor).

    Returns nothing.
    ###
    _reset: ->
        @isDragging = false
        if @_direction?
            @_$body.removeClass("dragging-#{ @_direction }")
        @_draggingTarget = null
        @_dragStartX = null
        @_dragStartY = null
        @_direction = null
        return

    ###
    Private: prepare the mouse position information for the handlers.

    cur_x - the integer current x position of the cursor
    cur_y - the integer current y position of the cursor

    Returns an object with the initial coordinates, and the change in position.
    ###
    _assembleUI: (cur_x, cur_y) ->
        return {
            x_start : @_dragStartX
            y_start : @_dragStartY
            x_delta : cur_x - @_dragStartX
            y_delta : cur_y - @_dragStartY
        }

    ###
    Public: initiate a drag operation for a given view.

    e - the jQuery.Event from the initial mousedown event
    view - the BaseElementView of the element starting the drag
    direction - the String direction of the drag: 'x', 'y', or 'both'

    Returns nothing.
    ###
    start: (e, view, direction) ->
        @isDragging = true
        { pageX, pageY } = e
        @_direction = direction
        @_dragStartX = pageX
        @_dragStartY = pageY
        @_draggingTarget = view
        @_$window.on('mousemove', @_drag)
        @_$window.on('mouseup', @_stop)
        @_$body.addClass("dragging-#{ @_direction }")

    _drag: (e) =>
        { pageX, pageY } = e
        ui = @_assembleUI(pageX, pageY)
        @_draggingTarget.onDrag?(ui)

    _stop: (e) =>
        @_$window.off('mousemove', @_drag)
        @_$window.off('mouseup', @_stop)
        if @_draggingTarget?
            { pageX, pageY } = e
            ui = @_assembleUI(pageX, pageY)
            @_draggingTarget.stopDragging?(ui)
            @_reset()

Window.DragManager = DragManager
Window.dragManager = new Window.DragManager()

angular.module('iReactive.slidable', ['iReactive'])
    .directive('iSlidable', ['$iReactable', ($iReactable) ->
        aProcessEvent = (model, options, scope, element, attrs, nextValueFn) ->
            options.hint = "Drag it to adjust @#{options.bind}'s value"
            _reset = ->
                now = new Date()
                if now - options.lastClick < 500
                    model.assign(scope, options.defaultValue)
                options.lastClick = now
                return

            _onDrag = ({ x_start, y_start, x_delta, y_delta }) ->
                options.range.mulStep = Math.floor(x_delta / 5)
                value = model(scope) #scope[options.bind]
                value = nextValueFn(value, options, false)
                model.assign(scope, value)
                scope.$apply()
                return

            _stopDragging = ->
                element.removeClass('active')

            _startDragging = (e) ->
                if !options.readonly
                    this.onDrag = _onDrag
                    this.stopDragging = _stopDragging
                    Window.dragManager.start(e, this, 'x')
                    options.defaultValue = model(scope)
                    element.addClass('active')
                    e.preventDefault()
                return

            element.bind('click', (e)->
                if !options.readonly
                    _reset()
                return
            )
            element.bind('mousedown', _startDragging)
        return $iReactable('iSlidable', aProcessEvent)
    ])