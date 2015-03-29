
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

User  = require './controller/user'

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
    note = Note options
    user = User options
    app.use koaBodyParse()
    # to allow cross domain
    app.use ( next ) ->
      @set 'Access-Control-Allow-Origin' : '*'
      if @method.toUpperCase() is 'OPTIONS'
        @set 'Access-Control-Allow-Methods', 'GET,POST,DELETE,PUT'
        @set 'Access-Control-Allow-Headers', 'X-USER-ID'
        @body = ''
      else
        yield next

    app.use staticServer "#{__dirname}/../res/"

    # user
    app.use route.all    '/user',     user.errorHandler()
    app.use route.post   '/user',     user.addUser() 

    # note
    app.use route.all    '/note',     note.errorHandler()
    app.use route.get    '/note',     note.getNote()
    app.use route.post   '/note',     note.addNote()
    app.use route.put    '/note/:id', note.updateNote()
    app.use route.delete '/note/:id', note.deleteNote()

  listen : ( port, cb ) ->
    @app.listen port, cb

module.exports = Aio
