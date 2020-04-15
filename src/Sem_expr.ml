open Printf
open Ast

open Format
open Error
open Utils
open Identifier
open Types
open Symbol
exception Invalid

let sem_const c = 
  match c with 
  | INT n -> TYPE_int
  | REAL r -> TYPE_real
  | CHAR ch ->  TYPE_char
  | BOOL b -> TYPE_bool
  | NIL -> TYPE_ptr TYPE_none

let rec  sem_lvalue lv pos = 
  match lv with 
  | Var id -> 
    begin
      match (lookupEntry (id_make id) LOOKUP_ALL_SCOPES true pos).entry_info with
      |ENTRY_variable inf -> inf.variable_type
      |ENTRY_parameter inf -> inf.parameter_type
      | _ -> (error "%a %s is not a variable" print_position (position_point pos) id; raise Exit)
    end
  | String_const str -> TYPE_array(TYPE_char,Some(((String.length str)+1)))
  | Array_element (l,e) -> 
    begin
      let check_bounds n e =
        match e with
        | Const INT ne -> (ne>=0)&&(ne<n)
        | _ -> true in
      match ((sem_lvalue l pos),( sem_expr e)) with
      | (TYPE_array(t,Some(n)),TYPE_int) when check_bounds n e -> t
      | (TYPE_array(t,Some(n)),TYPE_int) -> (error "%a Index out \
      of bound" print_position (position_point pos); raise Exit)

      | (TYPE_array(t,_),TYPE_int) -> t

      | _ -> (error "%a Invalid array \
                     expression " print_position (position_point pos); raise Exit)

    end
  | Deref e -> 
    begin
      match (sem_expr e) with 
      | TYPE_ptr TYPE_none -> (error "%a Expression must not be nil"
                                 print_position (position_point pos); raise Exit)
      | TYPE_ptr t -> t
      | _ -> (error "%a Expression must be of type pointer \
                     %s" print_position (position_point pos) (expr_to_string e); raise Exit)
    end
  | Res -> 
    begin
      match (lookupEntry (id_make "result") LOOKUP_ALL_SCOPES true pos).entry_info with
      |ENTRY_variable inf -> inf.variable_type
      | _ -> (error "Result not found";raise Exit ) (*unreached*)
    end

and sem_unop unop e pos =
  let t = sem_expr e in
  match unop with 
  | U_not when equalType t TYPE_bool -> t
  | U_not  -> (error "%a Operand must be \
                      boolean" print_position (position_point pos); TYPE_bool)
  | _ when is_numerical t -> t
  | _ -> (error "%a Operand must be \
                 numerical" print_position (position_point pos); raise Exit)

and num_op_expr op e1 e2 pos = 
  let t1, t2 = (sem_expr e1), sem_expr e2 in
  match ((is_numerical t1, is_numerical t2)) with
  | (true,true)->
    begin
      match (t1, t2, op) with 
      | (_,_,O_division) -> TYPE_real
      | (TYPE_int, TYPE_int, _ ) -> TYPE_int
      | (_, _, (O_mod|O_div) ) ->(error "%a Operands must be \
                                         integers" print_position (position_point pos); TYPE_int)
      | _ -> TYPE_real
    end
  | _ -> (error "%a Operands must be \
                 numerical" print_position (position_point pos); raise Exit)

and eq_op_expr op e1 e2 pos=
  match ((sem_expr e1, sem_expr e2)) with
  | (t1, t2) when (equalType t1 t2 ) -> 
    begin
      match t1 with TYPE_array(_,_) -> (error "%a Operands must not be \
                                               of type array " print_position (position_point pos); raise Exit) 
                  | _ -> TYPE_bool
    end
  | (t1, t2) when (is_numerical t1)&&(is_numerical t2) -> TYPE_bool
  | _ -> (error "%a Operands must be of same type or numerical" print_position (position_point pos); raise Exit)

and cmp_op_expr op e1 e2 pos =
  match ((is_numerical (sem_expr e1)), (is_numerical (sem_expr e2))) with
  | (true, true ) -> TYPE_bool
  | _ -> (error "%a Operands must be \
                 numerical" print_position (position_point pos); raise Exit)

and logic_op_expr op e1 e2 pos =
  match ((sem_expr e1), (sem_expr e2)) with
  | (TYPE_bool, TYPE_bool ) -> TYPE_bool
  | _ -> (error "%a Operands must be \
                 booleans" print_position (position_point pos); raise Exit)

and bin_op_expr op e1 e2 pos =
  match op with 
  |Num_op  num_o -> num_op_expr num_o e1 e2 pos
  |Eq_op  eq_o -> eq_op_expr eq_o e1 e2 pos
  |Cmp_op  cmp_o -> cmp_op_expr cmp_o e1 e2 pos
  |Logic_op  logic_o -> logic_op_expr logic_o e1 e2 pos


and sem_op_expr op_e pos =
  match op_e with
  | At e -> 
    begin 
      match e with 
      |Lval(lv,_)-> TYPE_ptr (sem_expr e)
      | _ -> (error "%a Expression must be \
                     l-value" print_position (position_point pos); raise Exit) 
    end
  | Unary (op, e) -> sem_unop op e pos
  | Binary (e1, op, e2) -> bin_op_expr op e1 e2 pos


and sem_expr e =
  match e with
  | Lval (lv,pos) -> sem_lvalue lv pos
  | Const c -> sem_const c 
  | Rval (rv,pos ) -> sem_op_expr rv pos
  | E_call (id, params,pos) -> 
    begin 
      let fn = (lookupEntry (id_make id) LOOKUP_ALL_SCOPES true pos).entry_info in
    
      match fn with 
      | ENTRY_function fun_inf when (check_params fun_inf.function_paramlist params pos)-> fun_inf.function_result
      | _ -> (error "%a %s is not a function " print_position (position_point pos) id; raise Exit)
    end
    
    
  
  
  and check_params formal actual pos = 
    try
      List.iter2 
        (fun f a -> 
           match f.entry_info with
           | ENTRY_parameter par_inf -> 
             begin
               match par_inf.parameter_mode with
               |PASS_BY_VALUE when 
                   not(is_assignement_compatible par_inf.parameter_type (sem_expr a)) -> 
                 (error "%a Invalid parameter" print_position (position_point pos);raise Invalid)
               |PASS_BY_REFERENCE -> 
                 begin
                   match a with 
                   | Lval (lv,_) when 
                       (is_assignement_compatible (TYPE_ptr(par_inf.parameter_type)) (TYPE_ptr(sem_expr a)))-> ()
                   | Lval (_,p) ->  (error "%a Parameter must be \
                                            l-value" print_position (position_point p);raise Invalid)
                   | _ -> (error "%a actual parameter is not assignement compatible with \
                                  formal parameter " print_position (position_point pos);raise Invalid)
                 end
               | _ -> () (*PASS_BY_VALUE when is_assignement compatible*)
             end
           | _ -> () (*unreachable *)
        ) 
        formal actual ; true
  
    with Invalid_argument _ -> (error "%a wrong number of \
                                       parameters" print_position (position_point pos); false)
       | Invalid -> false
  