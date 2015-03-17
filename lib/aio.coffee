
# /*
#   AIO
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Tue Aug 12 2014 23:56:06 GMT+0800 (CST)
#

"use strict"

koa   = require 'koa'

route = require 'koa-route'

Note  = require './controller/note'

koaBodyParse = require 'koa-bodyparser'

staticServer = require 'koa-static'

db    = require( './core/db' )()

class Aio

  constructor : ( @options = {} ) ->
    { options } = @
    @init options
    @app = koa()
    @useMiddleware()

  init : ( options ) ->
    db.init options.mysql, console

  useMiddleware : ->
    { app, options } = @
    note    = Note options
    app.use koaBodyParse()
    # to allow cross domain
    app.use ( next ) ->
      @set 'Access-Control-Allow-Origin' : '*'
      if @method.toUpperCase() is 'OPTIONS'
        @set 'Access-Control-Allow-Methods', 'GET,POST,DELETE,PUT'        
        @body = ''
      else
        yield next
    app.use staticServer "#{__dirname}/../res/"
    app.use route.get    '/note/:date', note.getNote()
    app.use route.post   '/note', note.addNote()
    app.use route.put    '/note/:id', note.updateNote()
    app.use route.delete '/note/:id', note.deleteNote()

  listen : ( port, cb ) ->
    @app.listen port, cb

module.exports = Aio
