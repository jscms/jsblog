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
angular.module('iReactive', ['iReactive.reactable'])
    .directive('iClickable', ['$iReactable', ($iReactable) ->
        return $iReactable('iClickable', 'click')
    ])