d = require './index'


  
test1 = ->
  makef = (name) ->
    (arg,callback) ->
      console.log 'running',name
      setTimeout (->
        #console.log 'done',name
        callback null, arg), 100
      return void
      
  targets = {
    
    logger:
      before: 'db'
      init: makef('logger')
      
    db:
      requires: 'blab'
      init: makef('db')
      
    express:
      after: 'db'
      init: makef('express')

    blab:
      init: makef('blab')
      
  }

  d.run(targets, 1)
    
  

test1()
