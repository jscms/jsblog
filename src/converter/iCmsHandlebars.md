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

        @compile: (aContent) ->
            return Handlebars.compile(aContent)

        @run: (aContent, aConfig) ->
            vTemplate = Handlebars.compile(aContent)
            return vTemplate(aConfig)


    iCmsConverter.register(iCmsHandlebars)
    module.exports = iCmsHandlebars


