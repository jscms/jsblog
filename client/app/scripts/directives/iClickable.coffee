#https://github.com/angular-ui/ui-codemirror/blob/master/ui-codemirror.js
#https://github.com/angular-ui/bootstrap/blob/master/src/buttons/buttons.js
#https://github.com/angular/angular.js/blob/master/src/ng/directive/input.js
#http://jsfiddle.net/dalcib/6kabF/2/   -- 
#http://jsfiddle.net/simpulton/GeAAB/  -- sharemsg
#http://jsfiddle.net/simpulton/EMA5X/  -- animateoin
###
I have to say that Angular is far too strict with private scopes. 
Many useful methods are hidden deeply inside closures and are not accesible from the app code. 
I think exposing them to public could make the whole Angular more flexible.

                    var directive=$injector.get(directiveName+'Directive')[0];
                    var link=directive.compile(tElement, tAttrs, transclude);
                    links.push(link);
                }


                return function(scope, elm, attrs, ctrl) {
                    for (var i=0;i<links.length;i++){

                        links[i](scope, elm, attrs, ctrl);
                    }
                };


http://jsfiddle.net/vojtajina/YdAsa/
Binding directive from another directive

You can apply directive from directive, but not sure why would you do that. Something like this should work:

angular.directive('first', function(expression, element) {
  var compiler = this;
  // compile....
  return function(instance) {
    var scope = this;
    // link...
  };
});

angular.directive('second', function(expression, element) {
  // apply compile fn of first directive
  var firstLinker = angular.directive('first').call(this, 'some-expression', element);

  return function(instance) {
    // apply linker of the first directive
    firstLinker.call(this, instance);
  };
});
###
angular.module('iReactive', [])
    .constant('clickableConfig', {
        readonly: false,
        index: undefined,
        # the values can be null, array and function
        #   * null: means it's a number
        #   * array: means it's a list, the item is picked from it. the index is the current item.
        #   * function: means get next value from it.
        values: null,
        # the range may be a object, a list or a func
        # the default is a object
        range: {min: -Infinity, max: Infinity, step: 1, minIn: true, maxIn: true}
    })
    .directive('iClickable', ['clickableConfig', '$injector', '$timeout', '$compile', '$parse', '$tooltip', (clickableConfig, $injector, $timeout, $compile, $parse, $tooltip) ->
        'use strict'

        restrict: 'AE'
        #require: 'ngModel'
        compile: (tElement, tAttrs, transclude) ->
            iClickablelink = ($scope, element, attrs) ->

                options = angular.extend({}, clickableConfig, $scope.$eval(attrs.iClickable))
                options.bind = attrs.bind if attrs.bind
                options.readonly = $scope.$eval(attrs.readonly) if attrs.readonly
                options.range = angular.extend(clickableConfig.range, options.range, $scope.$eval(attrs.range))
                options.values = $scope.$eval(attrs.values) if attrs.values
                #if range.length < clickableConfig.range.length
                #   Array::push.apply(range, clickableConfig.range[range.length..])

                getNextValueInLoop = (value, config) ->
                    if angular.isNumber value
                        range = config.range
                        value += range.step
                        if range.step > 0       # step > 0?
                            if (value < range.min) or (value >= range.max)
                                if value != range.max or (value == range.max and !range.maxIn)
                                    value = range.min
                                    value += range.step if !range.minIn
                        else if range.step < 0
                            if (value <= range.min) or (value > range.max)
                                if (value != range.min) or (value == range.min and !range.minIn)
                                    value = range.max
                                    value += range.step if !range.maxIn
                        value
                getNextValueInList = (value, config) ->
                    # the range is list
                    if angular.isArray config.values
                        values = config.values
                    else
                        values = []
                    range = config.range
                    if angular.isUndefined config.index
                        # try find the index by value
                        config.index = _.indexOf(values, value)
                    config.index = getNextValueInLoop(config.index, config)
                    config.index = 0 if config.index < 0 or config.index >= values.length
                    values[config.index]

                #nextValueFn = getNextValueInLoop
                #if (angular.isDefined options.values)
                if angular.isArray options.values
                    nextValueFn = getNextValueInList
                else if angular.isFunction options.values
                    nextValueFn = options.values
                else
                    nextValueFn = getNextValueInLoop
                if angular.isDefined(options.bind) #and angular.isDefined(opts.range)
                    #opts = angular.extend(opts, parseRange(opts.range))

                    element.addClass('i-clickable editable')
                    #element.attr('tooltip', "ddddd")
                    attrs.$set('tooltip', "@"+options.bind)
                    #newEle = angular.copy(element)     # recursive error
                    #newEle = $compile(element)($scope) # recursive error
                    #element.replaceWith(newEle)
                    #tooltipOpt = angular.module('ui.bootstrap.tooltip').directive('tooltip')

                    model = $parse(options.bind)
                    #element.bind('click', clickingCallback)
                    element.bind('click', (el)->
                        value = $scope[options.bind]
                        value = nextValueFn(value, options)

                        # In clickingCallback, if you are changing any model/scope data,
                        # you'll want to call scope.$apply(), or put the contents of the
                        # method inside scope.$apply(function() { ...contents here...});
                        #$scope.$apply(opts.bind+"="+value)

                        # the $parse can use string expression like: user.name 
                        #$scope[options.bind] = value
                        model.assign($scope, value);
                        $scope.$apply()
                        return
                    )
            links = []
            # set tooltip property and 'call' tooltip direcitve.
            tAttrs.$set('tooltip', '')
            directive = $injector.get('tooltip'+'Directive')[0]
            link = directive.compile(tElement, tAttrs, transclude)
            links.push(link)
            links.push(iClickablelink)
            return (scope, elm, attrs, ctrl) ->
                for link in links
                    link(scope, elm, attrs, ctrl)
              
    ])
