(* Symbol table *)

type pass_mode = PASS_BY_VALUE | PASS_BY_REFERENCE
type llvm_val = 
  | LL_dummy 
  | LL of Llvm.llvalue
  | LLB of Llvm.llbasicblock

type param_status =
  | PARDEF_COMPLETE                             (* ������ �������     *)
  | PARDEF_DEFINE                               (* �� ���� �������    *)
  | PARDEF_CHECK                                (* �� ���� �������    *)

type scope = {
  sco_parent : scope option;
  sco_nesting : int;
  mutable sco_entries : entry list;
  mutable sco_negofs : int
}

and variable_info = {                         (******* ��������� *******)
  variable_type   : Types.typ;                (* �����                 *)
  variable_offset : int                       (* Offset ��� �.�.       *)
}

and function_info = {                         (******* ��������� *******)
  mutable function_isForward : bool;          (* ������ forward        *)
  mutable function_paramlist : entry list;    (* ����� ����������      *)
  mutable function_redeflist : entry list;    (* ����� ���������� (2�) *)
  mutable function_result    : Types.typ;     (* ����� �������������   *)
  mutable function_pstatus   : param_status;  (* ��������� ����������  *)
  mutable function_initquad  : int ;           (* ������ �������        *)
  mutable function_ret_block : llvm_val

}

and parameter_info = {                        (****** ���������� *******)
  parameter_type           : Types.typ;       (* �����                 *)
  mutable parameter_offset : int;             (* Offset ��� �.�.       *)
  parameter_mode           : pass_mode        (* ������ ����������     *)
}

and entry_info = ENTRY_none
               | ENTRY_variable of variable_info
               | ENTRY_function of function_info
               | ENTRY_parameter of parameter_info

and entry = {
  entry_id    : Identifier.id;
  entry_scope : scope;
  entry_info  : entry_info;
  mutable entry_val : llvm_val
}
type lookup_type = LOOKUP_CURRENT_SCOPE | LOOKUP_ALL_SCOPES

val currentScope : scope ref              (* �������� ��������         *)
val quadNext : int ref                    (* ������� �������� �������� *)
val tempNumber : int ref                  (* �������� ��� temporaries  *)

val initSymbolTable  : int -> unit
val openScope        : unit -> unit
val closeScope       : unit -> unit
val newVariable      : Identifier.id -> Types.typ -> llvm_val-> bool -> Lexing.position -> entry
val newFunction      : Identifier.id -> llvm_val -> bool -> Lexing.position -> entry
val newParameter     : Identifier.id -> Types.typ -> pass_mode ->  entry -> llvm_val-> bool -> Lexing.position -> entry
val removeEntry : entry -> unit

val forwardFunction   : entry -> unit
val endFunctionHeader : entry -> Types.typ -> unit
val lookupEntry       : Identifier.id -> lookup_type -> bool -> Lexing.position -> entry

val start_positive_offset : int   (* ������ ������ offset ��� �.�.   *)
val start_negative_offset : int   (* ������ �������� offset ��� �.�. *)
