open Printf
open Ast

open Format
open Error
open Utils
open Identifier
open Types
open Symbol
open Compile
open Frames
open Llvm_executionengine
open Llvm_target
open Llvm_scalar_opts
open Compile_expr
open Sem_expr
exception Invalid


let rec sem_decl ast f fd =
  match (ast,f,fd)with
  | (D_var (ids, t, pos), None, true )->
    begin
      if (is_complete t)&&(is_valid t) then
        ignore (List.map (fun id -> (newVariable (id_make id) t (LL_dummy) true pos)) ids ) 
      else error "%a Invalid variable type" print_position (position_point pos)
    end

  | (D_label (ids,pos), None, true )-> ignore (List.map (fun id -> (newVariable (id_make ("1"^id)) TYPE_none LL_dummy true pos )) ids ) 
  | (D_param (ids , t , m, pos),Some(f),_) -> 
    begin
      match (t, m)  with 
      | (TYPE_array (_,_), PASS_BY_VALUE) -> 
        error "%a parameters passed by value must not be of type array" print_position (position_point pos)
      | (_,_) when (is_valid t) -> ignore (List.map (fun id -> (newParameter (id_make id) t m f LL_dummy true pos) ) ids)
      | (_,_) -> error "%a invalid type" print_position (position_point pos)
    end
  | (D_header (id, t, params, pos),None,fl )-> 
    begin
      match t with 
      | TYPE_array (dt,_) -> (error "%a function %s must not be of type array " print_position (position_point pos) id )
      | _ -> 
        begin
          let fn = newFunction (id_make id) LL_dummy true pos in

          (if fl then forwardFunction fn) ; 
          (* printSymbolTable();  *)
          openScope();                                               
          (* printSymbolTable();  *)
          List.iter (fun p -> sem_decl p (Some fn) fl )  params ;

          endFunctionHeader fn t; 
          let scope_num = 
            let num = (fn.entry_scope.sco_nesting) in
            if num=0 then "" else string_of_int num in
          let fb_name = (id^scope_num) in 
          
          let fn_ll =  
             compile_proto fb_name t params in 
           fn.entry_val <- LL(fn_ll) ;
          (* Scope.set_env fn.entry_info builder; *)
          if fl then closeScope() 
          else  begin

            compile_header fn.entry_val params;

            if t <> TYPE_none then 
            ignore(newVariable (id_make "result") t (LL(compile_var_decl "result" t)) true Lexing.dummy_pos);


            
          end ;
          (* allow functions with same proto different scopes different definition *)
          (* printSymbolTable() *)
        end
    end
  | (D_fun (hd, (locals,bd)),None,true )-> 
    let previous_block = Llvm.insertion_block Compile_expr.builder in
    sem_decl hd None false; 
    (* let ret_block = Utils.ret_block_of_hd hd in *)
    new_frame (find_function_scope hd locals );
    
    (* Llvm.dump_module the_module; *)
    
    List.iter (fun l -> sem_decl l None true)  locals ;
    sem_decl ( D_label(["4ret"],Lexing.dummy_pos)) None true;
     (* printSymbolTable();  *)
    
    (* Llvm.dump_module the_module; *)
    sem_stmt bd;
     (* delete_frame ();  *)
    ignore(Stack.pop frame_pointer);
    sem_stmt (S_label("4ret",S_empty,Lexing.dummy_pos));     

    compile_ret hd previous_block ;
    
     (* printSymbolTable();   *)
    (* checkSymbolTable(); *)
    closeScope() 
  |_ -> ()

