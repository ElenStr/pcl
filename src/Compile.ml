open Printf
open Ast

open Format
open Error

open Compile_expr 
open Utils
open Identifier
open Types
open Symbol
open Scope
open Str
open Llvm
open Llvm_analysis
open Llvm_executionengine
open Llvm_target
open Llvm_scalar_opts

let llvm_int n = const_int (i32_type context) n  
  
let compile_var_decl id t =
  let rec init_val var_ptr t =

    match t with  
      TYPE_array( dt , size)  -> 
      begin 
        let size_ptr = build_gep var_ptr [|llvm_int 0; llvm_int 0 |] "set_arr_size" Compile_expr.builder in
        let arr_ptr = build_gep var_ptr [|llvm_int 0; llvm_int 1|] "init_arr" Compile_expr.builder in
        let sz = match size with Some(n) -> llvm_int (n-1) 
                               | None -> llvm_int (65535 ) in
        ignore(build_store sz size_ptr Compile_expr.builder);
        init_val arr_ptr dt
  
      end
    | TYPE_ptr dt -> 
      begin 
        let pointee_ptr = build_load var_ptr "init_ptr_ld" Compile_expr.builder in
        init_val pointee_ptr dt
      end
    | _ -> ignore(build_store (const_null (llvm_type t)) var_ptr Compile_expr.builder) 
  in 
  let the_function = block_parent (insertion_block Compile_expr.builder) in 
  let builder = builder_at context (instr_begin (entry_block the_function)) in
  let var_ptr = build_alloca (llvm_type t) id builder in
    
  init_val var_ptr t; var_ptr


let compile_proto id t params =
  let proper_lib_type tt = 
    match tt with 
    | TYPE_array(TYPE_char,None) -> llvm_type (TYPE_ptr  (TYPE_array(TYPE_char,None)))
    |_ ->  llvm_type tt
    in
  match (lookup_function id the_module) with
  | Some(f) -> f
  | _ ->begin 
      let params_types_t = List.map (fun param -> 
          let t = param_type param in 
          let ids  = param_ids param in
          let p_t = 
            if !currentScope.sco_nesting=1 then proper_lib_type t  
            else (pointer_type (llvm_type t)) in
            Array.make (List.length ids) p_t
        ) params in 
      let params_names = List.map (fun param -> 
            let ids = param_ids param in 
            Array.of_list ids
        ) params in
      let param_modes = Array.concat (List.map (fun param -> begin
        let ids, m = param_ids param, param_mode param in    
        Array.make (List.length ids) m
          end) params ) in

      let pars = Array.concat params_types_t in

      let par_sz  = Array.length pars in

      let the_pars = Array.append pars 
          (if Stack.is_empty frame_pointer then [||]
           else  [|type_of (Stack.top frame_pointer)|]) in 
      let par_names = Array.append (Array.concat params_names) 
          (if Stack.is_empty frame_pointer then [||]
           else [|"pscope"|]) in

      let fun_type = function_type (llvm_type t) the_pars in
      let fn = declare_function id fun_type the_module in

      ignore(Array.iteri (fun i p -> 
          let par_name = par_names.(i) in
          if i<par_sz then 
          begin
            let par_entry = (lookupEntry (id_make par_name) LOOKUP_CURRENT_SCOPE true Lexing.dummy_pos) in
            let _ = 
              match param_modes.(i) with
              | PASS_BY_VALUE when !currentScope.sco_nesting>1-> add_function_attr fn (attr_of_repr context (AttrRepr.Enum(enum_attr_kind "byval" ,Int64.of_int 0))) (AttrIndex.Param(i))
              | _ -> ()
            in
            fix_offset par_entry.entry_info i;

            par_entry.entry_val <- LL(p);
          end
          else ();
          set_value_name par_name p ) (Llvm.params fn) );
      fn
    end

