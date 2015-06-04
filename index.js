// Generated by LiveScript 1.3.1
(function(){
  var ref$, map, fold1, keys, values, first, flatten, util, h, p, _, promisify, slice$ = [].slice;
  ref$ = require('prelude-ls'), map = ref$.map, fold1 = ref$.fold1, keys = ref$.keys, values = ref$.values, first = ref$.first, flatten = ref$.flatten;
  util = require('util');
  h = require('helpers');
  p = require('bluebird');
  _ = require('underscore');
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
  exports.run = function(targets){
    var args, running, completed, execTargets;
    args = slice$.call(arguments, 1);
    running = {};
    h.dictMap(targets, function(target, name){
      h.uniMap(target.after, function(targetName){
        if (targets[targetName]) {
          return target.requires = h.push(target.requires, targetName);
        }
      });
      return h.uniMap(target.before, function(targetName){
        var targetTarget;
        if (targetTarget = targets[targetName]) {
          return targetTarget.requires = h.push(targetTarget.requires, name);
        }
      });
    });
    completed = {};
    execTargets = function(){
      return h.dictMap(targets, function(target, name){
        if (!_.without.apply(_, [target.requires].concat(slice$.call(keys(completed)))).length) {
          delete targets[name];
          return promisify(target.init).apply(null, args).then(function(data){
            completed[name] = data;
            return execTargets();
          });
        }
      });
    };
    return execTargets();
  };
}).call(this);