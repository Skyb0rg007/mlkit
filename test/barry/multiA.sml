(* Unit A of a multi-unit project; unit B refers to these across compilation
 * unit boundaries, so Barry must print each name the same way in both. *)

signature SHAPE =
  sig
    type t
    val make : int -> t
    val area : t -> int
    val name : string
  end

structure Square : SHAPE =
  struct
    type t = int
    fun make s = s
    fun area s = s * s
    val name = "square"
  end

functor Twice (S : SHAPE) =
  struct
    fun twice x = S.area x + S.area x
    val label = S.name ^ "*2"
  end

datatype 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

exception NotFound of int

fun insert (Leaf, x) = Node (Leaf, x, Leaf)
  | insert (Node (l,y,r), x) =
      if x < y then Node (insert (l,x), y, r) else Node (l, y, insert (r,x))

fun find (Leaf, x) = raise NotFound x
  | find (Node (l,y,r), x) =
      if x = y then y else if x < y then find (l,x) else find (r,x)

fun toList Leaf acc = acc
  | toList (Node (l,x,r)) acc = toList l (x :: toList r acc)
