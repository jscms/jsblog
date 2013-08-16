'use strict'

describe 'Directive: iSlidable', () ->
  beforeEach module 'jsBlogApp'

  element = {}

  it 'should make slidable element to bind', inject ($rootScope, $compile) ->
    element = angular.element '<i-slidable bind="myvar">{{myvar}}</i-slidable>'
    $rootScope.myvar = 1
    element = $compile(element) $rootScope
    $rootScope.$digest()
    expect(element.text()).toBe '1'
