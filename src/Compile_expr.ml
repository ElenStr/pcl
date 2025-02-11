open Printf
open Ast

open Format
open Error

open Identifier
open Types
open Symbol
open Llvm
open Sem_expr

let context = global_context ()
let the_module = create_module context "mycompiler"
let the_fpm = PassManager.create () 
let builder = builder context

let frame_pointers = Stack.create ()

let rec llvm_type t = 
  match t with
  | TYPE_int -> i16_type context
  | TYPE_real -> x86fp80_type context
  | TYPE_bool -> i1_type context
  | TYPE_char -> i8_type context
  | TYPE_array (dt, Some(n) ) -> array_type (llvm_type dt) n 
  | TYPE_array (dt,_) -> array_type (llvm_type dt) 0
  | TYPE_ptr dt -> pointer_type (llvm_type dt)
  | TYPE_none -> void_type context

let cast_to_real lv = 
  match classify_type (type_of lv) with
  | TypeKind.X86fp80 -> lv
  | TypeKind.Integer -> build_sitofp lv  (llvm_type TYPE_real) "cast" builder
  | _ -> (dump_module the_module;dump_value lv; error "unreached code wrong type division"; raise Exit)

let cast_and_build op l1 l2 =
  let t1, t2 = classify_type (type_of l1), classify_type (type_of l2) in
  match op with
  | O_plus when (t1 = t2)&& (t1 =  TypeKind.Integer)-> build_add l1 l2 "iaddtmp" builder
  | O_plus -> build_fadd (cast_to_real l1) (cast_to_real l2) "faddtmp" builder
  | O_minus when (t1 = t2)&& (t1 =  TypeKind.Integer)-> build_sub l2 l1 "isubtmp" builder
  | O_minus -> build_fsub (cast_to_real l2) (cast_to_real l1) "fsubtmp" builder
  | O_times when (t1 = t2)&& (t1 =  TypeKind.Integer)-> build_mul l1 l2 "imultmp" builder
  | O_times -> build_fmul (cast_to_real l1) (cast_to_real l2) "fmultmp" builder
  | _ -> (error "unreached *,+,_"; raise Exit)

let cast_string_to_array_ptr str pos = 
  let var_ptr = build_alloca (llvm_type (sem_lvalue (String_const(str)) pos)) str builder in
  ignore(build_store (const_stringz context str) var_ptr builder);
  var_ptr


let get_previous_frame_ptr  cur_fp =
  let struct_size = (cur_fp |> type_of|> element_type |> struct_element_types |> Array.length )- 1 in
  let prev_ptr_ptr = build_struct_gep cur_fp struct_size "prev_fp_gep" builder in
  build_load prev_ptr_ptr "prev_fp" builder

let rec find_scope cur_sc cur_fp_ptr target_sc= 
  match  cur_sc=target_sc with
  | true -> cur_fp_ptr
  | _ -> find_scope (cur_sc - 1) (get_previous_frame_ptr cur_fp_ptr) target_sc


let compile_const c =
  let int_of_bool b = if b then 1 else 0 in
  let l_t = llvm_type (Sem_expr.sem_const c) in
  match c with
  | INT n -> const_int l_t n
  | REAL r -> const_float l_t r
  | CHAR c -> const_int l_t (int_of_char (Utils.str_to_char c))
  | BOOL b -> const_int l_t (int_of_bool b)
  | NIL ->  const_pointer_null l_t

let rec compile_unop unop e =
  let lv=(compile_expr e) in  
  begin
    match unop with 
    | U_not -> build_not lv "nottmp" builder
    | U_plus -> lv
    | U_minus ->  build_neg lv "negtmp" builder
  end

and compile_eq_op op e1 e2 =
  let lv1, lv2 = compile_expr e2, compile_expr e1 in
  begin
    match classify_type (type_of lv1) with
    | _ when classify_type(type_of lv1) <> classify_type(type_of lv2) -> 
      begin
        match op with
        | O_eq -> build_fcmp Fcmp.Oeq (cast_to_real lv1) (cast_to_real lv2) "feqtmp" builder
        | O_neq -> build_fcmp Fcmp.One (cast_to_real lv1) (cast_to_real lv2) "fneqtmp" builder
      end
    | _ -> 
      begin
        let v1 = build_bitcast lv1 (type_of lv2) "cast nil" builder in 
        match op with
        | O_eq -> build_icmp Icmp.Eq v1 lv2 "ieqtmp" builder
        | O_neq -> build_icmp Icmp.Ne v1 lv2 "ineqtmp" builder
      end
  end

