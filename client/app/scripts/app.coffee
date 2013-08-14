'use strict'

angular.module('jsBlogApp', ['iReactive.clickable', 'iReactive.slidable', 'ui.bootstrap'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
