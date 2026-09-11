(* With -c there is no link step.  Barry must still merge the units a
 * compilation unit is compiled into -- one for the source file and one for
 * each functor application in it -- into a single Core ML file.
 * -c compiles a file on its own, without the Basis Library, so this program
 * uses nothing but the Core language. *)

datatype t = A | B of t

functor F (val x : t) =
  struct
    val y = B x
    fun g z = (x, z)
  end

structure S1 = F (val x = A)
structure S2 = F (val x = B A)

val p = S1.g S2.y
