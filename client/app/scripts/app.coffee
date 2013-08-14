'use strict'

angular.module('jsBlogApp', ['ngRoute', 'iReactive.clickable', 'iReactive.slidable', 'ui.bootstrap'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
