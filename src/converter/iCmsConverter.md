Abstract File Converter And Converter Factory
=============================================


Convert the file content from one format to another.

    _ = require('lodash')

    class iCmsConverter
        @_registereds: []

        @name: null
        @type: null
        @priority: null

        constructor: () ->

        @getByName: (aName) ->
            for converter in @_registereds
                return converter if converter.name == aName
            return null

        @run: (aContent, aConfig) ->
            return aContent

        @runAll: (aContent, aConfig) ->
            vConverters = _.sortBy(@_registereds, 'priority')
            for converter in vConverters
                aContent = converter.run(aContent, aConfig)
            return aContent

        # run converters in list
        @runList: (aContent, aConfig, aConverterList) ->
            for name in aConverterList
                vConverter = iCmsConverter.getByName(name)
                aContent = vConverter.run(aContent, aConfig) if vConverter?
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

    module.exports = iCmsConverter