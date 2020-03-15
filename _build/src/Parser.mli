
(* The type of tokens. *)

type token = 
  | T_while
  | T_var
  | T_true of (bool)
  | T_times
  | T_then
  | T_string_const of (string)
  | T_semicolon
  | T_rparen
  | T_return
  | T_result
  | T_real_const of (float)
  | T_real
  | T_rbracket
  | T_program
  | T_procedure
  | T_plus
  | T_or
  | T_of
  | T_not
  | T_nil
  | T_new
  | T_neq
  | T_name of (Ast.name)
  | T_mod
  | T_minus
  | T_lt
  | T_lparen
  | T_leq
  | T_lbracket
  | T_label
  | T_integer
  | T_int_const of (int)
  | T_if
  | T_gt
  | T_goto
  | T_geq
  | T_function
  | T_fullstop
  | T_forward
  | T_false of (bool)
  | T_eq
  | T_eof
  | T_end
  | T_else
  | T_do
  | T_division
  | T_div
  | T_dispose
  | T_comma
  | T_colon
  | T_char_const of (string)
  | T_char
  | T_caret
  | T_boolean
  | T_begin
  | T_at
  | T_assign
  | T_array
  | T_and

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.ast_decl list * Ast.ast_stmt )
