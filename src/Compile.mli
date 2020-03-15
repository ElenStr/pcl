(* val compile_decl : Ast.ast_decl -> unit *)
val compile_var_decl : Ast.name -> Types.typ -> Llvm.llvalue
val compile_proto : string -> Types.typ -> Ast.ast_decl list -> Llvm.llvalue
val compile_header : Symbol.llvm_val-> Ast.ast_decl list -> unit
val compile_ret : Ast.ast_decl -> Llvm.llbasicblock -> unit 
val compile_while : Ast.ast_expr -> Llvm.llbasicblock * Llvm.llbasicblock
val compile_while_end : Llvm.llbasicblock -> Llvm.llbasicblock -> unit
val compile_main : bool -> unit
val compile_label: string -> Llvm.llbasicblock
val compile_label_after: string -> Symbol.llvm_val -> Lexing.position -> unit
val compile_goto: Symbol.llvm_val-> string -> Lexing.position ->  unit
val compile_assign: Ast.l_value-> Ast.ast_expr -> Lexing.position -> unit
val compile_new_el: Ast.l_value -> Types.typ -> Lexing.position -> unit
val compile_dispose_el: Ast.l_value -> Lexing.position -> unit
val compile_new_array: Ast.ast_expr -> Ast.l_value -> Types.typ -> Lexing.position -> unit
val compile_dispose_array: Ast.l_value -> Lexing.position -> unit
val compile_main_ret : unit -> unit

val llvm_int : int -> Llvm.llvalue

val create_ret_block : unit -> Symbol.llvm_val
val compile_return : unit -> unit
val get_main : unit -> Llvm.llvalue