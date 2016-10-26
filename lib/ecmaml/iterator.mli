(** Implementation of an iterator *)

type 'a it_result =
  | Done
  (** [Done] is the representation of the javascript object \{ done: true \}.
      It's used when the iterator does not return any value and just want to
      mark the end. *)
  | Return of 'a
  (** [Return elt] is the representation of the javascript object \{ done: true,
      value: elt \}.
      It's used when the iterator has finished and want to return a value. *)
  | Yield of 'a
  (** [Yield elt] is the representation of the javascript object \{ done: false,
        value: elt \}. *)
(** The Type of the result of the iterator [next] function. *)

val identity : 'a -> 'b
(** [identity elt] returns the same ocaml value to an another type.
    It's usefull when translating the javascript value into the ocaml value when
    they share the same representation. For example, this function can be use to
    translates javascript integers into ocaml [int]. *)

module type Element = sig
  type elt
  (** Type of the element. *)

  val js_of_elt : elt -> Js.Unsafe.any
  (** [js_of_elt elt] translates the element [elt] into a javascript value. *)

  val elt_of_js : _ -> elt
  (** [elt_of_js js_value] translates the javascript value [js_value] into an
      ocaml value of type [elt]. *)
end


module type S = sig

  type elt
  (** Type of the element. *)

  type t = < next : unit -> elt it_result >
  (** The iterator itself. The [next] function call the underlying javascript
      next function of the iterator, and use the result to construct the
      ocaml value. *)

  val create : (unit -> elt it_result) -> t
  (** [create generator] creates a new javascript generator wrapped into the
      ocaml representation. *)

  val from_instance : 'a Js.t -> t
  (** [from_instance js_obj] takes an iterator object and wrapped it into the
      ocaml representation. *)

end


module Make(Elt : Element) : S with type elt := Elt.elt
(** Create an Iterator ocaml object, enabling to generate a new javascript
    iterator. *)
