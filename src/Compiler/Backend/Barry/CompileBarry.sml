(* Standard ML Barifyer *)

signature COMPILE_BARRY =
  sig
    (* Compiler for compiling structure declarations that do not contain
     * functor applications. If no code is generated, only a CEnv is
     * returned. *)

    include COMPILE_GEN
    where type target = LambdaExp.LambdaPgm

    (* emit: writes one compilation unit and returns the filename it wrote.
     * The units of a source file are concatenated into a single Core ML file
     * by ExecutionBarry.link_files_with_runtime_system. *)
    val emit : {target: target, filename: string} -> string
  end


structure CompileBarry: COMPILE_BARRY =
  struct
    structure CompBasis = CompBasisToLamb
    structure PP = PrettyPrint

    structure CE = CompilerEnv

    type CompBasis = CompBasis.CompBasis
    type CEnv = CompileToLamb.CEnv
    type strdec = CompileToLamb.strdec
    type funid = CompileToLamb.funid
    type strid = CompileToLamb.strid
    type Env = CompileToLamb.Env
    type strexp = CompileToLamb.strexp
    type LambdaPgm = CompileToLamb.target
    type target = LambdaPgm

    fun die s = Crash.impossible ("CompileBarry." ^ s)

    (* the extension of a compilation unit; not ".sml", so that a Core ML file
     * and the units it is made of can live in the same directory *)
    val unit_ext = ".unit"

    val preHook = CompileToLamb.preHook
    val postHook = CompileToLamb.postHook

    local
      val messages_p = Flags.is_on0 "messages"
    in
      fun message f = if messages_p() then print (f())
                      else ()
    end

    (*****************************)
    (* This is the main function *)
    (*****************************)

    datatype res = CodeRes of CEnv * CompBasis * LambdaPgm * bool
                 | CEnvOnlyRes of CEnv

    fun compile fe (CEnv, Basis, strdecs) : res =
        case CompileToLamb.compile fe (CEnv,Basis,strdecs)
         of CompileToLamb.CEnvOnlyRes CEnv1 => CEnvOnlyRes CEnv1
          | CompileToLamb.CodeRes (CEnv1, Basis1, lamb_opt, safe) =>
            CodeRes (CEnv1, Basis1, lamb_opt, safe)

    fun emit {target: LambdaPgm, filename} : string =
	let val filename = filename ^ unit_ext
	    val colwidth = 100
	    val st = LambdaExp.barify target
	    val os = TextIO.openOut filename
	in  (PP.outputTree' (fn n => "(*" ^ Int.toString n ^ "*)")
	                    (fn s => TextIO.output(os,s), st, colwidth);
	     TextIO.output(os, "\n\n");
	     TextIO.closeOut os;
	     message (fn () => "[wrote ML unit:\t" ^ filename ^ "]\n");
	     filename) handle X => (TextIO.closeOut os; raise X)
	end

    type longid = CompileToLamb.longid
    type lvar = CE.lvar

    datatype cval = datatype CompileToLamb.cval
    fun retrieve_longid _ _ _ : lvar cval =
        die "retrieve_longid.not implemented"

  end
