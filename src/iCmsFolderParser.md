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
    minimatch = require('minimatch')
    _    = require('lodash')

Scan the specified directory to get the configuration and meta info.
The README.md in the 'root' directory is the global configuration.
The configuration is a YAML front-matter in the file.
YAML is extracted from the the top of a file between matching separators:

The default folder/category readme file is README.md or index.md.

    README  = 'README.md'
    README2 = 'index.md'

    YamlFrontMatterRegEx = ///
        ^([\-=`.~_]{3})\r?\n    # one line three same character [-=`.~] is the seperator
        (.*)                    # the yaml config
        \r?\n\1\r?\n
        (.*)$                   # the content
    ///g

    class iCmsFolderParser
        processFile: (aFilename, aOptions, aFnIterator) ->
            if fs.existsSync(siteReadme)
                contents = fs.readFileSync(aFilename, 'utf8')
                if contents instanceof Error then return contents
                [config, content] = contents.match(YamlFrontMatterRegEx)[2..3]
                try
                    config = if config? then yaml.safeLoad(config) else {}
                catch (e)
                    return e
                config = _.extend(config, aOptions)
                if _.isFunction(aFnIterator)
                    return aFnIterator(config, siteReadme, content)
                return null
        processPath: (aPath, aOptions, aFnIterator, aSkips) ->
            #aOptions.path = aPath
            vPaths = fs.readdirSync(aPath)
            # remove hidden files and skips
            s = '.*'
            s = '{' +s + ',' + aSkips.join(',') + '}' if _.isArray(aSkips) and aSkips.length > 0
            #vPaths = minimatch.match(vPaths, '!'+s, {})
            vPaths = (f for f in vPaths when not minimatch(f, s))
            vFiles = vDirs  = []
            vPathReadme = null
            for f in vPaths
                fstat = fs.statSync(f)
                if fstat
                    if fstat.isDirectory()
                        vDirs.push(f)
                    if fstat.isFile()
                        if f == README
                            vPathReadme = README
                        else if f == README2 && vPathReadme == null
                            vPathReadme = README2
                        else
                            vFiles.push(f)
            
            vConfig = _.extend(aOptions, {type: 'category', parent: path.relative(aOptions.root, aPath)})
            result = @processFile(vPathReadme, vConfig, aFnIterator) if vPathReadme?
            if result instanceof Error then return result
        scan: (aPath, aOptions, aFnIterator) ->
            aOptions.root = aPath
            siteReadme = path.join(aPath, 'README.md')
            if not fs.existsSync(siteReadme) then siteReadme = path.join(aPath, 'index.md')
            result = @processFile(siteReadme, aOptions, aFnIterator)
            if result instanceof Error then return result
            if result then result = @processDir(aPath, aOptions, aFnIterator, ['index.md', 'README.md'])
            # todo: for every file in path
            #df
