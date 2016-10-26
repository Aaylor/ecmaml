open Ecmaml.Iterator

module IntIterator =
  Ecmaml.Iterator.Make(struct
    type elt = int
    let js_of_elt = Js.Unsafe.inject
    let elt_of_js = identity
  end)

let iterator =
  let x = ref 0 in
  let generator () =
    if !x < 10 then begin
      let old = !x in
      incr x;
      Yield old
    end else Done
  in
  IntIterator.create generator

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
