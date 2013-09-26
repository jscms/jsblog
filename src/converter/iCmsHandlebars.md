Handlebars Template File Converter
==================================


    Handlebars = require('handlebars')

[Extensive collection of Handlebars helpers](http://assemble.io/helpers/):

    require('handlebars-helpers').register(Handlebars, {});

    class iCmsHandlebars

        @_registereds: []

        @name: "handlebars"
        @type: "Template"
        @priority: 0

        constructor: () ->

        @run: (aContent, aConfig) ->
            return aContent

        @register: (aClass) ->
            registereds = iCmsConverter._registereds
            result = aClass not in registereds
            registereds.push aClass if result
            return result

        @unregister: (aClass) ->
            registereds = iCmsConverter._registereds
            result = registereds.indexOf(aClass)
            registereds.splice(result, 1) if result >= 0
            return result >= 0

    module.exports = iCmsHandlebars


