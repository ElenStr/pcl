type name  = string


type un_op = U_plus | U_minus | U_not
type num_op  = O_plus | O_minus | O_times | O_division |O_div | O_mod
type eq_op  = O_eq | O_neq 
type cmp_op = O_gt | O_lt | O_geq | O_leq
type logic_op = O_and | O_or

type bin_op  = 
  |Num_op of num_op
  |Eq_op of eq_op
  |Cmp_op of cmp_op
  |Logic_op of logic_op


type const = INT of int|REAL of float |BOOL of bool |NIL|CHAR of string

type ast_decl = 
  | D_var of name list* Types.typ * Lexing.position
  | D_label of name list * Lexing.position
  | D_param of name list* Types.typ * Symbol.pass_mode * Lexing.position
  | D_header of name * Types.typ * ast_decl list * Lexing.position
  | D_fun of ast_decl * (ast_decl list * ast_stmt)

  and  ast_stmt =
  | S_block of ast_stmt list
  | S_assign of l_value * ast_expr * Lexing.position * Lexing.position
  | S_if of ast_expr * ast_stmt * ast_stmt option
  | S_while of ast_expr * ast_stmt
  | S_label of name * ast_stmt * Lexing.position
  | S_goto of name * Lexing.position
  | S_return 
  | S_call of ast_expr  
  | S_new_el of l_value * Lexing.position
  | S_new_array of ast_expr * l_value * Lexing.position
  | S_dispose_el of l_value * Lexing.position
  | S_dispose_array of l_value * Lexing.position
  | S_empty

and l_value = 
  | Var of name
  | String_const of string
  | Array_element of l_value * ast_expr
  | Deref of ast_expr
  | Res
and op_expr = 
  |At of ast_expr
  |Unary of un_op * ast_expr
  |Binary of ast_expr * bin_op * ast_expr


  and ast_expr =
  | Lval of l_value * Lexing.position
  | Const of const
  | Rval of op_expr * Lexing.position
  | E_call of name * ast_expr list * Lexing.position 

val decl_to_string : ast_decl -> string
val const_to_string : const -> string
val num_op_to_string : num_op -> string
val eq_op_to_string : eq_op -> string
val cmp_op_to_string : cmp_op -> string
val unop_to_string: un_op -> string
val bin_op_to_string : bin_op -> string
val logic_op_to_string : logic_op -> string
val lvalue_to_string : l_value -> string
val op_expr_to_string : op_expr ->string 
val expr_to_string : ast_expr -> string

(* val run : ast_stmt list -> unit *)
val print : ast_decl list * ast_stmt -> unit
