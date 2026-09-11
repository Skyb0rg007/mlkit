(* Barry must print char and word patterns as char and word constants,
 * not as integer constants. *)

fun classify c =
    case c of
        #"a" => "a"
      | #"\n" => "nl"
      | #"\"" => "quote"
      | #"\\" => "backslash"
      | _ => "other"

fun small (w : word) =
    case w of
        0w0 => "zero"
      | 0w1 => "one"
      | 0wxFF => "ff"
      | _ => "many"

fun byte (w : Word8.word) =
    case w of
        0w0 => "z"
      | 0wx7F => "d"
      | _ => "b"

val () = print (classify #"a" ^ " " ^ classify #"\n" ^ " " ^ classify #"\"" ^ " "
                ^ classify #"\\" ^ " " ^ classify #"z" ^ "\n")
val () = print (small 0w0 ^ " " ^ small 0w1 ^ " " ^ small 0wxFF ^ " " ^ small 0w7 ^ "\n")
val () = print (byte 0w0 ^ " " ^ byte 0wx7F ^ " " ^ byte 0w3 ^ "\n")
