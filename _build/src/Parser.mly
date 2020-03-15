%{
	open Ast
	open Types
	open Symbol

	
%}
%token T_eof
%token <Ast.name> T_name
%token <int> T_int_const 
%token <float>T_real_const 
%token <string>T_char_const 
%token <string>T_string_const 
%token <bool> T_false T_true

%token T_boolean T_char T_array T_integer T_real

%token T_and T_or T_not
 
%token T_begin T_end

%token T_dispose
%token T_div T_mod
%token T_do
%token T_else
%token T_forward
%token T_function
%token T_goto
%token T_if
%token T_label
%token T_new
%token T_nil
%token T_of
%token T_procedure
%token T_program
%token T_result
%token T_return
%token T_then
%token T_var
%token T_while

%token T_eq T_gt T_lt T_neq  T_geq T_leq 
 
%token T_plus T_minus T_times T_division T_caret T_at
 
%token T_assign
%token T_semicolon T_fullstop T_colon T_comma

%token T_lparen T_rparen T_lbracket T_rbracket
 

%nonassoc T_eq T_gt T_lt T_geq T_leq T_neq
%left T_plus T_minus T_or
%left T_times T_division T_div T_mod T_and
%left T_not
%nonassoc Un_minus Un_plus
%left T_caret

%left T_at 

%nonassoc T_then
%nonassoc T_else


%start program
%type <Ast.ast_decl list * Ast.ast_stmt > program
/* %type <ast_decl list> local_list, params, formal_list
%type <ast_stmt list> block
%type <ast_decl> header, local,  formal
%type <typ> pcl_type */
/* %type <ast_stmt list> stmt_list
%type <ast_stmt> stmt
%type <ast_expr> expr  */

%%

program   : T_program T_name T_semicolon body T_fullstop T_eof { $4 }

body : local_list block { ($1, S_block($2)) }

local_list : {[]}
					| local_list local {$1 @ $2}

local     : T_var variable_decl_list { $2 }
          | T_label T_name decl_list T_semicolon {[ D_label ($2::$3, $startpos($2)) ]}
  	      | header T_semicolon body T_semicolon {[ D_fun ($1, $3)] }
	        | T_forward header T_semicolon { [$2] }


variable_decl_list  :  T_name decl_list T_colon pcl_type T_semicolon { [D_var ($1::$2 , $4, $startpos($4))] }
										|  variable_decl_list T_name decl_list T_colon pcl_type T_semicolon { $1 @ [D_var ($2::$3, $5, $startpos($4))]}

decl_list  : {[]}
					 | decl_list T_comma T_name {$1 @ [$3]}



header    : T_procedure T_name T_lparen params T_rparen { D_header ($2, TYPE_none, $4, $endpos)}
				  | T_function  T_name T_lparen params T_rparen T_colon pcl_type { D_header ($2, $7, $4, $endpos)}

params  : {[]}
				| formal formal_list {$1 :: $2}

formal_list : {[]}
            | formal_list T_semicolon formal {$1 @ [$3]}

formal : T_name decl_list T_colon pcl_type { D_param ($1::$2, $4, PASS_BY_VALUE, $endpos) }
			 | T_var T_name decl_list T_colon pcl_type {D_param ($2::$3, $5, PASS_BY_REFERENCE, $endpos) }

		 

pcl_type : T_integer {TYPE_int} | T_real {TYPE_real} | T_boolean {TYPE_bool} | T_char {TYPE_char}
		 | T_array T_of pcl_type { TYPE_array ($3, None)}
		 | T_array T_lbracket T_int_const T_rbracket T_of pcl_type {TYPE_array($6, Some($3))  }
		 | T_caret pcl_type {TYPE_ptr $2}

block  : T_begin stmt stmt_list T_end {$2::$3}

stmt_list  : {[]}
					 | stmt_list T_semicolon stmt {$1@[$3]}

stmt  : {S_empty}					 
			| l_val T_assign expr { S_assign($1, $3, $startpos, $endpos)}
			| block {S_block($1)}
			| call {S_call($1)}
			| T_if expr T_then stmt  T_else stmt {S_if($2,$4,Some($6))}
			| T_if expr T_then stmt  {S_if($2,$4,None)}
			| T_while expr T_do stmt{S_while($2,$4)}
			| T_name T_colon stmt {S_label($1,$3, $startpos)}
			| T_goto T_name {S_goto($2, $startpos($2))}
			| T_return {S_return}
			| T_new l_val {S_new_el($2, $startpos($2))}
			| T_new T_lbracket expr T_rbracket l_val {S_new_array($3,$5, $startpos)}
			| T_dispose l_val {S_dispose_el($2, $startpos)}
			| T_dispose T_lbracket T_rbracket l_val {S_dispose_array($4, $startpos)}

expr  : l_val {Lval($1, $startpos)}
      | r_val { $1 }

l_val : T_name {Var($1)}	| T_result {Res} | T_string_const {String_const($1)} 
			| l_val T_lbracket expr T_rbracket {Array_element($1,$3)}
			| expr T_caret{Deref($1)}
			| T_lparen l_val T_rparen {$2}

r_val : T_int_const {Const(INT($1))} | T_true {Const(BOOL($1))} | T_false {Const(BOOL($1))} | T_real_const {Const(REAL($1))} | T_char_const {Const(CHAR($1))} | T_nil {Const(NIL)}
			| T_lparen r_val T_rparen {$2}
			| call{$1}
			| T_at expr {Rval(At($2), $startpos)}
			| unop_expr {Rval($1, $startpos)}
			| expr T_plus expr {Rval(Binary($1,Num_op(O_plus),$3), $startpos)}
			| expr T_minus expr {Rval(Binary($1,Num_op(O_minus),$3), $startpos)}
			| expr T_times expr {Rval(Binary($1,Num_op(O_times),$3), $startpos)}
			| expr T_division expr {Rval(Binary($1,Num_op(O_division),$3), $startpos)}
			| expr T_div expr {Rval(Binary($1,Num_op(O_div),$3), $startpos)}
			| expr T_mod expr {Rval(Binary($1,Num_op(O_mod),$3), $startpos)}
			| expr T_or expr {Rval(Binary($1,Logic_op(O_or),$3), $startpos)}
			| expr T_and expr {Rval(Binary($1,Logic_op(O_and),$3), $startpos)}
			| expr T_eq expr {Rval(Binary($1,Eq_op(O_eq),$3), $startpos)}
			| expr T_gt expr {Rval(Binary($1,Cmp_op(O_gt),$3), $startpos)}
			| expr T_lt expr {Rval(Binary($1,Cmp_op(O_lt),$3), $startpos)}
			| expr T_neq expr {Rval(Binary($1,Eq_op(O_neq),$3), $startpos)}
			| expr T_geq expr {Rval(Binary($1,Cmp_op(O_geq),$3), $startpos)}
			| expr T_leq expr {Rval(Binary($1,Cmp_op(O_leq),$3), $startpos)}


call  : T_name T_lparen T_rparen {E_call($1,[], $startpos)}			
			  | T_name T_lparen expr expr_list T_rparen {E_call($1,$3::$4, $startpos)}
expr_list : {[]}			
					| expr_list T_comma expr {$1 @ [$3]}

unop_expr  : T_not expr {Unary(U_not,$2)}					
			| T_plus expr %prec Un_plus {Unary(U_plus,$2)}
			| T_minus expr %prec Un_minus {Unary(U_minus,$2)}

