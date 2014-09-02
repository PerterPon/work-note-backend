
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
    done
  FROM note
  WHERE is_delete = 'n'
    AND done = 'n'
    AND begin < :date
  UNION
  SELECT 
    id,
    content,
    done
  FROM note
  WHERE begin BETWEEN CONCAT( :date, ' 00:00:00' ) AND CONCAT( :date ' 23:59:59' )
    AND is_delete = 'n'
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

  getUnDoneNote : ( date, cb ) ->
    where = { date }
    db.query GET_UN_DONE_NOTE, where, cb

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