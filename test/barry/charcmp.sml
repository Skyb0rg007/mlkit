(* Comparisons on char and Word8.word are primitives that Barry must print
 * as the corresponding infix operators. *)

fun yn b = if b then "y" else "n"

fun cmp (a : char, b : char) =
    yn (a < b) ^ yn (a <= b) ^ yn (a > b) ^ yn (a >= b) ^ yn (a = b)

fun cmp8 (a : Word8.word, b : Word8.word) =
    yn (a < b) ^ yn (a <= b) ^ yn (a > b) ^ yn (a >= b) ^ yn (a = b)

val () = print (cmp (#"a", #"b") ^ "\n")
val () = print (cmp (#"b", #"a") ^ "\n")
val () = print (cmp (#"a", #"a") ^ "\n")
val () = print (cmp8 (0w1, 0w2) ^ "\n")
val () = print (cmp8 (0w2, 0w1) ^ "\n")
val () = print (cmp8 (0w2, 0w2) ^ "\n")
