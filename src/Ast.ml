open Printf
open Types
open Symbol


type name  = string


type un_op = U_plus | U_minus | U_not
type num_op  = O_plus | O_minus | O_times | O_division |O_div | O_mod
type eq_op  = O_eq | O_neq 
type cmp_op = O_gt | O_lt | O_geq | O_leq
type logic_op = O_and | O_or

type bin_op  = 
    Num_op of num_op
  |Eq_op of eq_op
  |Cmp_op of cmp_op
  |Logic_op of logic_op


type const = INT of int|REAL of float |BOOL of bool |NIL|CHAR of string

type ast_decl = 
  | D_var of name list* typ * Lexing.position 
  | D_label of name list * Lexing.position
  | D_param of name list* typ * pass_mode * Lexing.position
  | D_header of name * typ * ast_decl list * Lexing.position
  | D_fun of ast_decl * (ast_decl list * ast_stmt)

and  ast_stmt =
| S_block of ast_stmt list
| S_assign of l_value * ast_expr * Lexing.position* Lexing.position
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

let string_list  li = List.fold_right(fun x y-> x^","^y ) li ""
let mode_to_string m = match m with PASS_BY_REFERENCE -> "ref" | _ -> "val"

let rec decl_to_string decl = 
  match decl with 
  | D_var (ids, t, _) -> (string_list ids)^"type:"^(pcl_type_str t)
  | D_label (ids ,_)-> (string_list ids)

  | D_param (ids , t , m, _) -> "\n\t,PARAM("^(string_list ids)^"type:"^(pcl_type_str t)^",mode :"^(mode_to_string m)^")"
  | D_header (id, t, params, _) -> id^","^(pcl_type_str t)^(List.fold_right (fun x y -> (decl_to_string x)^y ) params "")
  | _ ->""


let const_to_string c = 
  match c with 
  | INT n -> "int("^string_of_int n^")"
  | REAL r -> "real("^string_of_float r^")"
  | CHAR ch -> "char("^ch^")"
  | BOOL b -> "bool("^string_of_bool b^")"
  | NIL -> "NIL"
let num_op_to_string n =
  match n with O_plus  -> "+"| O_minus  ->"-"
  | O_times -> "*" | O_division->"/" |O_div  ->"div" | O_mod ->"mod"
let eq_op_to_string e = match e with O_eq ->"=" | _ ->"<>"

let cmp_op_to_string c =
  match c with  O_gt -> ">" | O_lt -> "<"| O_geq ->">="| O_leq->"<="

let logic_op_to_string l = match l with O_and -> "and" | _ ->"or"
let unop_to_string op = 
match op with U_plus -> "+"|U_minus -> "-"| U_not -> "Not"

let bin_op_to_string op =
match op with 
| Num_op n -> num_op_to_string n
| Eq_op e -> eq_op_to_string e
| Cmp_op c -> cmp_op_to_string c
| Logic_op l -> logic_op_to_string l

let rec lvalue_to_string lval = 
  match lval with 
  | Var name -> "Var("^name^")"
  | String_const str -> "str("^str^")"
  | Array_element (lv,ex) -> "Array("^(lvalue_to_string lv)^","^(expr_to_string ex)^")"
  | Deref e -> "Deref("^(expr_to_string e)^")"
  | Res -> "RESULT"
and op_expr_to_string ope  =
  match ope with 
  | At e -> "address("^(expr_to_string e)^")"
  | Unary(op,e) -> (unop_to_string op)^"("^(expr_to_string e)^")"
  | Binary (e1,op,e2) -> (bin_op_to_string op)^"("^(expr_to_string e1)^","^(expr_to_string e2)^")"

and expr_to_string expr =
match expr with
| Lval (lv,_) -> lvalue_to_string lv
| Const c -> const_to_string c
| Rval (rv,_) -> op_expr_to_string rv
| E_call (id, params,_) -> "Call("^id^","^(List.fold_right (fun x y -> (expr_to_string x)^","^y ) params "")^")"





let rec print_decl ast =
  match ast with
  | D_var (ids, t, _) -> printf "\nIDS(%s)" (decl_to_string ast)

  | D_label (ids,_ )-> printf "\nLABELS(%s)" (decl_to_string ast)

  | D_param (ids , t , m, _) ->  printf "%s" (decl_to_string ast) 

  | D_header (id, t, params, _) -> printf "\nHEADER(%s)" (decl_to_string ast)
  | D_fun (hd, (locals,bd)) -> print_decl hd;  List.iter print_decl locals; print_stmt bd                              





and  print_stmt stmt =
  match stmt with
  | S_block stmts -> printf "\nBLOCK("; List.iter print_stmt stmts; printf " )" 
  | S_assign (lv, e,_,_) -> printf "\n\tAssign(%s,%s)" (lvalue_to_string lv) (expr_to_string e)
  | S_if (e, s, None) -> printf "\n\tIf( %s," (expr_to_string e);
    print_stmt s;
    printf " )"
  | S_if (e, s1, Some(s2)) -> printf "\n\tIf( %s," (expr_to_string e);
    print_stmt s1;
    printf ",\n\telse,";
    print_stmt s2;
    printf " )"
  | S_while (e,s) -> printf "\n\tWhile(  %s," (expr_to_string e);
    
    print_stmt s;
    printf " )" 
  | S_label (id, s,_) -> printf "\n\tLabel(%s" id;
    print_stmt s;
    printf " )" 
  | S_goto (id,_) -> printf "\n\tGoto(%s)" id 
  | S_return -> printf "\n\tReturn"  
  | S_call call -> printf "\n\t";print_expr call                
  | S_new_el (e,_) -> printf "\n\tNew(%s)" (lvalue_to_string e) 
  | S_new_array (n, e,_) -> printf "\n\tNewArray(%s,%s)" (expr_to_string n)  (lvalue_to_string e)
  | S_dispose_el (id,_) -> printf "\n\tDispose(%s)" (lvalue_to_string id )
  | S_dispose_array (id,_) -> printf "\n\tDisposeArray(%s)" (lvalue_to_string id )
  | S_empty -> ()
 
and  print_expr e =
  printf "%s" (expr_to_string e)



and print (decls,stmts) = List.iter print_decl decls;print_stmt stmts


