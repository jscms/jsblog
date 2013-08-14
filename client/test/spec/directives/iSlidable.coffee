'use strict'

describe 'Directive: iSlidable', () ->
  beforeEach module 'jsBlogApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<i-slidable></i-slidable>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the iSlidable directive'
