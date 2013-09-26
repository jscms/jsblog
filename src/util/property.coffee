###
Usage:

class Person
  constructor: (@firstName, @lastName) ->
  @property 'fullName',
    get: -> "#{@firstName} #{@lastName}"
    set: (name) -> [@firstName, @lastName] = name.split ' '


class Person
  constructor: (@firstName, @lastName) ->
  @getter 'fullName', -> "#{@firstName} #{@lastName}"
  @setter 'fullName', (name) -> [@firstName, @lastName] = name.split ' '


About property super:

class Bar extends Person
    @property 'fullName'
        get: ->
            # the Person's 'fullName' property depended on something stored as an own property of the instance, 
            # calling .fullName in the superclass prototype won't work. For example:
            #Person.__super__.fullName
            # the only way found to make Person's 'fullName' work is to
            (Object.getOwnPropertyDescriptor Person.__super__, 'fullName').get.apply @


###

# this is not necessary if u use the shim 
if Object.prototype.__defineGetter and not Object.defineProperty
    Object.defineProperty = (obj, prop, desc) ->
        if "get" of desc
            obj.__defineGetter__ prop, desc.get
        if "set" of desc
            obj.__defineSetter__ prop, desc.set

Function::property = (prop, desc) ->
    Object.defineProperty this.prototype, prop, desc

Function::getter = (prop, get) ->
  Object.defineProperty @prototype, prop, {get, configurable: yes}

Function::setter = (prop, set) ->
  Object.defineProperty @prototype, prop, {set, configurable: yes}

