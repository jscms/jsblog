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
    S  = require('string');
    _  = require('lodash')
    Resource  = require("./model/iCmsResource")

Scan the specified directory to get the configuration and meta info.
The README.md in the 'root' directory is the global configuration.
The configuration is a YAML front-matter in the file.
YAML is extracted from the the top of a file between matching separators:

The default folder/category readme file is README.md or index.md.

    README_NAME = 'README.md'
    INDEX_NAME  = 'index.md'

    YamlFrontMatterRegEx = ///
        ^([\-=`.~_]{3})\r?\n    # one line three same character [-=`.~] is the seperator
        (.*)                    # the yaml config
        \r?\n\1\r?\n
        (.*)$                   # the content
    ///g

    class iCmsFolderParser
        # cache the meta info and content of files
        cachedContents: {}
        setCache: (aFilename, config, content) ->
            cachedContents[aFilename] = 
                config: config
                content: content
            return
        getCache: (aFilename) ->
            cachedContents[aFilename]
        getContentInfo: (aFilename) ->
            vCache = @getCache(aFilename)
            if vCache == null and fs.existsSync(aFilename) and Resource.isContent(aFilename)
                contents = fs.readFileSync(aFilename, 'utf8')
                if contents instanceof Error then return contents
                vCache = {}
                [vCache.config, vCache.content] = contents.match(YamlFrontMatterRegEx)[2..3]
                try
                    vCache.config = if vCache.config? then yaml.safeLoad(vCache.config) else {}
                catch (e)
                    return e
                @setCache(aFilename, vCache)
            if vCache.config.public? and vCache.config.public == false
                null
            else
                vCache
        processContent: (aFilename, aOptions, aFnIterator) ->
            vCache = @getContentInfo(aFilename)
            if vCache instanceof Error then return vCache
            if vCache?
                vCache.config = _.extend(vCache.config, aOptions)
                if _.isFunction(aFnIterator)
                    return aFnIterator(vCache.config, aFilename, vCache.content)
            return null
        processPath: (aPath, aOptions, aFnIterator, aSkips) ->
            #aOptions.path = aPath
            vPaths = fs.readdirSync(aPath)
            # remove hidden files and skips
            s = '.*'
            s = '{' +s + ',' + aSkips.join(',') + '}' if _.isArray(aSkips) and aSkips.length > 0
            #vPaths = minimatch.match(vPaths, '!'+s, {})
            vPaths = (f for f in vPaths when not minimatch(f, s))
            vFiles = vCategories  = []
            vPathReadme = null
            for f in vPaths
                fstat = fs.statSync(path.join(aPath, f))
                if fstat
                    if fstat.isDirectory()
                        vCache = @getContentInfo(path.join(aPath, f, README_NAME))
                        vCache = @getContentInfo(path.join(aPath, f, INDEX_NAME)) unless vCache?
                        if vCache? or vCache.type? or vCache.type == 'category'
                            vCategories.push f
                        else
                            vFiles.push f
                    if fstat.isFile()
                        if f == README
                            vPathReadme = README
                        else if f == README2 && vPathReadme == null
                            vPathReadme = README2
                        else
                            vFiles.push(f)
            
            vConfig = _.extend(aOptions, {type: 'category', parent: path.relative(aOptions.root, aPath)})
            vConfig.name = path.basename(README2, path.extname(README2))
            result = @processFile(path.join(aPath, vPathReadme), vConfig, aFnIterator) if vPathReadme?
            if result instanceof Error then return result
            if vConfig.type == 'category'
        scan: (aPath, aOptions, aFnIterator) ->
            @cachedContents = {}
            aOptions.root = aPath
            siteReadme = path.join(aPath, 'README.md')
            if not fs.existsSync(siteReadme) then siteReadme = path.join(aPath, 'index.md')
            result = @processFile(siteReadme, aOptions, aFnIterator)
            if result instanceof Error then return result
            if result then result = @processDir(aPath, aOptions, aFnIterator, ['index.md', 'README.md'])
            # todo: for every file in path
            #df
