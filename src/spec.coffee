o =
  a:
    aa: 1
  b:
    bb: 2
  c:
    cc: [1,2]

describe 'lens.js', ->
  o = null
  a = null
  l = null

  describe 'arrays focus via indexes', ->
    beforeEach ->
      o = [1, 2, 3]
      l = L.lens(2)

    it 'get the focus', ->
      expect(l.get o).toEqual 3

    it 'set the focus', ->
      expect(l.set o, 0).toEqual [1,2,0]

  describe 'objects focus via keys', ->
    beforeEach ->
      o = a: 0, b: 1
      l = L.lens('a')

    it 'get the focus', ->
      expect(l.get o).toEqual 0

    it 'set the focus', ->
      expect(l.set o, 2).toEqual {a: 2, b: 1}

  describe 'composition', ->
    beforeEach ->
      o = {a: [100, 200]}
      l = L.compose L.lens(0), L.lens('a')

    it 'focus on the focus (of another lens)', ->
      expect(l.get o).toEqual 100
      expect(l.set o, 1).toEqual {a: [1, 200]}

    it 'can compose a path of foci', ->
      lPath = L.path(['a', 0])
      expect(lPath.get o).toEqual l.get(o)
      expect(lPath.set o, 1).toEqual l.set(o, 1)

    it 'calling L is a shorthand for path', ->
      lPath = L.path(['a', 0])
      lCall = L('a', 0)
      expect(lCall.get o).toEqual lPath.get(o)
      expect(lCall.set o, 1).toEqual lPath.set(o, 1)

  describe 'modify', ->
    it 'sets a function of get', ->
      o = a: 0
      l = L.lens('a')
      o2 = L.mod l, o, (v) -> v + 1
      expect(o2).toEqual(a: 1)

  describe 'zip', ->
    it 'focus on many lenses at once', ->
      o = {xs: [100, 200]}
      l = L.zip L('xs'), L('ys'), L('zs') # TODO varargs
      expect(l.get o).toEqual [[100, 200], undefined, undefined]
      expect(l.set o, [1, 2, 3]).toEqual {xs: 1, ys: 2, zs: 3}


### TODO predicate selectors in path, does it violate the laws?
##L('c', 'cc', (ix) -> ix == 4)
##L('a', (k) -> k == 'aa')
## could define ix() or k()

## TODO parallelisms, does it violate the laws?
##L(union('a', 'c'))

#console.log "\n# zip ..."
#console.log "[a.aa, d]", do ->
  #lz = L.zip L('a', 'aa'), L('d')
  #lz.get o

#console.log "[a.aa, d] = [a.aa, a.aa]:", do ->
  #lz = L.zip L('a', 'aa'), L('d')
  #[x, _y] = lz.get o
  #lz.set o, [x, x]

#console.log "mod [a.aa, d] = [a.aa, a.aa]:", do ->
  #lz = L.zip L('a', 'aa'), L('d')
  #[x, _y] = lz.get o
  #lz.set o, [x, x]
