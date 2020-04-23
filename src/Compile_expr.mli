val builder : Llvm.llbuilder
val context : Llvm.llcontext
val the_module : Llvm.llmodule
val frame_pointers : Llvm.llvalue Stack.t
val the_fpm : [ `Module ] Llvm.PassManager.t
val llvm_type : Types.typ -> Llvm.lltype
val get_val_ptr : Ast.l_value -> Lexing.position -> Llvm.llvalue
val compile_expr : Ast.ast_expr -> Llvm.llvalue
val compile_lvalue : Ast.l_value -> Lexing.position -> Llvm.llvalue
val compile_if_then : ?compile_cond:bool -> ?casted_cond:Llvm.llvalue -> Ast.ast_expr -> Llvm.llbasicblock * Llvm.llbasicblock
val compile_else : Llvm.llbasicblock * Llvm.llbasicblock -> unit
val compile_merge : Llvm.llbasicblock -> unit
