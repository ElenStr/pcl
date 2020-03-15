val scope_names_to_array  : Symbol.scope option  -> string array
val scope_var_types_to_array : Symbol.scope option ->  Llvm.lltype array * int
(* val add_new_frame : string -> Symbol.scope option -> Llvm.llcontext -> Llvm.llbuilder -> Llvm.llvalue array *)
(* val frame_pointers : Llvm.llvalue array ref *)
(* val frame_pointers_names : string array ref *)
val par_sizes : int Stack.t
(* val scope_types : Llvm.llvalue array -> Llvm.lltype array *)
(* val remove_frame : unit -> unit *)
(* val get_env :  Symbol.entry_info -> Llvm.llvalue array *)
(* val set_env : Symbol.entry_info -> Llvm.llbuilder -> unit *)
val nest : Symbol.scope option -> int  
(* val lib_names  : string list *)