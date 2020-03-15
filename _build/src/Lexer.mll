{
  open Lexing
  open Printf
  open Parser
  

}

let digit  = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let name   = letter+(letter | digit | '_')*
let real   = (((digit#'0')digit*)|'0')('.'digit+)(['E' 'e']['+' '_']?digit+)?
let char   = ([^ '\\' '\'' '\"' ] | ('\\' [ 'n' 't' 'r' '0' '\\' '\'' '\"']))
let white  = [' ' '\t' '\r']

rule lexer = parse
    "and"     { T_and}
  | "array"   { T_array}
  | "begin"   { T_begin }
  | "boolean" { T_boolean  }
  | "char"    { T_char  }
  | "dispose" { T_dispose  }
  | "div"     { T_div  }
  | "do"      { T_do  }
  | "else"    { T_else }
  | "end"     { T_end  }
  | "false"   { T_false false}
  | "forward" { T_forward  }
  | "function"{ T_function }
  | "goto"    { T_goto  }
  | "if"      { T_if  }
  | "integer" { T_integer  }
  | "label"   { T_label }
  | "mod"     { T_mod  }
  | "new"     { T_new }
  | "nil"     { T_nil }
  | "not"     { T_not }
  | "of"      { T_of }
  | "or"      { T_or  }
  | "procedure"  { T_procedure  }
  | "program"    { T_program }
  | "real"       { T_real  }
  | "result"     { T_result }
  | "return"     { T_return  }
  | "then"       { T_then }
  | "true"       { T_true true}
  | "var"        { T_var }
  | "while"      { T_while  }


  | digit+   { T_int_const ( int_of_string (lexeme lexbuf))  }
  | real     { T_real_const ( float_of_string (lexeme lexbuf)) }
  
  | name   { T_name (lexeme lexbuf) }

  | '='      { T_eq  }
  | '>'      { T_gt  }
  | '<'      { T_lt  }
  | "<>"     { T_neq  }
  | ">="     { T_geq  }
  | "<="     { T_leq  }
  | '+'      { T_plus  }
  | '-'      { T_minus  }
  | '*'      { T_times  }
  | '/'      { T_division  }
  | '^'      { T_caret  }
  | '@'      { T_at  }

  | ":="     { T_assign  }
  | ';'      { T_semicolon  }
  | '.'      { T_fullstop  }
  | '('      { T_lparen  }
  | ')'      { T_rparen  }
  | ':'      { T_colon  }
  | ','      { T_comma  }
  | '['      { T_lbracket  }
  | ']'      { T_rbracket  }
 

  | '\n'     {new_line lexbuf;lexer lexbuf}
  | white+               { lexer lexbuf }
  
  | "(*" {comment lexbuf}
  | '\'' char '\'' { T_char_const ( (lexeme lexbuf))} 
  | '\"' char* '\"' {T_string_const (String.sub (lexeme lexbuf) 1 (String.length (lexeme lexbuf)-2))}
  |  eof          { T_eof }
  |  _ as chr     { eprintf "invalid character: '%c' (ascii: %d) in line '%d'\n"
                      chr (Char.code chr) (let pos = lexeme_start_p lexbuf in pos.pos_lnum);
                    lexer lexbuf }
and comment = parse
  |"*)" {lexer lexbuf}
  | '\n' {new_line lexbuf;comment lexbuf}
  | _ {comment lexbuf}
    


