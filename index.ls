{ map, fold1, keys, values, first, flatten } = require 'prelude-ls'

require! {
  util
  helpers: h
  bluebird: p
  underscore: _
}


# a better promisify function that accepts functions which already return promises
# and if they don't, it doesn't care if function is sync or async
#
promisify = exports.promisify = (f) ->
  (...args) -> new p (resolve,reject) ->
    callback = (err,data) ->
      if err? then reject err else resolve data # func is async
    ret = f ...args, callback # if func threw at this point, promise will be rejected
    if ret? then resolve ret # function is either sync or already promisified


# sometimes when calling resolve,
# I want to resolve to an unresolved promise, not a promise chain.
# this is my dumb hack, why the hell this isn't possible by default?
# yes, legit usecases exist, with complex operations
#
exports.sneakyPromise = class sneakyPromise
    constructor: (@promise) ->
    gimme: -> @promise

exports.sneaky = (promise) ->
    new exports.sneakyPromise promise


# takes dictionary of format
#    {
#      name:       String
#      requires:   Array || String
#      before:     Array || String
#      after:      Array || String
#      init:       Function # async or sync, can return a promise or accept a callback
#    }
#
# and makes sure to run init functions in order
#
exports.run = (targets, env, wrapper) ->
  running = {}

  # convert before & after into requires
  #
  h.dictMap targets, (target, name) ->

    h.uniMap target.after, (targetName) ->
      if targets[targetName]
        target.requires = h.push target.requires, targetName

    h.uniMap target.before, (targetName) ->
      if targetTarget = targets[targetName]
        targetTarget.requires = h.push targetTarget.requires, name

  # need a way for targets to append new targets onto a stack
  #
  completed = {}

  execTargets = ->
    h.dictMap targets, (target,name) ->
      if not _.without(target.requires, ...keys(completed)).length

        delete targets[name]

        if wrapper? then f = wrapper target.init, env
        else f = target.init

        promisify(f)(env)
          .then (data) ->
            completed[name] = data
            execTargets()

  execTargets()
