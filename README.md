lens.js
=======

javascript lenses, wip

example
-------

An arbitrarily complex object

```js
var o = {
  a: {
    aa: 1
  },
  b: {
    bb: [3,4]
  }
}
```

lens to focus on a member by 'a'

```js
var l = L.lens('a')
l.get(o) // => { aa: 1 }
l.set(o, 'x') // => { a: 'x', b: { bb: 2 }, c: { cc: [1, 2] } }
```

compose lenses like functions

```js
var l1 = L('a') // same as L.lens('a')
var l2 = L('aa')
var l = L.compose(l2, l1)
l.get(o) // =>  1
l.set(o, 99) // => { a: { aa: 99 }, b: { bb: [3,4] } }
```

map a value through a lense

```js
var l = L('b', 'bb') // same as L.compose(L('bb'), L('b')), think xpath

L.modify(l, o, function (v) {
    return v.concat(99);
}) // => { a: { aa: 1 }, b: { bb: [3,4,99] } }
```
