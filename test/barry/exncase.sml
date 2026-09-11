(* Barry must print patterns for exception constructors that carry a value
 * with an argument pattern, and must not print a deexcon primitive. *)

exception Nullary
exception Payload of int
exception Pair of string * int

fun raiser 0 = raise Nullary
  | raiser 1 = raise Payload 42
  | raiser 2 = raise Pair ("two", 7)
  | raiser 3 = raise Fail "failed"
  | raiser n = n

fun test n =
    Int.toString (raiser n)
    handle Nullary => "Nullary"
         | Payload k => "Payload " ^ Int.toString k
         | Pair (s,k) => "Pair " ^ s ^ " " ^ Int.toString k
         | Fail s => "Fail " ^ s

val () = print (test 0 ^ "\n")
val () = print (test 1 ^ "\n")
val () = print (test 2 ^ "\n")
val () = print (test 3 ^ "\n")
val () = print (test 9 ^ "\n")
