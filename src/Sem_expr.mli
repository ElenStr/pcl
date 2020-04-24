val sem_expr: Ast.ast_expr -> Types.typ
val sem_lvalue:  Ast.l_value -> Lexing.position -> Types.typ
val sem_const : Ast.const  -> Types.typ