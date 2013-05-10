// Generated by CoffeeScript 1.4.0
var L;

L = (function() {
  var ary, compose, lens, mod, module, obj, path, zip;
  ary = function(ix) {
    return {
      get: function(a) {
        return a[ix];
      },
      set: function(a, v) {
        var a2;
        a2 = Array.apply(null, a);
        a2[ix] = v;
        return a2;
      }
    };
  };
  obj = function(k) {
    return {
      get: function(o) {
        return o[k];
      },
      set: function(o, v) {
        var k2, o2;
        o2 = {};
        for (k2 in o) {
          o2[k2] = o[k2];
        }
        o2[k] = v;
        return o2;
      }
    };
  };
  lens = function(x) {
    var c;
    c = (function() {
      switch (typeof x) {
        case 'number':
          return ary;
        case 'string':
          return obj;
      }
    })();
    return c(x);
  };
  compose = function(l2, l1) {
    return {
      get: function(o) {
        return l2.get(l1.get(o));
      },
      set: function(o, v) {
        var o2;
        o2 = l1.get(o);
        return l1.set(o, l2.set(o2, v));
      }
    };
  };
  zip = function() {
    var ls;
    ls = Array.prototype.slice.call(arguments);
    return {
      get: function(o) {
        return ls.map(function(l) {
          return l.get(o);
        });
      },
      set: function(o, vs) {
        return ls.reduce(function(acc, l, ix) {
          return l.set(acc, vs[ix]);
        }, o);
      }
    };
  };
  mod = function(l, o, f) {
    var v, v2;
    v = l.get(o);
    v2 = f(v);
    return l.set(o, v2);
  };
  path = function(specs) {
    var ls;
    ls = specs.map(function(s) {
      return lens(s);
    });
    return ls.reduceRight(function(acc, l) {
      return compose(acc, l);
    });
  };
  module = function() {
    var args;
    args = Array.prototype.slice.call(arguments);
    return path(args);
  };
  module.lens = lens;
  module.compose = compose;
  module.mod = mod;
  module.path = path;
  module.zip = zip;
  return module;
})();
