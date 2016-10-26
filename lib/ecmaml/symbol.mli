(** Symbol implementation. *)


type symbol
(** Representation of the symbol type. *)


(** {2 Properties} *)

val has_instance : symbol

val is_concat_spreadable : symbol

val iterator : symbol

val match_ : symbol

val prototype : symbol

val replace : symbol

val search : symbol

val species : symbol

val split : symbol

val to_primitive : symbol

val to_string_tag : symbol

val unscopables : symbol


(** {2 Methods} *)

val for_ : string -> symbol

val key_for : symbol -> string

val to_string : symbol -> string