let compile_header fn params= 
  let fn = (llval fn) in
  let bb = append_block context "entry" fn  in

  position_at_end bb Compile_expr.builder;
  let sz = Array.length (Array.concat  (List.map (fun param -> 
      let ids, t = param_ids param , param_type param in 
     Array.make (List.length ids) t
    ) params )) in Stack.push sz par_sizes

let create_ret_block () = 

    let start_bb = insertion_block Compile_expr.builder in
    let the_function = block_parent start_bb in
    let new_bb = append_block context "ret" the_function in
    position_at_end start_bb Compile_expr.builder;
   LLB(new_bb)
  

let compile_ret hd prev = 
  match hd with
  | D_header(id, t,parms,pos) -> 
    begin 
      let _ = match t with 
        |TYPE_none -> ignore(build_ret_void Compile_expr.builder)
        | _ -> 
          begin
            let ret_val_ptr = llval (lookupEntry (id_make "result") LOOKUP_CURRENT_SCOPE true pos).entry_val in
            let ret_val = build_load ret_val_ptr "result_load" Compile_expr.builder in
            ignore(build_ret ret_val Compile_expr.builder);


          end in 
      
      position_at_end prev Compile_expr.builder;
      ignore(if Stack.is_empty frame_pointer then (error "pars";raise Exit) else Stack.pop par_sizes );

    end;
  | _ -> raise Exit (*unreachable*)


let compile_label id = 
  let start_bb = insertion_block Compile_expr.builder in
  let the_function = block_parent start_bb in
  let new_bb = append_block context id the_function in
  ignore(build_br new_bb Compile_expr.builder);
  position_at_end new_bb Compile_expr.builder;
  new_bb

let bb_of_llb b id pos from_label = 
  match b with
    LLB(llb) -> llb
  | LL(ll) -> 
    let entr = lookupEntry (id_make ("1"^id)) LOOKUP_CURRENT_SCOPE true pos in
    let bb = block_of_value ll in 
    let _=  if from_label then entr.entry_val <- LLB(bb) in
    bb
  |_ ->
    begin 
      let start_bb = insertion_block Compile_expr.builder in
      let the_function = block_parent start_bb in
      let entr = lookupEntry (id_make ("1"^id)) LOOKUP_CURRENT_SCOPE true pos in
      let new_bb = append_block context id the_function in
      entr.entry_val <- LL(new_bb |> value_of_block);
      new_bb
    end

let compile_label_after id ll pos= 
  let bb = bb_of_llb ll id pos true in
  let current_bb = insertion_block Compile_expr.builder in
  move_block_after current_bb bb;
  ignore(build_br bb Compile_expr.builder);
  position_at_end bb Compile_expr.builder

let compile_goto to_b id pos= 
  let to_bb = bb_of_llb to_b id pos false in
  let current_bb = insertion_block Compile_expr.builder in
  let the_function = block_parent current_bb in
  let new_goto_block = append_block context "goto" the_function in
  position_at_end current_bb Compile_expr.builder;
  ignore(build_br to_bb Compile_expr.builder);
  position_at_end new_goto_block Compile_expr.builder

let compile_while e =
  let current_bb = insertion_block Compile_expr.builder in
  let the_function = block_parent current_bb in
  let test = append_block context "while_test" the_function in
  let loop = append_block context "while_loop" the_function in
  let cont = append_block context "while_cont" the_function in
  position_at_end current_bb Compile_expr.builder;
  ignore(build_br test Compile_expr.builder) ;
  position_at_end test Compile_expr.builder; 
  let cond = compile_expr e in
  let i1_cond = build_intcast cond (i1_type context) "whilecast" Compile_expr.builder in   
  ignore(build_cond_br i1_cond loop cont Compile_expr.builder);

  position_at_end loop Compile_expr.builder; 
  (test,cont)   

let compile_while_end test cont = 
  let current_bb = insertion_block Compile_expr.builder in
  position_at_end current_bb Compile_expr.builder ;
  ignore(build_br test Compile_expr.builder );
  position_at_end cont Compile_expr.builder

