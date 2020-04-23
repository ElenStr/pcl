val printSymbolTable : unit -> unit
val checkSymbolTable : unit -> unit
val lib : Ast.ast_decl list
val param_ids : Ast.ast_decl -> Ast.name list
val param_type : Ast.ast_decl -> Types.typ
val param_mode: Ast.ast_decl -> Symbol.pass_mode
val str_to_char: string -> char
val flatten : string -> string -> string