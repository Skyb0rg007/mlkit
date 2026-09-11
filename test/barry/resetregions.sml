(* resetRegions and forceResetting have no Standard ML counterpart, so Barry
 * must erase them rather than print them as identifiers. *)

fun sum (l : int list) =
    let fun go (nil, a) = a
          | go (x::xs, a) = go (xs, a+x)
    in go (l, 0)
    end

fun f n =
    let val l = [n, n+1, n+2]
        val s = sum l
    in resetRegions l; s
    end

fun g n =
    let val l = [n, n*2]
        val s = sum l
    in forceResetting l; s
    end

val () = print (Int.toString (f 1) ^ "\n")
val () = print (Int.toString (g 3) ^ "\n")
