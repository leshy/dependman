{ map, fold1, keys, values, first, flatten } = require 'prelude-ls'

require! {
  util
  helpers: h 
  bluebird: p
  underscore: _
}

# a better promisify function that accepts functions which already return promises
# and if they don't, it doesn't care if function is sync or async
promisify = (f) ->
  (...args) -> new p (resolve,reject) ->
    callback = (err,data) -> 
      if err? then reject err else resolve data # func is async
    ret = f ...args, callback # if func threw at this point, promise will be rejected
    if ret? then resolve ret # function is either sync or already promisified



exports.run = (targets, ...args) ->
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

  completed = {}
  execTargets = ->
    
    h.dictMap targets, (target,name) ->
      if not _.without(target.requires, ...keys(completed)).length
        
        delete targets[name]
        
        promisify(target.init)(...args)
          .then (data) ->
            completed[name] = data
            execTargets()
            

  execTargets()
        
        
      
    

