
# /*
#   AIO
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Tue Aug 12 2014 23:56:06 GMT+0800 (CST)
#

"use strict"

koa   = require 'koa'

route = require 'koa-route'

Test  = require './test'

class Aio

  constructor : ( @options = {} ) ->
    @app = koa()
    @useMiddleware()

  useMiddleware : ->
    { app } = @
    testApp = new Test
    app.use route.get '/', testApp.middleware()

  listen : ( port, cb ) ->
    @app.listen port, cb

module.exports = Aio
