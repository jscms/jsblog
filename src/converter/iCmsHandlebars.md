Handlebars Template File Converter
==================================


    iCmsConverter = require('./iCmsConverter')
    Handlebars    = require('handlebars')

[Extensive collection of Handlebars helpers](http://assemble.io/helpers/):

    require('handlebars-helpers').register(Handlebars, {})

    class iCmsHandlebars extends iCmsConverter

        @name: "handlebars"
        @type: "Template"
        @priority: 0

        constructor: () ->

        @compile: (aContent) ->
            return Handlebars.compile(aContent)

        @run: (aContent, aConfig) ->
            vTemplate = Handlebars.compile(aContent)
            return vTemplate(aConfig)


    module.exports = iCmsHandlebars


