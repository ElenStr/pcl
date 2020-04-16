open Ast
open Lexing
open Semantics
open Error
open Compile
open Llvm_target
open Cmdliner
open Str
open Llvm 

type prompt_t = Final | Intermidiate | From_file

let print_intermediate src file opt = 
  let cin  = if file=""  then stdin else open_in src in
  let lexbuf = Lexing.from_channel cin in
    lexbuf.lex_curr_p <- {lexbuf.lex_curr_p with pos_fname = src};
    try
    let decl, stmt = Parser.program Lexer.lexer lexbuf in
  
    
    let the_module = sem (decl, stmt) opt  in
    Printf.printf "%s" (string_of_llmodule the_module)
  with Parser.Error->
    let position = lexbuf.Lexing.lex_curr_p in 
    error "Synatx error: %a" print_position (position_point position) ;
    exit 1
    
let print_final src file opt = 
  let cin  = if file=""  then stdin else open_in src in
  let lexbuf = Lexing.from_channel cin in
  lexbuf.lex_curr_p <- {lexbuf.lex_curr_p with pos_fname = src};
  try
  let decl, stmt = Parser.program Lexer.lexer lexbuf in
  
  (* print (decl, stmt) ; Printf.printf "\n"; *)
  let the_module = sem (decl, stmt) opt  in 
    Llvm_all_backends.initialize();
    let target_m = TargetMachine.create (Target.default_triple ()) (Target.by_triple (Target.default_triple ())) in
    Llvm.set_target_triple (TargetMachine.triple target_m) the_module;

    let _ = if file="" then 
     let code = TargetMachine.emit_to_memory_buffer the_module CodeGenFileType.AssemblyFile target_m in
      Printf.printf "%s" (MemoryBuffer.as_string code)
    else 
     (print_module (file^".imm") the_module ;       
      let _ = TargetMachine.emit_to_file the_module CodeGenFileType.AssemblyFile (file^".asm") target_m in
       ()
       ) in 
    exit 0
  with Parser.Error->
    let position = lexbuf.Lexing.lex_curr_p in 
    error "Synatx error: %a" print_position (position_point position) ;
    exit 1

let path_of src = 
  let valid =  Str.regexp ".*\.pcl" in 
  match Str.string_match valid src 0 with 
  | true -> List.hd (split (regexp "\.pcl") src)
  | _ -> (error "Invalid File Format\n%s\n" src; exit 1)

  
let compile prompt optimize src =
  

    match prompt with 
    |From_file ->
      let path  = path_of src in 
      print_final src path optimize
    |Final -> print_final src "" optimize
    | _ -> print_intermediate src "" optimize
 

let src = 
  let rev = true in 
  Arg.(value & pos ~rev 0 file "" & info [] ~docv:"FILE")

let optimize = 
  let doc = "Add compiler optimizations." in 
  Arg.(value & flag & info ["o"] ~doc)

let prompt = 
  let doc = "Read from stdin, print final code to stdout." in 
  let final = Final, Arg.info ["f"] ~doc in
  let doc = "Read from stdin, print intermidiate code to stdout." in 
  let intermidiate = Intermidiate, Arg.info ["i"] ~doc in 
  Arg.(last & vflag_all [From_file] [final; intermidiate])

let compile_t = Term.(const compile $ prompt $ optimize $ src)

let () = Term.(exit @@ eval (compile_t, Term.info "pclc"))
