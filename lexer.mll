{
open Parser
}

rule read_token = parse
  | [' ' '\t' '\n'] { read_token lexbuf }
  | ['0'-'9']+ as num { INT (int_of_string num) }
  | '+' { PLUS }
  | '-' { MINUS }
  | '*' { TIMES }
  | '=' { EQUALS }
  | "let" { LET }
  | "in" { IN }
  | "fun" { FUN }
  | "->" { ARROW }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | ['a'-'z'] ['a'-'z' '0'-'9']* as id { IDENT id }
  | eof { EOF }
