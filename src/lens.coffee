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

  zip = (l1, l2) ->
    get: (o) -> [
      l1.get o
      l2.get o
    ]

    set: (o, vs) ->
      [v1, v2] = vs
      console.log vs
      o2 = l1.set o, v1
      l2.set o2, v2

  modify = (l, o, f) ->
    v = l.get o
    v2 = f(v)
    l.set o, v2

  path = (specs) ->
    ls = specs.map (s) -> lens(s)
    ls.reduceRight (acc, l) -> compose acc, l

  module = ->
    args = Array.prototype.slice.call(arguments);
    path args

  module.lens = lens
  module.compose = compose
  module.modify = modify
  module.path = path
  module.zip = zip
  module

window.L = L
