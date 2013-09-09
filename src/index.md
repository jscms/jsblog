```
name: iCmsCommand
type: script/coffee
author: riceball
```

iCMS Command
============

    iCMS = require('./iCms')
    iCms = new iCMS()

iCMS is a reactive/computable content documents generator system. It basic goals:

* Convention over configuration
* Simple and self-consistent
* Write in markdown
* Template with handlebar
* Generate reactive/computable documents
* Generate HTML5 Application with angular framework
* Literate coffeescript

The generator itself is a part of the iCMS self-consistent system too.

iCMS Commands
-------------

It uses the command-line interfaces library: 'commander' to parse the
command-line arguments:

    program = require('commander')
    program.version(require('../package').version)

### init Command

Initialize the default iCMS content in the [folder]. the default folder
is current directory if no folder name given.

    program
       .command('init [path]')
       .description('\tInitialize the default iCMS content in the [path]
            \nthe default is current path.')
       .action( (path) ->
         iCms.init path
       )


### build Command

    program
       .command('build [path]')
       .description('\tbuild the static site.')
       .option('-d, --destination <path>', 'Site Destination: Change the directory where iCMS will write files')
       .option('-w, --watch', 'Regeneration: Enable auto-regeneration of the site when files are modified.')
       .action( (path, options) ->
         iCms.build path, options
       )

### server Command

    program
       .command('server [path]')
       .description('\preview the static site.\n')
       .option('-p, --port <port>', 'Local Server Port: Listen on the given port.')
       .option('--host <host>', 'Local Server Host: Listen at the given host.')
       .action( (path, options) ->
         iCms.server path, options
       )

    program.parse(process.argv)
