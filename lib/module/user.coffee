
# /*
#   User
# */ 
# Author: yuhan.wyh<yuhan.wyh@alibaba-inc.com>
# Create: Sun Mar 29 2015 19:54:02 GMT+0800 (CST)
#

"use strict"

thunkify = require 'thunkify-wrap'

db       = require( '../core/db' )()

ADD_USER =
  """
  INSERT INTO user(
    gmt_create,
    email,
    email_hash
  )
  VALUES(
    NOW(),
    :email,
    :email_hash
  )
  ON DUPLICATE KEY UPDATE
      email = VALUES( email );
  """

class User

  addUser : thunkify ( where, cb ) ->
    db.query ADD_USER, where, cb

module.exports = ->
  new User
