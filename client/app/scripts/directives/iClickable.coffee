angular.module('iReactive', [])
    .constant(clickableConfig, {})
    .directive('iClickable', ['clickableConfig', '$timeout', (clickableConfig, $timeout) ->
        'use strict'

        restrict: 'A'
        require: 'ngModel'
        link: (scope, element, attrs, ngModel) ->
            var options, opts;
            options = clickableConfig || {};
            opts = angular.extend({}, options, scope.$eval(attrs.iClickable));

            parseRange = (range) ->
                OPERATOR = ///             
                (                       # Range min, if any:
                  [+|-]?                        # - sign, if any
                  (?:[\d]*[\.]?[\d]+)?          # - coefficient, if any
                  [102EGILONQPSRT_egilonqpsrt]* # - constant, if any
                )

                (                       # Inclusivity
                  [\.]{2,3}             # - dots
                )

                (                       # Range max, if any:
                  [+|-]?                        # - sign, if any
                  (?:[\d]*[\.]?[\d]+)?          # - coefficient, if any
                  [102EGILONQPSRT_egilonqpsrt]* # - constant, if any
                )

                (                       # Step, if any:
                  \sby\s                # - by keyword

                    (?:                 # - step value
                      [+|-]?                        # - sign, if any
                      (?:[\d]*[\.]?[\d]+)?          # - coefficient, if any
                      [102EGILONQPSRT_egilonqpsrt]* # - constant, if any
                    )

                ) ///
                return {}
            if angular.isDefined(opts.bind) and angular.isDefined(opts.range)
                opts = angular.extend(opts, parseRange(opts.range))
                clickingCallback = (ele) ->
                    # In clickingCallback, if you are changing any model/scope data, you'll want to call scope.$apply(), or put the contents of the method inside scope.$apply(function() { ...contents here...});
                    alert('clicked')
                element.bind('click', clickingCallback);
                attrs.$observe(opts.bind, (value) ->
                    if (value)
                        #fff
                ) 
    )]
