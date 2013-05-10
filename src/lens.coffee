L = do ->
  ary = (ix) ->
    get: (a) -> a[ix]
    set: (a, v) ->
      a2 = Array.apply null, a
      a2[ix] = v
      a2

  obj = (k) ->
    get: (o) -> o[k]
    set: (o, v) ->
      o2 = {}
      for k2 of o
        o2[k2] = o[k2]
      o2[k] = v
      o2

  lens = (x) ->
    c =
      switch (typeof x)
        when 'number' then ary
        when 'string' then obj
    c x

  compose = (l2, l1) ->
    get: (o) -> l2.get(l1.get(o))
    set: (o, v) ->
      o2 = l1.get o
      l1.set(o, l2.set(o2, v))

  zip = ->
    ls = Array.prototype.slice.call arguments

    get: (o) ->
      ls.map (l) ->
        l.get o

    set: (o, vs) ->
      ls.reduce (acc, l, ix) ->
        l.set acc, vs[ix]
      , o

  mod = (l, o, f) ->
    v = l.get o
    v2 = f(v)
    l.set o, v2

  path = (specs) ->
    ls = specs.map (s) -> lens(s)
    ls.reduceRight (acc, l) -> compose acc, l

  module = ->
    args = Array.prototype.slice.call arguments
    path args

  module.lens = lens
  module.compose = compose
  module.mod = mod
  module.path = path
  module.zip = zip
  module
