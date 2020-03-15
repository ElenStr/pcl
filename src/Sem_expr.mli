val sem_expr: Ast.ast_expr -> Types.typ
val sem_lvalue:  Ast.l_value -> Lexing.position -> Types.typ
val check_params: Symbol.entry list -> Ast.ast_expr list -> Lexing.position -> bool
val check_bounds: int -> Ast.ast_expr -> bool
val sem_const : Ast.const  -> Types.typ
