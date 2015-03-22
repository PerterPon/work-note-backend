
# /**
#   Note
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Mon Aug 18 2014 23:55:55 GMT+0800 (CST)
#

"use strict"

thunkify     = require 'thunkify-wrap'

noteModule = require( '../module/note' )()

class Note

  constructor : ( @options ) ->
    noteModule.getUnDoneNote = thunkify noteModule.getUnDoneNote
    noteModule.addNote       = thunkify noteModule.addNote
    noteModule.updateNote    = thunkify noteModule.updateNote
    noteModule.deleteNote    = thunkify noteModule.deleteNote

  getNote : ->
    that = @
    ( next ) ->
      try
        data  = yield noteModule.getUnDoneNote()
        @body = data
      catch e
        console.log e
        @throw 'something error', 500

  addNote : ->
    that = @
    ( next ) ->
      { body }  = @request
      body.done = body.done is 'true'
      try
        yield noteModule.addNote body
        @body = 'ok'
      catch e
        console.log e
        @throw 'someting error', 500

  updateNote : ->
    that = @
    ( id, next ) ->
      { body } = @request
      try
        yield noteModule.updateNote body
        @body = 'ok'
      catch e
        console.log e
        @throw 'something error', 500

  deleteNote : ->
    that = @
    ( id, next ) ->
      try
        yield noteModule.deleteNote id
        @body = 'ok'
      catch e
        console.log e
        @throw 'someting error', 500

module.exports = ( options ) ->
  new Note options
