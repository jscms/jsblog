'use strict'

describe 'Directive: iClickable', () ->
  beforeEach module 'jsBlogApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<i-clickable></i-clickable>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the iClickable directive'
