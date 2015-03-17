
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
    id,
    content,
    done,
    close
  FROM
    note
  WHERE done = 'n'
  ORDER BY id DESC;
  """

ADD_NOTE =
  """
  INSERT INTO note(
    begin,
    content
  ) VALUES (
    now(),
    :content
  );
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
    is_delete = :is_delete
  WHERE
    id = :id;
  """

db = require( '../core/db' )()

class Note

  getUnDoneNote : ( cb ) ->
    db.query GET_UN_DONE_NOTE, {}, cb

  addNote : ( note, cb ) ->
    where = note
    db.query ADD_NOTE, where, cb

  updateNote : ( note, cb ) ->
    where = note
    db.query UPDATE_NOTE, where, cb

  deleteNote : ( id, note, cb ) ->
    where = { id }
    db.query DELETE_NOTE, where, cb

module.exports = ->
  new Note