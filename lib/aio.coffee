
# /*
#   AIO
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Tue Aug 12 2014 23:56:06 GMT+0800 (CST)
#

"use strict"

koa   = require 'koa'

route = require 'koa-route'

Note  = require './note'

koaBodyParse = require 'koa-body-parser'

class Aio

  constructor : ( @options = {} ) ->
    @app = koa()
    @useMiddleware()

  useMiddleware : ->
    { app, options } = @
    note    = Note options
    app.use koaBodyParse()
    app.use ( next ) -->
      @set 'Access-Control-Allow-Origin' : '*'
      yield next
    app.use route.get    '/note', note.getNote()
    app.use route.post   '/note', note.addNote()
    app.use route.put    '/note', note.updateNote()
    app.use route.delete '/note', note.deleteNote()

  listen : ( port, cb ) ->
    @app.listen port, cb

module.exports = Aio
