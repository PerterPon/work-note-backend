
# /*
#  Note
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Sat Aug 30 2014 16:02:50 GMT+0800 (CST)
#

"use strict"

GET_UN_DONE_NOTE =
  """
  SELECT
    note.id,
    content,
    done,
    close
  FROM
    note
  LEFT JOIN user
  ON note.user    = user.id
  WHERE done      = 'n'
    AND is_delete = 'n'
    AND user.email_hash = :hash
  ORDER BY note.id DESC;
  """

# ADD_NOTE =
#   """
#   INSERT INTO note(
#     begin,
#     content
#   ) VALUES (
#     now(),
#     :content
#   );
#   """

ADD_NOTE =
  """
  INSERT INTO note(
    user,
    begin,
    content
  )
  SELECT
    user.id  AS user,
    now()    AS begin,
    :content AS content
  FROM user
  WHERE email_hash = :hash;
  """

UPDATE_NOTE =
  """
  UPDATE note
  SET
    close   = :close,
    done    = :done,
    content = :content
  WHERE
    id      = :id;
  """

DELETE_NOTE =
  """
  UPDATE note
  SET
    is_delete = 'y'
  WHERE
    id = :id;
  """

db       = require( '../core/db' )()

thunkify = require 'thunkify-wrap'

class Note

  getUnDoneNote : thunkify ( hash, cb ) ->
    db.query GET_UN_DONE_NOTE, { hash }, cb

  addNote : thunkify ( note, hash, cb ) ->
    where = note
    where.hash = hash
    db.query ADD_NOTE, where, cb

  updateNote : thunkify ( note, hash, cb ) ->
    where = note
    where.hash = hash
    db.query UPDATE_NOTE, where, cb

  deleteNote : thunkify ( id, hash,cb ) ->
    where = { id, hash }
    db.query DELETE_NOTE, where, cb

module.exports = ->
  new Note
