
%{
open Ast
%}

%token <int> INT
%token <string> IDENT
%token PLUS MINUS TIMES
%token LET IN FUN ARROW
%token LPAREN RPAREN
%token EQUALS
%token EOF

%left PLUS MINUS
%left TIMES
%start main
%type <Ast.expr> main

%%

main:
  | expr EOF { $1 }

expr:
  | INT { NumLit $1 }
  | IDENT { Var $1 }
  | MINUS expr { UnOp (OpNeg, $2) }
  | expr PLUS expr { BinOp (OpPlus, $1, $3) }
  | expr MINUS expr { BinOp (OpMinus, $1, $3) }
  | expr TIMES expr { BinOp (OpTimes, $1, $3) }
  | LET IDENT EQUALS expr IN expr { Let ($2, $4, $6) }
  | FUN IDENT ARROW expr { Fun ($2, $4) }
  | expr expr { App ($1, $2) }
  | LPAREN expr RPAREN { $2 }
