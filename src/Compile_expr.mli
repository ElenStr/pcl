val compile_expr : Ast.ast_expr -> Llvm.llvalue
val compile_lvalue : Ast.l_value -> Lexing.position -> Llvm.llvalue
val llval :  Symbol.llvm_val -> Llvm.llvalue
val get_val_ptr : Ast.l_value -> Lexing.position -> Llvm.llvalue
val llvm_type : Types.typ -> Llvm.lltype
val compile_if_then : Ast.ast_expr -> Llvm.llbasicblock * Llvm.llbasicblock 
val compile_else : Llvm.llbasicblock * Llvm.llbasicblock -> unit
val compile_merge : Llvm.llbasicblock -> unit

val builder : Llvm.llbuilder
val context : Llvm.llcontext
val the_module : Llvm.llmodule

val frame_pointers : Llvm.llvalue Stack.t
val the_fpm : [ `Module ] Llvm.PassManager.t


val cast_to_compatible:Llvm.llvalue -> Llvm.llvalue -> Llvm.llvalue

val fix_offset  : Symbol.entry_info -> int -> unit
  

val  llvm_type  : Types.typ -> Llvm.lltype