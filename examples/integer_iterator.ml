
open Ecmaml.Iterator

module IntElement = struct
  type elt = int
  let js_of_elt = Js.Unsafe.inject
  let elt_of_js i = Obj.magic i
end

module IntIterator = Make(IntElement)

let iterator =
  let x = ref 0 in
  IntIterator.create
    (fun () ->
       if !x < 10 then begin
         let old_x = !x in
         incr x;
         Yield old_x
       end else Done)

let print = function
  | Done -> Printf.printf "Done\n"
  | Yield i -> Printf.printf "Yield %d\n" i
  | Return i -> Printf.printf "Return %d\n" i

let rec repeat () =
  let v = iterator#next () in
  print v;
  match v with
  | Done | Return _ -> ()
  | Yield _ -> repeat ()

let () = repeat ()
