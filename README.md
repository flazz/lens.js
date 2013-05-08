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
    bb: [3,4[
  }
}
```

lens to focus on a member by 'a'

```js
var l = L('a')
```

get what we are focusing on

```js
l.get(o) // => { aa: 1 }
```

make a new object with what we are focusing on changed

```js
l.set(o, 'x') // => { a: 'x', b: { bb: 2 }, c: { cc: [1, 2] } }
```
