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

  lense = (x) ->
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
    ls = specs.map (s) -> lense(s)
    ls.reduceRight (acc, l) -> compose acc, l

  module = ->
    args = Array.prototype.slice.call(arguments);
    path args

  module.lense = lense
  module.compose = compose
  module.modify = modify
  module.path = path
  module.zip = zip
  module

## TEST CODE

o =
  a:
    aa: 1
  b:
    bb: 2
  c:
    cc: [1,2]

a = [o, o]

l1 = L('a')
l2 = L('aa')
lC = L.compose(l2, l1)
lC2 = L.compose(L('cc'), L('c'))

console.log 'o:', o

console.log "\n# gets ..."
console.log 'o.a:', l1.get(o)
console.log '(wo/comp) o.a.aa:', l2.get(l1.get(o))
console.log 'o.a.aa:', lC.get(o)

console.log "\n# sets ..."
console.log 'o.a = 4:', l1.set(o, 4)
console.log 'o.a.aa = 4:', lC.set(o, 4)
console.log 'o.a.aa = []:', lC.set(o, [])
console.log 'o.c.cc = [3,4]:', do ->
  lC2.set o, [3,4]

console.log 'o.c.cc += [3,4]:', do ->
  L.modify lC2, o, (a) ->
    a.concat [3,4]

console.log 'o.c.cc[1] *= 2:', do ->
  l = L.compose L(1), lC2
  L.modify l, o, (n) -> n + n

console.log "\n# arrays ..."
console.log "a:", a
console.log "a[1]:", L(1).get a
console.log "a[1].a.aa = 'x':", do ->
  l = L.compose lC, L(1)
  l.set a, 'x'

console.log "\n# paths ..."
console.log "o.b.bb:", do ->
  L.path(['b', 'bb']).get o

console.log "o.b.bb = 30:", do ->
  L.path(['b', 'bb']).set o, 30

console.log "o.c.cc[0]:", do ->
  L.path(['c', 'cc', 0]).get o

## TODO predicate selectors in path, does it violate the laws?
#L('c', 'cc', (ix) -> ix == 4)
#L('a', (k) -> k == 'aa')
# could define ix() or k()

# TODO parallelisms, does it violate the laws?
#L(union('a', 'c'))

console.log "\n# zip ..."
console.log "[a.aa, d]", do ->
  lz = L.zip L('a', 'aa'), L('d')
  lz.get o

console.log "[a.aa, d] = [a.aa, a.aa]:", do ->
  lz = L.zip L('a', 'aa'), L('d')
  [x, _y] = lz.get o
  lz.set o, [x, x]

console.log "mod [a.aa, d] = [a.aa, a.aa]:", do ->
  lz = L.zip L('a', 'aa'), L('d')
  [x, _y] = lz.get o
  lz.set o, [x, x]
