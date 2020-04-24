val find_all_vars : Ast.ast_decl list -> Llvm.lltype array -> Llvm.lltype array
val new_frame : Llvm.lltype array * int-> unit
val find_function_scope :Ast.ast_decl -> Ast.ast_decl list -> Llvm.lltype array * int