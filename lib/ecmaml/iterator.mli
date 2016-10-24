type 'a element =
  | Done
  | Return of 'a
  | Yield of 'a

module type Element = sig
  type elt
  val js_of_elt : elt -> Js.Unsafe.any
  val elt_of_js : Js.Unsafe.any -> elt
end

module type S = sig
  type elt
  type t = < next : unit -> elt element >
  val create : (unit -> elt element) -> t
end

module Make(Elt : Element) : S with type elt := Elt.elt
