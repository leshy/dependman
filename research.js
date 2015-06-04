// Generated by LiveScript 1.3.1
(function(){
  var h, p, testpromisify, bla, promisify, slice$ = [].slice;
  h = require('helpers');
  p = require('bluebird');
  testpromisify = function(promisify){
    var test1, test2, test3, test4;
    test1 = function(data, callback){
      h.wait(100, function(){
        return callback(void 8, data + 1);
      });
    };
    test1 = promisify(test1);
    console.log('pre1');
    test1(1).then(function(data){
      return console.log(data);
    });
    console.log('post1');
    test2 = function(data, callback){
      return new p(function(resolve, reject){
        return h.wait(100, function(){
          return resolve(data + 1);
        });
      });
    };
    test2 = promisify(test2);
    console.log('pre2');
    test2(2).then(function(data){
      return console.log(data);
    });
    console.log('post2');
    test3 = function(data, callback){
      return data + 1;
    };
    test3 = promisify(test3);
    console.log('pre3');
    test3(3).then(function(data){
      return console.log(data);
    });
    console.log('post3');
    test4 = function(data, callback){
      throw new Error(data + 1);
    };
    test4 = promisify(test4);
    console.log('pre4');
    test4(4).then(function(data){
      return console.log(data);
    })['catch'](function(err){
      return console.log(err);
    });
    return console.log('post4');
  };
  bla = null;
  promisify = function(f){
    return function(){
      var args;
      args = slice$.call(arguments);
      return new p(function(resolve, reject){
        var callback, ret;
        callback = function(err, data){
          if (err != null) {
            return reject(err);
          } else {
            return resolve(data);
          }
        };
        ret = f.apply(null, slice$.call(args).concat([callback]));
        if (ret != null) {
          return resolve(ret);
        }
      });
    };
  };
  testpromisify(promisify);
}).call(this);
