%{
open Ast
%}

/* Tokens with payloads */
%token <int> INT
%token <string> IDENT

(* Arithmetic operators *)
%token PLUS MINUS TIMES

(* Boolean literals and operators *)
%token TRUE FALSE
%token NOT AND OR

(* Comparison operators *)
%token EQUALITY LT GT

(* Let-binding *)
%token LET BE IN

(* Functions *)
%token FUN ARROW

(* Grouping + EOF *)
%token LPAREN RPAREN
%token EOF

/* Precedence and associativity */
%left APP              /* lowest precedence */
%left OR
%left AND
%nonassoc EQUALITY LT GT
%left PLUS MINUS
%left TIMES
%right NOT
%right UMINUS

%start main
%type <Ast.expr> main

%%

main:
  | expr EOF { $1 }

expr:
  /* Boolean operators */
  | NOT expr %prec NOT              { UnOp (OpNot, $2) }
  | TRUE                            { BoolLit true }
  | FALSE                           { BoolLit false }

  /* Literals and variables */
  | INT                             { NumLit $1 }
  | IDENT                           { Var $1 }

  /* Unary minus */
  | MINUS expr %prec UMINUS         { UnOp (OpNeg, $2) }

  /* Binary operators */
  | expr AND expr                   { BinOp (OpAnd, $1, $3) }
  | expr OR expr                    { BinOp (OpOr, $1, $3) }
  | expr PLUS expr                  { BinOp (OpPlus, $1, $3) }
  | expr MINUS expr                 { BinOp (OpMinus, $1, $3) }
  | expr TIMES expr                 { BinOp (OpTimes, $1, $3) }
  | expr EQUALITY expr              { BinOp (OpEq, $1, $3) }
  | expr LT expr                    { BinOp (OpLt, $1, $3) }
  | expr GT expr                    { BinOp (OpGt, $1, $3) }

  /* Let-binding */
  | LET IDENT BE expr IN expr       { Let ($2, $4, $6) }

  /* Functions */
  | FUN IDENT ARROW expr            { Fun ($2, $4) }
  | expr expr %prec APP             { App ($1, $2) }

  /* Grouping */
  | LPAREN expr RPAREN              { $2 }
