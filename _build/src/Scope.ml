open Printf
open Ast

open Format
open Error

open Identifier
open Types
open Symbol


open Llvm

(* let frame_pointers = ref [||]
let frame_pointers_names = ref [||] *)

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


(* let add_new_frame id sc_op context builder = 
  let var_types,sco_nest = scope_var_types_to_array sc_op in
  let frame_type = struct_type context var_types in
  let frame = build_alloca frame_type ("scope"^id) builder in

   frame_pointers :=  Array.append !frame_pointers  [| frame|];
   frame_pointers_names :=  Array.append !frame_pointers_names  [| "scope"^id|];
   !frame_pointers *)

(* let scope_types env_arr = 
  Array.map (fun el -> type_of el ) env_arr *)


(* let remove_frame () = 
  let size = (Array.length !frame_pointers) - 1 in
  frame_pointers := Array.sub !frame_pointers 0 size *)

(* let get_env inf = 
  match inf with
  ENTRY_function i -> i.function_environment
  | _ -> error "unreached set_enc";raise Exit

let set_env inf builder =
  let pars  = builder |> insertion_block |>  block_parent |> params in
  match inf with
  ENTRY_function i -> 
    
  let par_size = 
    if Stack.is_empty par_sizes then 0 else Stack.top par_sizes in
  let frames = Array.sub pars  par_size ((Array.length pars) -  par_size ) in 
  let env = Array.append frames [|(!frame_pointers).(Array.length (!frame_pointers) -1) |] in
ignore (i.function_environment <- env)
  | _ -> error "unreached set_enc";raise Exit *)

  let nest sc_op  = 
    match sc_op with
     Some sc -> sc.sco_nesting
     | _ -> 0

  (* let lib_names = 
    let get_names_from_hd hd = 
      match hd with
       | (D_header(id,_,_,_)) -> id
       | _ -> "" 
    in 
    List.map get_names_from_hd Semantics.lib *)