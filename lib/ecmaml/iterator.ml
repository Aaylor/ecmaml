
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

module Make(Elt : Element) : S with type elt := Elt.elt = struct
  type instance
  type elt = Elt.elt
  type t = < next : unit -> elt element; >

  class iterator_obj (instance : instance Js.t) = object
    method next () : elt element =
      let result = Js.Unsafe.fun_call (Js.Unsafe.coerce instance)##.next [||] in
      let done_ = Js.to_bool (Js.Unsafe.get result "done") in
      if done_ then
        match Js.Optdef.to_option result##.value with
        | None -> Done
        | Some e -> Return (Elt.elt_of_js e)
      else Yield (Elt.elt_of_js result##.value)
  end

  let make_element_obj ?value done_ =
    let value =
      match value with
      | None -> [||]
      | Some e -> [| "value", Elt.js_of_elt e |]
    in
    let done_ = [| "done", Js.Unsafe.inject (Js.bool done_) |] in
    Array.append done_ value

  let wrap_generator generator () =
    let o =
      match generator () with
      | Done -> make_element_obj true
      | Return e -> make_element_obj ~value:e true
      | Yield e -> make_element_obj ~value:e false
    in
    Js.Unsafe.obj o

  let create generator =
    let wrapper = wrap_generator generator in
    let callback = Js.Unsafe.(inject (callback wrapper)) in
    let o = Js.Unsafe.obj [| "next", callback |] in
    new iterator_obj o

  let from_instance instance =
    match Js.Optdef.to_option instance##.next with
    | None -> failwith "incorrect instance"
    | Some t -> new iterator_obj t
end
