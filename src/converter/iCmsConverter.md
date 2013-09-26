Abstract File Converter And Converter Factory
=============================================


Convert the file content from one format to another.

    class iCmsConverter
        @_registereds: []

        @name: null
        @type: null
        @priority: null

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

    module.exports = iCmsConverter


