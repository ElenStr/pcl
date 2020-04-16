open Printf
open Ast

open Format
open Error

open Identifier
open Types
open Symbol
open Compile
open Compile_expr
open Llvm




let rec find_all_vars decls types = 
 match decls with
 
 | (D_var (ids, t, pos)::ds)->
    begin
      if (is_complete t)&&(is_valid t) then
        begin
          
          let types_list = List.map (fun id -> llvm_type t) ids in
          let cur_types = Array.append types (Array.of_list types_list) in
          find_all_vars ds cur_types
        end
      else (error "%a Invalid variable type" print_position (position_point pos) ; types)
    end 
| d::ds -> find_all_vars ds types
| _ -> types


let new_frame (var_types,par_sz )= 
 
  let types = Array.append var_types [| type_of (Stack.top frame_pointers)|] in
  let struct_t = struct_type context types in
  let len  = (Array.length types) in
  let frame = if !currentScope.sco_nesting=0 then
  begin
   let gl = const_null struct_t in
   define_global "global_scope_def" gl the_module 
  end
   else build_alloca struct_t "scope" Compile_expr.builder in
  let fn = Compile_expr.builder |> insertion_block |> block_parent in 
  Array.iteri (fun i p -> 
  if ((i<par_sz)||(i=len-1)) then begin (*i=len-1 mysterious corner case*)
  let pptr = build_struct_gep frame i "bind_param_ptr" Compile_expr.builder in
  ignore(build_store p pptr Compile_expr.builder)
  end)
  (params fn);
  let _ = if !currentScope.sco_nesting<>0 then 
  (let pptr = build_struct_gep frame (len-1) "bind_param_ptr" Compile_expr.builder in
  ignore(build_store (params fn).((Array.length (params fn)-1)) pptr Compile_expr.builder );)
  in
  

  Stack.push frame frame_pointers

let find_function_scope hd locals =
  let var_types = find_all_vars locals [||] in
  let pars,ft = match hd with
  | D_header(id, t,parms,pos) -> 
  ((Array.concat  (List.map (fun param -> 
    match param with 
      D_param(ids,t,_,_) -> Array.make (List.length ids) (llvm_type (TYPE_ptr t))
    | _ -> raise Exit (*unreachable *)
    ) parms )), t)
  | _ -> (error "unreached find_function_scope";raise Exit)
  in
  let res = if ft=TYPE_none then [||] else [|(llvm_type ft)|] in 
  let pars_and_res = Array.append pars res in
  
  (Array.append pars_and_res var_types),(Array.length pars)

