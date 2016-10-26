
let symbol = Js.Unsafe.global##._Symbol

type symbol

let has_instance = symbol##.hasInstance

let is_concat_spreadable = symbol##.isConcatSpreadable

let iterator = symbol##.iterator

let match_ = Js.Unsafe.get symbol "match"

let prototype = symbol##.prototype

let replace = symbol##.replace

let search = symbol##.search

let species = symbol##.species

let split = symbol##.split

let to_primitive = symbol##.toPrimitive

let to_string_tag = symbol##.toStringTag

let unscopables = symbol##.unscopables

let for_ key =
  Js.Unsafe.meth_call symbol "for" [| Js.Unsafe.inject (Js.string key) |]

let key_for symbol =
  Js.Unsafe.meth_call symbol "keyFor" [| Js.Unsafe.inject symbol |]

let to_string symbol =
  let s = Js.Unsafe.meth_call symbol "toString" [| Js.Unsafe.inject symbol |] in
  Js.to_string s
