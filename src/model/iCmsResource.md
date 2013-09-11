```
name: iCmsResource
type: script/coffee
author: riceball
```


The iCMS Resource Class and Factory.

    module.exports = iCmsResource

    class iCmsResource
        @resTypes: []
        # Category or Content can be rendered.
        @isContent: (aFileName) ->
            result = false
            for res in iCmsResource.resTypes
                result = res.isContent(aFileName)
                break if result
            return result
        @register: (aCmsResourceClass) ->
            resTypes = iCmsResource.resTypes
            resTypes.push aCmsResourceClass unless aCmsResourceClass in resTypes
