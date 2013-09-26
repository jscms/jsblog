```
name: iCmsFolderParser
type: script/coffee
author: riceball
```

iCmsFolderParser
================

    yaml = require('js-yaml')
    path = require('path')
    fs   = require('fs')
    minimatch = require('minimatch')
    S  = require('string');
    _  = require('lodash')
    Resource  = require("./model/iCmsResource")
    logger = process.logging || require('./util/logger');
    log = logger('folder:parser')

Scan the specified directory to get the configuration and meta info.
The README.md in the 'root' directory is the global configuration and description for the site.

The default folder/category readme file is README.md or index.md.

    README_NAME = 'README.md'
    INDEX_NAME  = 'index.md'

The configuration is a YAML front-matter in the file.
YAML is extracted from the the top of a file between matching separators:

    YamlFrontMatterRegEx = ///
        ^([\-=`.~_]{3})\r?\n    # one line three same character [-=`.~] is the seperator
        (.*)                    # the yaml config
        \r?\n\1\r?\n
        (.*)$                   # the content
    ///g


Usage
------

```coffee
parser = new iCmsFolderParser(aPath, aDefaultOptions)
parser.onFile = (aConfig, aFilePath, aContent) ->
parser.onAsset = (aFilePath) ->
```

    class iCmsFolderParser
        # cache the meta info and content of files
        _cachedContents: {}
        options: {}
        onFile: (aConfig, aFilePath, aContent)->
        onAsset: (aFilePath)->
        constructor: (@path, @options) ->
        setCache: (aFilename, config, content) ->
            @_cachedContents[aFilename] = 
                config: config
                content: content
            return
        getCache: (aFilename) ->
            @_cachedContents[aFilename]
        getContentInfo: (aFilename) ->
            vCache = @getCache(aFilename)
            if not vCache? and fs.existsSync(aFilename) and Resource.isContent(aFilename)
                contents = fs.readFileSync(aFilename, 'utf8')
                if contents instanceof Error
                    log.error('getContentInfo::readfile',  aFilename, contents)
                    return null
                vCache = {}
                [vCache.config, vCache.content] = contents.match(YamlFrontMatterRegEx)[2..3]
                try
                    vCache.config = if vCache.config? then yaml.safeLoad(vCache.config) else {}
                catch (e)
                    log.error('getContentInfo::loadYaml',  aFilename, vCache.config)
                    return null
                vConfig = vCache.config
                vConfig.filename = aFilename
                slug = S(path.basename(aFilename, path.extname(aFilename))).slugify().s
                vConfig.id = slug unless vConfig.id?
                vConfig.name = slug unless vConfig.name?
                vConfig.slug = slug unless vConfig.slug?
                vConfig.title = S(slug).humanize().s unless vConfig.title?
                @setCache(aFilename, vCache)
            vCache
        processCategory: (aPath, aOptions, aFnIterator) ->
            # 
            vPathInfo = @getPathInfo(aPath, aOptions['skips'])
            vSiteReadme = @getContentInfo(path.join(aPath, vPathInfo.readme))
            if vSiteReadme?
                vConfig = vSiteReadme.config
                vConfig.categories = vPathInfo.categories
                vConfig.files = vPathInfo.files
                vConfig.assets = vPathInfo.assets
            processFile path.join(aPath, vPathInfo.readme)

            processFile file for file in vPathInfo.files
            processAsset asset for asset in vPathInfo.assets
            processCategory cat for cat in vPathInfo.categories
        processAsset: (aFilename) ->
            if _.isFunction(@onAsset)
                return @onAsset(aFilename)
        processFile: (aFilename) ->
            vCache = @getContentInfo(aFilename)
            if vCache?
                vConfig = _.extend({}, @options)
                vConfig = _.extend(vConfig, vCache.config)
                #if vConfig.name?
                if _.isFunction(@onFile)
                    return @onFile(vConfig, aFilename, vCache.content)
            return null
        getPathInfo: (aPath, aSkips) ->
            #aOptions.path = aPath
            result = {}
            result.path = aPath
            vPaths = fs.readdirSync(aPath)

            # remove hidden files and skips
            if aSkips?
                s = '.*'
                if _.isArray(aSkips)
                    s = '{' +s + ',' + aSkips.join(',') + '}' if aSkips.length > 0
                else _.isString(aSkips) and aSkips.length > 0
                    s = '{' +s + ',' + aSkips + '}'
                #vPaths = minimatch.match(vPaths, '!'+s, {})
                vPaths = (f for f in vPaths when not minimatch(f, s))

            vFiles = vCategories = vAssets = []
            vPathReadme = null
            for f in vPaths
                fstat = fs.statSync(path.join(aPath, f))
                if fstat
                    if fstat.isDirectory()
                        vCache = @getContentInfo(path.join(aPath, f, README_NAME))
                        vCache = @getContentInfo(path.join(aPath, f, INDEX_NAME)) unless vCache?
                        if vCache? and vCache.config and vCache.config.type? and vCache.config.type != 'category'
                            vCache.config.isDir = true
                            vFiles.push f
                        else
                            vCategories.push f
                    if fstat.isFile()
                        if f == README_NAME
                            vPathReadme = README_NAME
                        else if f == INDEX_NAME && vPathReadme == null
                            vPathReadme = INDEX_NAME
                        else if @getContentInfo(path.join(aPath, f))?
                            vFiles.push(f)
                        else # treat others as assets
                            vAssets.push(f)

            result.categories = vCategories
            result.files = vFiles
            result.assets = vAssets
            result.reademe = vPathReadme
            #vConfig = _.extend(aOptions, {type: 'category', parent: path.relative(aOptions.root, aPath)})
            #vConfig.name = path.basename(README2, path.extname(README2))
            #result = @processFile(path.join(aPath, vPathReadme), vConfig, aFnIterator) if vPathReadme?
            #if result instanceof Error then return result
            #if vConfig.type == 'category'
            return result
        scan: (aPath, aOptions, aFnIterator) ->
            @_cachedContents = {}
            aOptions.root = aPath
            @options = _.extend(@options, aOptions)
            vPathInfo = @getPathInfo(aPath, @options['skips'])
            if vPathInfo.readme?
                vSiteReadme = @getContentInfo(path.join(aPath, vPathInfo.readme))
                @options.site = {title: 'Demo', url: 'http://localhost', language:'en'} unless @options.site?
                @options.authors = {'admin':{name: 'Admin', email: 'admin@example.com'}} unless @options.authors?
                if vSiteReadme?
                    vConfig = vSiteReadme.config
                    vConfig.categories = vPathInfo.categories
                    vConfig.files = vPathInfo.files
                    vConfig.assets = vPathInfo.assets
                    #vConfig.id = vConfig.slug = vConfig.name = path.basename(INDEX_NAME, path.extname(INDEX_NAME))
                    vConfig.parent = ''
                    if vConfig.site? and _.isObject(vConfig.site)
                        @options.site = _.extend(@options.site, vConfig.site)
                    if vConfig.authors? and _.isObject(vConfig.authors)
                        @options.authors = _.extend(@options.authors, vConfig.authors)
            processFile path.join(aPath, vPathInfo.readme)

            processFile file for file in vPathInfo.files
            processAsset asset for asset in vPathInfo.assets
            processCategory cat for cat in vPathInfo.categories
            # todo: for every file in path
            #df


    module.exports = iCmsFolderParser
