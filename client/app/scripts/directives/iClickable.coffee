#https://github.com/angular-ui/ui-codemirror/blob/master/ui-codemirror.js
#https://github.com/angular-ui/bootstrap/blob/master/src/buttons/buttons.js
#https://github.com/angular/angular.js/blob/master/src/ng/directive/input.js
angular.module('iReactive', [])
    .constant('clickableConfig', {
        # lowest, highest, step, lowestIn, highestIn
        # null means no limited
        range: [null, null, 1, true, true]
    })
    .directive('iClickable', ['clickableConfig', '$timeout', (clickableConfig, $timeout) ->
        'use strict'

        restrict: 'A'
        #require: 'ngModel'
        link: ($scope, element, attrs) ->
            options = clickableConfig || {}
            opts    = angular.extend({}, options, $scope.$eval(attrs.iClickable))
            range   = opts.range
            range  += clickableConfig.range[range.length-1..] if range.length < clickableConfig.range.length

            applyRange = (value, range) ->
                if angular.isNumber value
                    minV = range[0]
                    maxV = range[1]
                    step = range[2]
                    lowestIn  = range[3]
                    highestIn = range[4]
                    value += step
                    if step > 0       # step > 0?
                        if (minV != null and value < minV) or (maxV != null and value >= maxV)
                            value = minV
                            value += step if !lowestIn
                    else if step < 0
                        if (minV != null and value <= minV) or (maxV != null and value > maxV)
                            value = maxV
                            value += step if !highestIn
                    value

            if angular.isDefined(opts.bind) #and angular.isDefined(opts.range)
                #opts = angular.extend(opts, parseRange(opts.range))

                #element.bind('click', clickingCallback)
                element.bind('click', (el)->
                    value = $scope[opts.bind]
                    value = applyRange(value, range)

                    # In clickingCallback, if you are changing any model/scope data,
                    # you'll want to call scope.$apply(), or put the contents of the
                    # method inside scope.$apply(function() { ...contents here...});
                    #$scope.$apply(opts.bind+"="+value)
                    $scope[opts.bind] = value
                    $scope.$apply()
                    return
                )
            return
    ])
