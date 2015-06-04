
require! {
  helpers: h 
  bluebird: p
}

testpromisify = (promisify) -> 

  test1 = (data,callback) ->
    h.wait 100, -> callback void, data + 1
    void


  test1 = promisify(test1)

  console.log 'pre1'
  test1(1).then (data) ->
    console.log data
  console.log 'post1'


  test2 = (data,callback) -> new p (resolve,reject) ->
    h.wait 100, -> resolve data + 1


  test2 = promisify(test2)

  console.log 'pre2'

  test2(2).then (data) ->
    console.log data
  console.log 'post2'


  test3 = (data,callback) ->
    data + 1


  test3 = promisify(test3)

  console.log 'pre3'

  test3(3).then (data) ->
    console.log data
  console.log 'post3'


  test4 = (data,callback) ->
    throw new Error data + 1

  test4 = promisify(test4)

  console.log 'pre4'

  test4(4)
    .then (data) -> console.log data
    .catch (err) -> console.log err
  console.log 'post4'


bla = null

# a better promisify function that accepts functions which already return promises
# and if they don't, it doesn't care if function is sync or async
promisify = (f) ->
  (...args) -> new p (resolve,reject) ->
    callback = (err,data) -> 
      if err? then reject err else resolve data # func is async
    ret = f ...args, callback # if func threw at this point, promise will be rejected
    if ret? then resolve ret # function is either sync or already promisified



testpromisify promisify



