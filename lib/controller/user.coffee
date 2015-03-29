
# /*
#   User
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Sun Mar 29 2015 13:47:24 GMT+0800 (CST)
#

"use strict"

crypto     = require 'crypto'

userModule = require( '../module/user' )()

class User

  constructor : ( @options ) ->

  addUser : ->
    ( next ) ->
      { email } = @request.body
      console.log email
      md5   = crypto.createHash 'md5'
      md5.update email.toLowerCase().trim()
      hash  = md5.digest 'hex'
      where =
        email : email
        email_hash : hash
      yield userModule.addUser where
      @body = hash

  errorHandler : ->
    ( next ) ->
      try
        yield next
      catch e
        console.log e
        @throw 'something wrong', 500

module.exports = ( options ) ->
  new User options
