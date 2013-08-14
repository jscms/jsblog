'use strict'

describe 'Service: iReactable', () ->

  # load the service's module
  beforeEach module 'jsBlogApp'

  # instantiate service
  iReactable = {}
  beforeEach inject (_iReactable_) ->
    iReactable = _iReactable_

  it 'should do something', () ->
    expect(!!iReactable).toBe true;
