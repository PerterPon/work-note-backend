
request  = require 'request'

thunkify = require 'thunkify-wrap'

class Test

  middleware : ->
    ( req, res, next ) -->
      console.log 123123
      fn = ( args... ) ->
        console.log args, '---'
        request 'http://www.baidu.com'
        ( args... ) ->
          console.log args, '====='
      fn2 = ( next ) ->
        process.nextTick ->
          next new Error 'this is an error'
        # console.log next.toString()
        # request 'http://www.baidu.com', next
      res = yield fn2
      console.log res[ 1 ]
      this.body = res[ 0 ].body
      # console.log 2222
      # console.log res

module.exports = Test



# function thunk() {
#     var args = slice.call(arguments);
#     var results;
#     var called;
#     var cb;
#     args.push(function () {
#       results = arguments;
#       if (cb && !called) {
#         called = true;
#         cb.apply(this, results);
#       }
#     });
#     fn.apply(ctx || this, args);
#     return function (fn) {
#       cb = fn;
#       if (results && !called) {
#         called = true;
#         fn.apply(ctx || this, results);
#       }
#     };
#   }