and compile_cmp_op op e1 e2 = 
  let lv1,lv2 = compile_expr e1, compile_expr e2 in
  let build_cmp f tag  = 
    f lv1 lv2 tag builder
  in
  let t1, t2 = classify_type (type_of lv1) , classify_type (type_of lv2) in
  match op with 
  | O_gt -> 
    begin
      match (t1, t2) with 
      | (TypeKind.Integer, TypeKind.Integer ) -> build_cmp (build_icmp Icmp.Sgt) "igttmp"
      |_ ->  build_cmp (build_fcmp Fcmp.Ogt) "fgttmp"

    end
  | O_geq  ->
    begin
      match (t1, t2) with 
      | (TypeKind.Integer, TypeKind.Integer ) -> build_cmp (build_icmp Icmp.Sge) "igetmp"
      |_ ->  build_cmp (build_fcmp Fcmp.Oge) "fgetmp"

    end
  | O_lt ->
    begin
      match (t1, t2) with 
      | (TypeKind.Integer, TypeKind.Integer ) -> build_cmp (build_icmp Icmp.Slt) "ilttmp"
      |_ ->  build_cmp (build_fcmp Fcmp.Olt) "flttmp"

    end
  | O_leq ->
    begin
      match (t1, t2) with 
      | (TypeKind.Integer, TypeKind.Integer ) -> build_cmp (build_icmp Icmp.Sle) "iletmp"
      |_ ->  build_cmp (build_fcmp Fcmp.Ole) "fletmp"

    end

and compile_num_op op e1 e2 = 
  let lv1, lv2 = compile_expr e2, compile_expr e1 in
  match op with 
  | O_division -> build_fdiv (cast_to_real lv2) (cast_to_real lv1) "divisiontmp" builder
  | O_div -> build_sdiv lv2 lv1 "divtmp" builder
  | O_mod -> build_srem lv2 lv1 "modtmp" builder
  | _ -> cast_and_build op lv1 lv2

and compile_logic_op op e1 e2 = 
  let tr,fls  = (const_int (llvm_type TYPE_bool) 1),( const_int (llvm_type TYPE_bool) 0) in
  let ret_ptr = build_alloca (llvm_type TYPE_bool) "short_circ_tmp" builder in
  let lv1_casted = (build_intcast (compile_expr e1) (i1_type context) "e1 cast logic" builder) in
  let lv2_casted = (build_intcast (compile_expr e2) (i1_type context) "e2 cast logic" builder) in
  let (el_b,mer_b) = compile_if_then ~compile_cond:false ~casted_cond:lv1_casted e1 in

  match op with 
  | O_and  -> 
    begin
      let and_b = build_and lv1_casted lv2_casted "andtmp" builder in
      let ret_val = (build_intcast and_b (i1_type context) "andcast" builder) in
      let _ = build_store ret_val ret_ptr builder in

      compile_else (el_b,mer_b); 
      let _ = build_store fls ret_ptr builder in
      compile_merge (mer_b); 
      build_load ret_ptr "andres" builder
    end
  | _ -> 
    begin
      let _ = build_store tr ret_ptr builder in
      compile_else (el_b,mer_b); 
      let tmp = build_or lv1_casted lv2_casted "ortmp" builder in
      let ret_val = (build_intcast tmp (i1_type context) "orcast" builder) in
      let _ = build_store (build_intcast ret_val (i1_type context) "all or cast" builder) ret_ptr builder in
      compile_merge (mer_b);
      build_load ret_ptr "orres" builder
    end

and compile_bin_op op e1 e2  =
  match op with 
  | Num_op  num_o -> compile_num_op num_o e1 e2 
  | Eq_op  eq_o -> compile_eq_op eq_o e1 e2 
  | Cmp_op  cmp_o -> compile_cmp_op cmp_o e1 e2 
  | Logic_op  logic_o -> compile_logic_op logic_o e1 e2 

and compile_op op_e = 
  match op_e with 
  | At Lval(lv,pos) ->  get_val_ptr lv pos 
  | Unary (op, e) -> compile_unop op e 
  | Binary (e1, op, e2) -> compile_bin_op op e1 e2 
  | _ -> raise Exit (*unreachable*)

and get_ptr e = 
  match e with
  |  Lval(lv,pos) -> get_val_ptr lv pos
  | _ -> let v = compile_expr e in 
    let val_t =   v |> type_of in
    let val_ptr = build_alloca val_t "par_pass" builder in
    let _ = build_store v val_ptr builder in val_ptr

