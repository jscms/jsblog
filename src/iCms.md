```
name: iCMS
type: script/coffee
author: riceball
```

iCMS
====

    module.exports = iCMS

    iFolderParser = require("./iCmsFolderParser")
    iFileReader   = require("./iCmsFileReader")
    iFileWriter   = require("./iCmsFileWriter")
    iResource     = require("./model/iCmsResource")



    class iCMS
        constructor: (@parser) ->
            @parser  = new iFolderParser unless @parser?
            @readers = [new iFileReader]
            @writers = [new iFileWriter]

The init method is used to genertate the empty iCMS content site.

        init: (path) ->

        build: (path, options) ->
            @parser.scan(path, options, (meta, filename, content) ->
                res = new iResource(meta, filename, content)
                processed = 0
                # process a file
                for reader in @readers
                    result = reader.process(res)
                    if result? then processed++
                    if result == 'STOP'
                        break
                if processed > 0
                    for writer in @writers
                        if writer.process(res) == 'STOP'
                            break
                return
            )
            return
        server: (path, options) ->