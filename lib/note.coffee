
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
      noteCol.update = ( args..., cb ) ->
        cb new Error 'this is an error'
      noteCol.insert = thunkify noteCol.insert
      noteCol.update = thunkify noteCol.update

  getNote : ->
    that = @
    ( next ) -->
      now     = moment().format 'YYYY-MM-DD'
      res     = noteCol.find { date : now }
      toArray = thunkify res.toArray
      result  = yield toArray
      @body   = result

  updateNote : ->
    that = @
    ( next ) -->
      date      = moment().format 'YYYY-MM-DD'
      { body }  = @request
      { index } = body
      delete body.index
      updateModel = 
        '$set' : {}
      updateModel[ '$set' ][ "#{note}.#{index}" ] = body
      yield noteCol.update { date }, updateModel
      this.body = 'ok'

  addNote : ->
    that = @
    ( next ) -->
      { body:notes }  = @request
      date      = moment().format 'YYYY-MM-DD'
      yield noteCol.update { date }, { '$set' : { date } }, { upsert : true }
      yield noteCol.update { date }, { '$push' : { notes } }
      this.body = 'ok'

  deleteNote : ->
    that = @
    ( next ) -->



module.exports = ( options ) ->
  new Note options
