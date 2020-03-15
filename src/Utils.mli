val ret_block_of:unit -> Llvm.llbasicblock
val ret_block_of_id : string -> Lexing.position -> Llvm.llbasicblock
val ret_block_of_hd : Ast.ast_decl -> Llvm.llbasicblock
val printSymbolTable : unit -> unit
val checkSymbolTable : unit -> unit
val lib : Ast.ast_decl list
val param_ids : Ast.ast_decl -> Ast.name list
val param_type : Ast.ast_decl -> Types.typ
val param_mode: Ast.ast_decl -> Symbol.pass_mode