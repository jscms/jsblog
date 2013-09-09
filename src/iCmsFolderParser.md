```
name: iCmsFolderParser
type: script/coffee
author: riceball
```

iCmsFolderParser
================

    module.exports = iCmsFolderParser
    yaml = require('js-yaml')
    path = require('path')
    fs   = require('fs')
    glob = require('glob')
    _    = require('lodash')

Scan the specified directory to get the configuration and meta info.
The README.md in the 'root' directory is the global configuration.
The configuration is a YAML front-matter in the file.
YAML is extracted from the the top of a file between matching separators:


    YamlFrontMatterRegEx = ///
        ^([\-=`.~_]{3})\r?\n    # one line three same character [-=`.~] is the seperator
        (.*)                    # the yaml config
        \r?\n\1\r?\n
        (.*)$                   # the content
    ///g

    class iCmsFolderParser
        processFile: (filename, options) ->
            if fs.existsSync(siteReadme)
                contents = fs.readFileSync(filename, 'utf8')
                if contents instanceof Error then return contents
                [config, content] = contents.match(YamlFrontMatterRegEx)[2..3]
                try
                    config = if config? then yaml.safeLoad(config) else {}
                catch (e)
                    return e
                config = _.extend(config, options)
                if _.isFunction(fnIterator)
                    fnIterator(config, siteReadme, content)
                return
        scan: (path, options, fnIterator) ->
            siteReadme = path.join(path, 'README.md')
            if not fs.existsSync(siteReadme) then siteReadme = path.join(path, 'index.md')
            result = @processFile(siteReadme, )
            if result instanceof Error then return result
            # todo: for every file in path