let compile_assign lv e lv_pos = 
  let lv_ptr = get_val_ptr lv lv_pos in
  
  let rval = compile_expr e in
   
  let rval = cast_to_compatible rval lv_ptr in 
   
  ignore(build_store rval lv_ptr Compile_expr.builder)

let compile_new_el lv t pos= 
  let new_el_ptr = build_malloc (llvm_type t) "new_el" Compile_expr.builder in
  let lv_ptr = get_val_ptr lv pos in
  ignore(build_store new_el_ptr lv_ptr Compile_expr.builder)

let compile_dispose_el lv pos = 
  let llv = compile_lvalue lv pos in
  (* if is so far unreached semantics taking care of this so far*)
  if is_null llv then
    (error "%a memory must be allocated before is freed" 
       print_position (position_point pos); raise Exit)
  else
    begin
      ignore(build_free llv Compile_expr.builder);
      ignore(build_store (const_null (element_type (type_of llv) )) llv  Compile_expr.builder)
    end


let compile_new_array n lv t pos = 
  let cast_int64_to_int n = 
    match n with
      Some num -> Int64.to_int num
    | None -> (error "unreached not int const";raise Exit) in 

  let dim =  compile_expr n in 
  let is_dim_positive = build_icmp Icmp.Sgt dim (const_int (type_of dim) 0) "dim_positive" Compile_expr.builder in
  let tr = (const_int (i1_type context) 1) in
  let lv_ptr = get_val_ptr lv pos in
  let new_el_ptr = 
    match  (is_dim_positive=tr, is_constant dim) with
    | (true, true) -> 
      build_malloc (llvm_type (TYPE_array(t, Some(dim |> int64_of_const |>cast_int64_to_int)))) "new_array" Compile_expr.builder 

    |(false, true) ->  (error "%a c Array Dimension must be \
                               positive" print_position (position_point pos); raise Exit)
    | _ -> 
    build_array_malloc (llvm_type t) dim "new_array_unknown_bounds" Compile_expr.builder 

  in
  (* ignore(build_store (const_null (llvm_type t)) new_el_ptr Compile_expr.builder); *)
  let new_ele_ptr =  build_bitcast new_el_ptr (llvm_type (TYPE_ptr(TYPE_array(t,None)))) "new_arr_bitcast" Compile_expr.builder in
  ignore(build_store new_ele_ptr lv_ptr Compile_expr.builder)


let compile_dispose_array lv pos = 
  let llv = compile_lvalue lv pos in
  if is_null llv then
    (error "%a memory must be allocated before is freed" 
       print_position (position_point pos); raise Exit)
  else
    begin
      ignore(build_free llv Compile_expr.builder);
      ignore(build_store (const_null (element_type (type_of llv) )) llv Compile_expr.builder)
    end
let compile_return () = 
  let current_bb = insertion_block Compile_expr.builder in
  let the_function = block_parent current_bb in
  
  let ret_block = Utils.ret_block_of () in
  let new_block = append_block context "return" the_function in
  position_at_end current_bb Compile_expr.builder;
  ignore(build_br ret_block Compile_expr.builder);
  position_at_end new_block Compile_expr.builder


let compile_main o = 
  let _ = if o then begin
    add_constant_propagation Compile_expr.the_fpm;
    add_memory_to_register_promotion Compile_expr.the_fpm;
    add_instruction_combination Compile_expr.the_fpm;
    add_reassociation Compile_expr.the_fpm;
    add_gvn Compile_expr.the_fpm;
    add_cfg_simplification Compile_expr.the_fpm;

  end else () in
  let fun_type = function_type (llvm_type TYPE_none) [| |] in
  let main = declare_function "main" fun_type the_module in
  let the_function = append_block context "entry" main in
  position_at_end the_function Compile_expr.builder


let compile_main_ret () =
  ignore(build_ret_void Compile_expr.builder)



let get_main () = 
  let current_bb = insertion_block Compile_expr.builder in
  block_parent current_bb