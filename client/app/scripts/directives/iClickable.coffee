angular.module('iReactive.clickable', ['iReactive'])
    .directive('iClickable', ['$iReactable', ($iReactable) ->
        return $iReactable('iClickable', 'click')
    ])