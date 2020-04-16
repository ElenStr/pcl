open Printf
open Ast

open Format
open Error

open Identifier
open Types
open Symbol


open Llvm

(* prob unused  *)


let par_sizes = Stack.create ()

let llval v = match v with 
  | LL lv -> lv
  |_ -> raise Exit

let fix_offset inf i =
   match inf with 
    ENTRY_parameter p_inf -> p_inf.parameter_offset <- i 
    |ENTRY_variable v_inf ->()
    | _  -> ()
let var_entr_list sc = 
    List.filter 
    (fun ent -> 
    match ent.entry_info with 
    ENTRY_variable _ when (id_name ent.entry_id)<>"result" ->true 
    | ENTRY_parameter _ -> true
    |_ -> false) sc.sco_entries 

let scope_vars_to_array sc = 
  let var_entries = List.rev (var_entr_list sc) in
  let var_list = 
    List.mapi 
    (fun i ent -> llval ent.entry_val) var_entries in
    Array.of_list var_list

let scope_names_to_array sc_op =
  match sc_op with 
  Some sc ->
    let var_entries = var_entr_list sc in
    let var_list = 
      List.mapi 
      (fun i ent -> (id_name ent.entry_id)) var_entries in
      Array.of_list (List.rev var_list)
      | _ -> (error "unreached top_level types "; raise Exit)

  
let scope_var_types_to_array sc_op = 
  match sc_op with 
  Some sc -> 
  let vars = scope_vars_to_array sc in
  let types = 
    Array.map 
    (fun lv -> type_of lv ) vars in
    (types,sc.sco_nesting)
  | _ -> (error "unreached top_level types "; raise Exit)




  let nest sc_op  = 
    match sc_op with
     Some sc -> sc.sco_nesting
     | _ -> 0

 