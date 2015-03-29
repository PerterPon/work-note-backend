
# /**
#   Note
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Mon Aug 18 2014 23:55:55 GMT+0800 (CST)
#

"use strict"

noteModule = require( '../module/note' )()

class Note

  constructor : ( @options ) ->

  getNote : ->
    that = @
    ( next ) ->
      userId = @headers[ 'x-user-id' ]
      data   = yield noteModule.getUnDoneNote userId
      @body  = data

  addNote : ->
    that = @
    ( next ) ->
      { body }  = @request
      userId    = @headers[ 'x-user-id' ]
      body.done = body.done is 'true'
      yield noteModule.addNote body, userId
      @body = 'ok'

  updateNote : ->
    that = @
    ( id, next ) ->
      userId   = @headers[ 'x-user-id' ]
      { body } = @request
      yield noteModule.updateNote body, userId
      @body    = 'ok'

  deleteNote : ->
    that = @
    ( id, next ) ->
      userId   = @headers[ 'x-user-id' ]
      yield noteModule.deleteNote id, userId
      @body    = 'ok'

  errorHandler : ->
    ( next ) ->
      try
        yield next
      catch e
        console.log e
        @throw 'someting error', 500
      

module.exports = ( options ) ->
  new Note options
