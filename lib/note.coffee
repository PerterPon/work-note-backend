
# /**
#   Note
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Mon Aug 18 2014 23:55:55 GMT+0800 (CST)
#

"use strict"

MongoClient  = require( 'mongodb' ).MongoClient

thunkify     = require 'thunkify-wrap'

moment       = require 'moment'

noteCol = null

class Note

  constructor : ( @options ) ->
    { user, password, host, db } = options.mongo
    MongoClient.connect "mongodb://#{user}:#{password}@#{host}/#{db}", ( err, db ) ->
      return console.log err if err
      noteCol = db.collection 'note'
      noteCol.update = thunkify noteCol.update

  getNote : ->
    that = @
    ( date ) -->
      is_delete = 'n'
      res     = noteCol.find { date, is_delete }, { _id : 0 }
      toArray = thunkify res.toArray
      that    = @
      try
        result  = yield toArray
      catch e
        that.body = 'this is an error'
      @body   = result

  updateNote : ->
    that = @
    ( date ) -->
      { body }  = @request
      # console.log date, body
      yield noteCol.update { date }, body, true
      this.body = 'ok'

  deleteNote : ->
    that = @
    ( date ) -->
      is_delete = 'y'
      yield noteCol.update { date }, { '$set' : { is_delete } }
      this.body = 'ok'

module.exports = ( options ) ->
  new Note options
