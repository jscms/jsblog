```
name: iCmsResource
type: script/coffee
author: riceball
```


The iCMS Resource Class and Factory.

    path = require('path')

    class iCmsResource
        @UNKNOWN :  0
        @CATEGORY:  1
        @CONTENT :  2
        @ASSET   :  3

        @_registeredResources: []

        constructor: (@fileName, @metaInfo, @content)->
        @new: (aFileName, aMetaInfo, aContent)->
            cls = @getClass(aFileName, aMetaInfo)
            new cls aFileName, aMetaInfo, aContent

        # processed the file extnames
        @getExtNames: ->
            []
        @getClass: (aFileName, aMetaInfo) ->
            result = null
            for resClass in iCmsResource._registeredResources
                if resClass.getClass != iCmsResource.getClass
                    result = resClass.getClass(aFileName, aMetaInfo)
                    break if result?
                else if path.extname(aFileName) in resClass.getExtNames()
                    result = resClass
                    break
            result = iCmsResource unless result?
            return result
        @getKind: (aFileName) ->
            result = iCmsResource.UNKNOWN
            for resClass in iCmsResource._registeredResources
                result = resClass.getKind(aFileName) if resClass.getKind != iCmsResource.getKind
                break if result isnt iCmsResource.UNKNOWN
            return result
        @isKind: (aFileName, aKind) ->
            result = @getKind aFileName
            return result == aKind
        # check category or Content can be rendered.
        @isContent: (aFileName) ->
            return @isKind aFileName, iCmsResource.CONTENT
        @register: (aCmsResourceClass) ->
            registeredResources = iCmsResource._registeredResources
            result = aCmsResourceClass not in registeredResources
            registeredResources.push aCmsResourceClass if result
            return result
        @unregister: (aCmsResourceClass) ->
            registeredResources = iCmsResource._registeredResources
            result = registeredResources.indexOf(aCmsResourceClass)
            registeredResources.splice(result, 1) if result >= 0
            return result >= 0


    module.exports = iCmsResource
