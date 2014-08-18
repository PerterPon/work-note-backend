
# /**
#   Note
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Mon Aug 18 2014 23:55:55 GMT+0800 (CST)
#

"use strict"

mongoose = require 'mongoose'

class Note

  constructor : ( @options ) ->
    { user, password, host, db } = options.mongo
    mongoose.connect "mongodb://#{user}:#{password}/#{host}/#{db}"

  getNote : ->
    that = @
    ( req, res, next ) -->

module.exports = ( options ) ->
  new Note options
