# translating camel-case to snake-case.
String::snake_case = (separator) ->
    SNAKE_CASE_REGEXP = /[A-Z]/g;
    separator = separator || '_'
    this.replace(SNAKE_CASE_REGEXP, (letter, pos) ->
        (if pos then separator else '') + letter.toLowerCase()
    )

angular.module('iReactive', [])
    .provider '$iReactable', [() ->
        ###
        *   arguments:
        *       * aDirectiveName: the created new directive name
        *       * aEvent: bind to the event, it can be a event string name, or a array, the item is:
        *         * [{evName, evFn}, ...]
        *           * eventName:
        *           * eventFn: the event callback functions
        *         * aprocessCallbackFunc(model, options, scope, element, attrs, NextValueFn)
        *   return: the directive object
        ###

        # AngularJS will instantiate a singleton by calling "new" on this function
        # The default options
        defaultOptions = 
            readonly: false,
            index: undefined,
            # the values can be null, array and function
            #   * null: means it's a number
            #   * array: means it's a list, the item is picked from it. the index is the current item.
            #   * function: means get next value from it.
            values: null,
            hint: undefined,
            # the range may be a object, a list or a func
            # the default is a object
            range: {min: -Infinity, max: Infinity, step: 1, minIn: true, maxIn: true, mulStep: 1}

        # The options specified to the provider globally.
        globalOptions = {}

        ###
        * `options({})` allows global configuration of all react-able in the
        * application.
        *
        *   var app = angular.module( 'App', ['iReactive'], function( $iReactableProvider ) {
        *     // readonly instead of editable by default
        *     $iReactableProvider.options( { readonly: true } );
        *   });
        ###
        this.options = ( value ) ->
            angular.extend( globalOptions, value );
            return

        getNextValueInLoop = (value, config, looped) ->
            if angular.isNumber value
                range = config.range
                step = range.step * range.mulStep
                if !looped
                    if step > 0 
                        if value >= range.max
                            return range.max
                    else if value <= range.min
                        return range.min
                value += step
                if looped
                    if step > 0       # step > 0?
                        if (value < range.min) or (value >= range.max)
                            if (value != range.max) or (value == range.max and !range.maxIn)
                                value = range.min
                                value += range.step if !range.minIn
                    else if step < 0
                        if (value <= range.min) or (value > range.max)
                            if (value != range.min) or (value == range.min and !range.minIn)
                                value = range.max
                                value += range.step if !range.maxIn
                value

        getNextValueInList = (value, config, looped) ->
            # the range is list
            if angular.isArray config.values
                values = config.values
            else
                values = []
            range = config.range
            if angular.isUndefined config.index
                # try find the index by value
                config.index = _.indexOf(values, value)
            config.index = getNextValueInLoop(config.index, config, looped)
            config.index = 0 if config.index < 0 or config.index >= values.length
            values[config.index]

        this.$get = [ '$injector', '$parse', '$timeout', ($injector, $parse, $timeout) ->
            (aDirectiveName, aEvent) ->
                iReactablelink = (scope, element, attrs) ->
                    options = angular.extend( {}, defaultOptions, globalOptions )
                    options = angular.extend(options, scope.$eval(attrs[aDirectiveName]))
                    options.bind = attrs.bind if attrs.bind
                    options.range = angular.extend(defaultOptions.range, options.range, scope.$eval(attrs.range))
                    options.values = scope.$eval(attrs.values) if attrs.values
                    options.hint = scope.$eval(attrs.hint) if attrs.hint
                    if !options.readonly
                        element.addClass('editable')
                    else
                        attrs.$set("readonly", "readonly")
                    #if range.length < clickableConfig.range.length
                    #   Array::push.apply(range, clickableConfig.range[range.length..])


                    #nextValueFn = getNextValueInLoop
                    #if (angular.isDefined options.values)
                    if angular.isArray options.values
                        nextValueFn = getNextValueInList
                    else if angular.isFunction options.values
                        nextValueFn = options.values
                    else
                        nextValueFn = getNextValueInLoop

                    if angular.isDefined attrs.ngReadonly
                        scope.$watch(attrs.ngReadonly, (value) ->
                            options.readonly = !!value or angular.isUndefined(options.bind) # readonly is true
                            hint = ''
                            if !options.readonly
                                element.addClass('editable')
                                element.removeClass('hint--error')
                                element.addClass('hint--info')
                                hint = if options.hint?.length then options.hint else "@"+ options.bind
                                #attrs.$set('tooltip', hint)
                            else
                                element.removeClass('editable')
                                element.removeClass('hint--info')
                                element.addClass('hint--error')
                                hint = if options.bind? then "@#{options.bind}" else ""
                                #attrs.$set('tooltip', "{{'#{hint}'}}")
                            attrs.$set('data-hint', hint)
                            return
                        )

                    if angular.isDefined(options.bind) #and angular.isDefined(opts.range)
                        #opts = angular.extend(opts, parseRange(opts.range))

                        element.addClass('iReactable'.snake_case('-'))
                        element.addClass(aDirectiveName.snake_case('-'))
                        element.addClass('hint--info')
                        element.addClass('hint--top')


                        model = $parse(options.bind)
                        options.defaultValue = model(scope)
                        if angular.isFunction aEvent
                            aEvent(model, options, scope, element, attrs, nextValueFn)
                        else if angular.isString aEvent
                            element.bind(aEvent, (el)->
                                if !options.readonly
                                    value = model(scope) #scope[options.bind]
                                    value = nextValueFn(value, options, true)

                                    # In clickingCallback, if you are changing any model/scope data,
                                    # you'll want to call scope.$apply(), or put the contents of the
                                    # method inside scope.$apply(function() { ...contents here...});
                                    #scope.$apply(opts.bind+"="+value)

                                    # the $parse can use string expression like: user.name 
                                    #scope[options.bind] = value
                                    model.assign(scope, value)
                                    scope.$apply()
                                    return
                            )
                        #hint = "@"+ options.bind
                        hint = if options.hint?.length then options.hint else "@"+ options.bind
                        attrs.$set('data-hint', hint)
                        return
                {
                    restrict: 'AE'
                    compile: (tElement, tAttrs, transclude) ->
                        links = []
                        # set tooltip property and 'call' tooltip direcitve.
                        #directive = $injector.get('tooltip'+'Directive')[0]
                        #link = directive.compile(tElement, tAttrs, transclude)
                        #links.push(link)
                        links.push(iReactablelink)
                        return (scope, elm, attrs, ctrl) ->
                            #attrs.$set('tooltip', '') # It's too late, the attrs.$observe not work well
                            for link in links
                                link(scope, elm, attrs, ctrl)
                }
        ]
        return
        # this.$get ---END
    ]

