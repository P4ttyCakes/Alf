{
open Parser
}

rule read_token = parse
  (* Whitespace *)
  | [' ' '\t' '\n']        { read_token lexbuf }

  (* Literals *)
  | ['0'-'9']+ as num      { INT (int_of_string num) }
  | "true"                 { TRUE }
  | "false"                { FALSE }

  (* Boolean operators *)
  | "not"                  { NOT }
  | "and"                  { AND }
  | "or"                   { OR }

  (* Comparison operators *)
  | "="                    { EQUALITY }
  | ">"                    { GT }
  | "<"                    { LT }

  (* Arithmetic operators *)
  | '+'                    { PLUS }
  | '-'                    { MINUS }
  | '*'                    { TIMES }

  (* Let-binding *)
  | "let"                  { LET }
  | "be"                   { BE }
  | "in"                   { IN }

  (* Functions *)
  | "fun"                  { FUN }
  | "->"                   { ARROW }

  (* Grouping *)
  | '('                    { LPAREN }
  | ')'                    { RPAREN }

  (* Identifiers *)
  | ['a'-'z'] ['a'-'z' '0'-'9']* as id { IDENT id }

  (* End of file *)
  | eof                    { EOF }


  | _ as c { failwith ("Unexpected character: " ^ String.make 1 c) }