and sem_stmt stmt = 
  match stmt with
  | S_block stmts -> List.iter sem_stmt stmts
  | S_assign (lv, e,st,fin) -> 
    begin
      if not(is_assignement_compatible (sem_lvalue lv st) (sem_expr e)) then 
        (error "%a Incompatible assignement %s to %s" print_position (position_context st fin) (pcl_type_str (sem_lvalue lv st) ) (pcl_type_str (sem_expr e) ); raise Exit)
      else (compile_assign lv e st)
    end
  | S_if (e, s, None) -> 
    begin 
      match  (sem_expr e) with 
      | TYPE_bool -> 
        begin
          let (el_b, mer_b) = compile_if_then e in 
          sem_stmt s ;
          compile_else (el_b, mer_b);
          compile_merge (mer_b);
        end
      | _  -> error "Expression must be boolean "     
    end
  | S_if (e, s1, Some(s2)) -> 
    begin 
      match  (sem_expr e) with 
      | TYPE_bool ->
        begin
          let (el_b, mer_b) = compile_if_then e in 
          sem_stmt s1;
          compile_else (el_b, mer_b);
          sem_stmt s2;
          compile_merge (mer_b);
        end 
      | _  -> error "Expression must be boolean "     

    end
  | S_while (e,s) -> 
    begin 
      match  (sem_expr e) with 
      | TYPE_bool ->(let test, con = compile_while e in sem_stmt s;compile_while_end test con)
      | _  -> error "Expression must be boolean "     
    end 
  | S_label (id, s,pos) -> 
    begin 
      
      let entr = lookupEntry (id_make ("1"^id)) LOOKUP_CURRENT_SCOPE true pos in
      match entr.entry_info with
      |ENTRY_variable _ -> 
        begin
          match entr.entry_val with
          |LL_dummy ->  (ignore(entr.entry_val<-LLB(compile_label id)); sem_stmt s)
          |LL(ll) -> (compile_label_after id (LL(ll)) pos; sem_stmt s)
          | _ -> (error "%a %s must be defined only once" print_position (position_point pos) id; raise Exit)
        end
      | _ -> (error "%a %s is not a label" print_position (position_point pos) id)
    end
  | S_goto (id,pos) ->
    begin 
     
      let entr = lookupEntry (id_make ("1"^id)) LOOKUP_CURRENT_SCOPE true pos in
      match entr.entry_info with
      |ENTRY_variable _ -> compile_goto entr.entry_val id pos
      | _ -> (error "%a %s is not a label" print_position (position_point pos) id)
    end
  | S_return -> sem_stmt (S_goto("4ret",Lexing.dummy_pos)) 
  | S_call call -> ignore(sem_expr call) ;ignore(Compile_expr.compile_expr call)
                    
  | S_new_el (lv,pos) ->
    begin
      match sem_lvalue lv pos with
      | TYPE_ptr t when is_complete t -> 
        begin
          ignore(newVariable  (id_make ("2"^(lvalue_to_string lv))) t LL_dummy false pos);
          compile_new_el lv t pos 
        end
      | _ -> error "%a Expression %s must be of type pointer \
                    of complete type" print_position (position_point pos) (lvalue_to_string lv)
    end

  | S_new_array (n, e, pos) -> 
    begin
      let eval_expr n = 
        match n  with Const INT(i) -> i | _ -> 1 in
      let dim = eval_expr n in
      match (sem_lvalue e pos, sem_expr n) with
      | (TYPE_ptr TYPE_array(t,None), TYPE_int) when dim>0 ->
        begin 
          ignore(newVariable  (id_make ("3"^(lvalue_to_string (Deref(Lval (e,pos))))) ) 
                 (TYPE_array(t,Some(dim))) LL_dummy false pos);
          compile_new_array n e t pos
        end

      | _ -> error "%a Expression %s must be of type array pointer \
                    and dimension must be positive"
               print_position (position_point pos) (lvalue_to_string e)
    end
  | S_dispose_el (lv,pos) -> 
    begin
      match sem_lvalue lv pos with
      | TYPE_ptr t when is_complete t -> 
        begin
          ignore(lookupEntry (id_make ( "2"^(lvalue_to_string lv))) LOOKUP_ALL_SCOPES true pos);
          compile_dispose_el lv pos
        end
      | _ -> error "%a Expression %s must be of type pointer \
                    of complete type" print_position (position_point pos) (lvalue_to_string lv)
    end
  | S_dispose_array (e,pos) ->
  begin
    match (sem_lvalue e pos) with
    | (TYPE_ptr TYPE_array(t,None))->
      begin 
         ignore(lookupEntry (id_make ( "3"^(lvalue_to_string (Deref(Lval (e,pos)))))) LOOKUP_ALL_SCOPES true pos);
         compile_dispose_array e pos
        end

        | _ -> error "%a Expression %s must be of type array pointer \
                      and dimension must be positive"
                 print_position (position_point pos) (lvalue_to_string e)
      end
  | S_empty -> ()


and sem (decls,stmt) o = 
  initSymbolTable 256;
  compile_main o;
  
  List.iter (fun l -> sem_decl l None true) lib;
  
  Stack.push  (Llvm.const_pointer_null (Llvm.struct_type context [||] )) frame_pointer;
  new_frame ((find_all_vars decls [||]),0);
  
  openScope ();
  
  List.iter (fun l -> sem_decl l None true)  decls ; 
  sem_decl ( D_label(["4ret"],Lexing.dummy_pos)) None true;

  sem_stmt  stmt ; 
  sem_stmt (S_label("4ret",S_empty,Lexing.dummy_pos));

  compile_main_ret ();
  (* Llvm.dump_module the_module; *)
  Llvm_analysis.assert_valid_module the_module; 
  let _ = Llvm.PassManager.run_module the_module Compile_expr.the_fpm in
  (* printSymbolTable ();  *)
  checkSymbolTable();
  closeScope();
  the_module
  