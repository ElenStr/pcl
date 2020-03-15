open Ast
open Printf
open Types
open Format
open Error
open Symbol
open Identifier



let lib = [
  D_header("writeInteger",TYPE_none,[D_param(["n"],TYPE_int,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("writeBoolean",TYPE_none,[D_param(["b"],TYPE_bool,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("writeChar",TYPE_none,[D_param(["c"],TYPE_char,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("writeReal",TYPE_none,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("writeString",TYPE_none,[D_param(["s"],TYPE_array (TYPE_char, None),PASS_BY_REFERENCE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("readInteger",TYPE_int,[],Lexing.dummy_pos);
  D_header("readBoolean",TYPE_bool,[],Lexing.dummy_pos);
  D_header("readChar",TYPE_char,[],Lexing.dummy_pos);
  D_header("readReal",TYPE_real,[],Lexing.dummy_pos);
  D_header("readString",TYPE_none,[D_param(["size"],TYPE_int,PASS_BY_VALUE,Lexing.dummy_pos);D_param(["s"],TYPE_array (TYPE_char,None),PASS_BY_REFERENCE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("abs",TYPE_int,[D_param(["n"],TYPE_int,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("fabs",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("sqrt",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("sin",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("cos",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("tan",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("arctan",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("exp",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("ln",TYPE_real,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("pi",TYPE_real,[],Lexing.dummy_pos);
  D_header("trunc",TYPE_int,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("round",TYPE_int,[D_param(["r"],TYPE_real,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("ord",TYPE_int,[D_param(["c"],TYPE_char,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);
  D_header("chr",TYPE_char,[D_param(["n"],TYPE_int,PASS_BY_VALUE,Lexing.dummy_pos)],Lexing.dummy_pos);

] 
let block_of_llb llb = 
  match llb with
    LLB bb -> bb
  | _ -> raise Exit

let ret_block_of () = 

  let ent_val = (lookupEntry (id_make "9result")  LOOKUP_CURRENT_SCOPE true Lexing.dummy_pos).entry_val in 

  block_of_llb ent_val



let rec ret_block_of_id id pos = 

  let ent_inf = (lookupEntry (id_make id)  LOOKUP_ALL_SCOPES true pos).entry_info in 
  match ent_inf with 
  | ENTRY_function inf -> block_of_llb inf.function_ret_block
  | _ -> ret_block_of_id id pos

let  ret_block_of_hd hd = 

  match hd with 
  | (D_header(id,_,_,pos) )->begin 
  let ent_val = (lookupEntry (id_make ("9"^id^"result"))  LOOKUP_ALL_SCOPES true Lexing.dummy_pos).entry_val in 

  block_of_llb ent_val end
  | _ -> raise Exit



  let show_offsets = true

  let rec pretty_typ ppf typ =
    match typ with
    | TYPE_none ->
      fprintf ppf "<undefined>"
    | TYPE_int ->
      fprintf ppf "int"
    | TYPE_real ->
      fprintf ppf "real"
    | TYPE_char ->
      fprintf ppf "char" 
    | TYPE_bool ->
      fprintf ppf "bool"      
    | TYPE_array (et, Some(sz)) ->
      pretty_typ ppf et;  fprintf ppf " [%d]" sz
    | TYPE_ptr et -> pretty_typ ppf et; fprintf ppf " ptr"
    | TYPE_array (et,None) -> pretty_typ ppf et; fprintf ppf " []"
  
  
  let pretty_mode ppf mode =
    match mode with
    | PASS_BY_REFERENCE ->
      fprintf ppf "reference "
    | _ ->
      ()
  
  let param_ids p = 
    match p with 
    | D_param(ids, _, _, _) -> ids
    | _ -> raise Exit (*unreached*)

  let param_type p = 
    match p with 
    | D_param(_, t, _, _) -> t
    | _ -> raise Exit (*unreached*)
  
  let param_mode p = 
      match p with 
      | D_param(_, _, m, _) -> m
      | _ -> raise Exit (*unreached*)
  let printSymbolTable () = 
    let rec walk ppf scp =
      if scp.sco_nesting <> 0 then
        begin
          fprintf ppf "scope: ";
          let entry ppf e =
            fprintf ppf "%a" pretty_id e.entry_id;
            match e.entry_info with
            | ENTRY_none ->
              fprintf ppf "<none>"
            | ENTRY_variable inf ->
              if show_offsets then
                fprintf ppf "[%d]" inf.variable_offset
            | ENTRY_parameter inf ->
              if show_offsets then
                fprintf ppf "[%d]" inf.parameter_offset;
  
            | ENTRY_function inf ->
              (* if inf.function_isForward && not (List.exists (fun hd -> begin 
                    match hd with (D_header(id, _ , _, _)) -> (e.entry_id=(id_make id))
                                | _ -> false
                  end) lib) then 
                (error "Undefined function: %a" pretty_id e.entry_id;
                 raise Exit)
              else     *)
                begin
                  let param ppf e =
  
                    match e.entry_info with
                    | ENTRY_parameter inf ->
                      fprintf ppf "%a%a : %a"
                        pretty_mode inf.parameter_mode
                        pretty_id e.entry_id
                        pretty_typ inf.parameter_type
                    | _ ->
                      fprintf ppf "<invalid>" in
                  let rec params ppf ps =
                    match ps with
                    | [p] ->
                      fprintf ppf "%a" param p
                    | p :: ps ->
                      fprintf ppf "%a; %a" param p params ps;
                    | [] ->   
                      () in
                  fprintf ppf "(%a) : %a"
                    params inf.function_paramlist
                    pretty_typ inf.function_result
                end
            | ENTRY_temporary inf ->
              if show_offsets then
                fprintf ppf "[%d]" inf.temporary_offset 
          in
          let rec entries ppf es =
            match es with
            | [e] ->
              fprintf ppf "%a" entry e
            | e :: es ->
              fprintf ppf "%a, %a" entry e entries es;
            | [] ->
              () in
          match scp.sco_parent with
          | Some scpar ->
            fprintf ppf "%a\n%a"
              entries scp.sco_entries
              walk scpar
          | None ->
            fprintf ppf "<impossible>\n"
        end in
    let scope ppf scp =
      if scp.sco_nesting == 0 then
        fprintf ppf "no scope\n"
      else
        walk ppf scp in
    printf "%a----------------------------------------\n"
      scope !currentScope



      let checkSymbolTable () = 
        let rec walk scp =
          if scp.sco_nesting <> 0 then
            begin             
              let entry e =
                match e.entry_info with
               
                 
                | ENTRY_variable inf ->
                  let id_str = id_name e.entry_id in
                  if id_str.[0]='1' then 
                   match e.entry_val with 
                   LL(_) -> (error "Undefined label \
                    %s" (String.sub id_str 1 ((String.length id_str)-1));
                   raise Exit)
                   | _ -> () else ()             
                    
                
      
                | ENTRY_function inf ->
                  if inf.function_isForward && not (List.exists (fun hd -> begin 
                        match hd with (D_header(id, _ , _, _)) -> (e.entry_id=(id_make id))
                                    | _ -> false
                      end) lib) then 
                    (error "Undefined function: %a" pretty_id e.entry_id;
                     raise Exit)
                  else   () 
                                        
                | _ -> ()
                  
              in
              let rec entries  es =
                match es with
                | [e] ->
                  entry e
                | e :: es ->
                   entry e ;entries es;
                | [] ->
                  () in
              match scp.sco_parent with
              | Some scpar ->
                
                  entries scp.sco_entries;
                  walk scpar
              | None ->
                ()
            end in
        let scope scp =
          if scp.sco_nesting == 0 then
            ()
          else
            walk scp in
             scope !currentScope