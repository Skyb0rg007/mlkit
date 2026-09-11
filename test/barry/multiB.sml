(* Unit B: uses unit A's values, constructors, exception, type and functor. *)

structure T = Twice (Square)

fun build (nil, t) = t
  | build (x::xs, t) = build (xs, insert (t, x))

val t = build ([5,3,8,1,9], Leaf)

val () = print (implode (map (fn i => chr (48+i)) (toList t nil)) ^ "\n")
val () = print (Int.toString (find (t, 8)) ^ "\n")
val () = print (((Int.toString (find (t, 4))) handle NotFound k => "NotFound " ^ Int.toString k) ^ "\n")
val () = print (Int.toString (T.twice (Square.make 3)) ^ " " ^ T.label ^ "\n")
