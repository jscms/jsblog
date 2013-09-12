util = require("util")
events = require("events")
_ = require("lodash")
table = require("text-table")
chalk = require("chalk")


# padding step
step = "  "
padding = " "

# color -> status mappings
colors =
  skip: "yellow"
  force: "yellow"
  create: "green"
  invoke: "bold"
  conflict: "red"
  identical: "cyan"
  info: "gray"

pad = (status) ->
  max = "identical".length
  delta = max - status.length
  (if delta then new Array(delta + 1).join(" ") + status else status)

# borrowed from https://github.com/mikeal/logref/blob/master/main.js#L6-15
formatter = (msg, ctx) ->
  while msg.indexOf("%") isnt -1
    start = msg.indexOf("%")
    end = msg.indexOf(" ", start)
    end = msg.length  if end is -1
    msg = msg.slice(0, start) + ctx[msg.slice(start + 1, end)] + msg.slice(end)
  msg

module.exports = logger = ->
  
  # `this.log` is a [logref](https://github.com/mikeal/logref)
  # compatible logger, with an enhanced API.
  #
  # It also has EventEmitter like capabilities, so you can call on / emit
  # on it, namely used to increase or decrease the padding.
  #
  # All logs are done against STDERR, letting you stdout for meaningfull
  # value and redirection, should you need to generate output this way.
  #
  # Log functions take two arguments, a message and a context. For any
  # other kind of paramters, `console.error` is used, so all of the
  # console format string goodies you're used to work fine.
  #
  # - msg      - The message to show up
  # - context  - The optional context to escape the message against
  #
  # Retunrns the logger
  log = (msg, ctx) ->
    msg = msg or ""
    ctx = {}  unless ctx
    if typeof ctx is "object" and not Array.isArray(ctx)
      console.error formatter(msg, ctx)
    else
      console.error.apply console, arguments_
    log
  _.extend log, events.EventEmitter::
  
  # A simple write method, with formatted message. If `msg` is
  # ommitted, then a single `\n` is written.
  #
  # Returns the logger
  log.write = (msg) ->
    return @write("\n")  unless msg
    process.stderr.write util.format.apply(util, arguments_)
    this

  
  # Same as `log.write()` but automatically appends a `\n` at the end
  # of the message.
  log.writeln = ->
    @write.apply(this, arguments_).write()

  
  # Convenience helper to write sucess status, this simply prepends the
  # message with a gren `✔`.
  log.ok = (msg) ->
    @write chalk.green("✔ ") + util.format.apply(util, arguments_) + "\n"
    this

  log.error = (msg) ->
    @write chalk.red("✗ ") + util.format.apply(util, arguments_) + "\n"
    this

  log.on "up", ->
    padding = padding + step

  log.on "down", ->
    padding = padding.replace(step, "")

  Object.keys(colors).forEach (status) ->
    
    # Each predefined status has its logging method utility, handling
    # status color and padding before the usual `.write()`
    #
    # Example
    #
    #    this.log
    #      .write()
    #      .info('Doing something')
    #      .force('Forcing filepath %s, 'some path')
    #      .conflict('on %s' 'model.js')
    #      .write()
    #      .ok('This is ok');
    #
    # The list of status and mapping colors
    #
    #    skip       yellow
    #    force      yellow
    #    create     green
    #    invoke     bold
    #    conflict   red
    #    identical  cyan
    #    info       grey
    #
    # Returns the logger
    log[status] = ->
      color = colors[status]
      @write(chalk[color](pad(status))).write padding
      @write util.format.apply(util, arguments_) + "\n"
      this

  
  # A basic wrapper around `cli-table` package, resetting any single
  # char to empty strings, this is used for aligning options and
  # arguments without too much Math on our side.
  #
  # - opts - A list of rows or an Hash of options to pass through cli
  #          table.
  #
  # Returns the table reprensetation
  log.table = (opts) ->
    tableData = []
    opts = (if Array.isArray(opts) then rows: opts else opts)
    opts.rows = opts.rows or []
    opts.rows.forEach (row) ->
      tableData.push row

    table tableData

  log