and compile_expr e =   
  match e with
  | Lval (lv, pos) -> compile_lvalue lv pos
  | Const c -> compile_const c 
  | Rval (rv,_ ) -> compile_op rv 
  | E_call (id, params,pos) ->
    begin  
      let fun_ent = (lookupEntry (id_make id) LOOKUP_ALL_SCOPES true pos) in
      let fun_sc = fun_ent.entry_scope.sco_nesting in
      let fun_sc_name = if fun_sc=0 then "" else string_of_int fun_sc in
      let fun_name = id^(fun_sc_name) in
      let cur_s = !currentScope.sco_nesting in

      match lookup_function fun_name the_module with
      | Some fn -> 
        let cast_to_iarray par = 
          let ptr = get_ptr par in
          let dt = ptr |> type_of |> element_type |> element_type in
          let arr_ptr_type = pointer_type (array_type dt 0) in
          build_bitcast ptr arr_ptr_type "arr_cast" builder
        in
        let scope_arg  = 
          if fun_sc >0 then
            [| find_scope cur_s (Stack.top frame_pointers) fun_sc |] 
          else [||] in 
        let the_pars = Array.append (Array.of_list (List.map (
            fun p -> 
              begin              
                let param_pass p =                
                  match (sem_expr p ) with
                  | (TYPE_array(_)) -> cast_to_iarray p                  
                  | _ when fun_sc>0 ->  get_ptr p
                  | _ -> p |> compile_expr 
                in            
                param_pass p
              end) params)) scope_arg in
        let casted_pars = Array.mapi (
            fun i formal -> 

              let actual = the_pars.(i) in
              let form_type = formal |> type_of  in
              let act_type = actual |> type_of in

              let rec cast_params_to_compatible act_type form_type actual = 
                match (act_type |> classify_type, form_type |> classify_type) with
                | (TypeKind.Integer, TypeKind.X86fp80) -> cast_to_real actual
                | (TypeKind.Pointer, _) ->
                  build_bitcast actual form_type "cast_to_formal_params" builder
                | _ -> actual in

              cast_params_to_compatible act_type form_type actual) 
            (Llvm.params fn) in

        let ret_t = 
          match fun_ent.entry_info with
            ENTRY_function inf -> inf.function_result
          | _ -> (error "unreached call expr";raise Exit) in
        let nm = if (equalType ret_t TYPE_none) then "" else "calltmp" in
        build_call fn  casted_pars nm builder 
      | None  -> raise Exit (*unreached already checked from semanctics*)
    end

and get_val_ptr lv pos =
  match lv with 
  | Var id -> 
    let entry = lookupEntry (id_make id) LOOKUP_ALL_SCOPES true pos in
    let entr_sc, current_s = entry.entry_scope.sco_nesting , !currentScope.sco_nesting in
    let inf = entry.entry_info in
    let ptr = 
      let current_frame_ptr = if Stack.is_empty frame_pointers then raise Exit else   Stack.top frame_pointers in
      let correct_sc_ptr = find_scope current_s current_frame_ptr entr_sc in
      let offset = 
        match inf with 
        | ENTRY_variable vi -> ((abs vi.variable_offset)-1)
        | ENTRY_parameter pi -> ((abs pi.parameter_offset)-1)
        | _ -> raise Exit
      in
      match inf with 
      | ENTRY_variable vi ->  build_struct_gep correct_sc_ptr offset "var_addr" builder
      | ENTRY_parameter pi ->
        let tmp_addr = build_struct_gep correct_sc_ptr offset "tmp_var_addr" builder in
        build_load tmp_addr "var_addr" builder 

      | _ -> raise Exit (* unreachable*)
    in ptr
  | Array_element (l,e) -> 
    begin
      let llvm_int n = const_int (i32_type context) n  in
      let struct_arr_ptr = get_val_ptr l pos in
      let index =  build_intcast (compile_expr e) (i32_type context) "idx_cast" builder in
      build_gep struct_arr_ptr [| llvm_int(0) ;index |] "array_element_gep" builder
    end 
  | Deref e -> 
    begin
      let lv_ptr = compile_expr e in
      lv_ptr
    end
  | Res -> get_val_ptr (Var("result")) pos 
  | String_const str -> cast_string_to_array_ptr str pos

and compile_lvalue lv pos =
  let lv_ptr = get_val_ptr lv pos in
  match lv with
  | Var id -> build_load lv_ptr id  builder
  | String_const str -> build_load lv_ptr str builder 
  | Array_element (l,e) -> build_load lv_ptr "array_element" builder
  | Deref e -> build_load lv_ptr ((Ast.expr_to_string e)^"_ptr") builder
  | Res -> build_load lv_ptr "result"  builder

and compile_if_then ?compile_cond:(compile_cond=true) ?casted_cond:(casted_cond=(context |> i1_type |> const_null)) e = 
  (* optional params are needed when short circuiting to avoid compiling condition twice *)
  let cond = if compile_cond then compile_expr e else context |> i1_type |> const_null in
  let start_bb = insertion_block builder in
  let the_function = block_parent start_bb in
  let test_block = append_block context "test" the_function in
  let then_block = append_block context "then" the_function in
  let else_block = append_block context "else" the_function in
  let merge_block = append_block context "ifcont" the_function in
  position_at_end start_bb builder;
  ignore(build_br test_block builder) ;
  position_at_end test_block builder; 
  let i1_cond = if compile_cond then build_intcast cond (i1_type context) "ifcast" builder else casted_cond in
  ignore(build_cond_br i1_cond  then_block else_block builder);
  position_at_end then_block builder; 
  (else_block, merge_block)   

and compile_else (else_block, merge_block)  = 
  let current_bb = insertion_block builder; in
  position_at_end current_bb builder;
  ignore(build_br merge_block builder);
  position_at_end else_block builder 

and compile_merge merge_block =            
  let current_bb = insertion_block builder; in
  position_at_end current_bb builder;
  ignore(build_br merge_block builder);
  position_at_end merge_block builder