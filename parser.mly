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
%left OR
%left AND
%nonassoc EQUALITY LT GT
%left PLUS MINUS
%left TIMES
%right NOT
%right UMINUS
%left APP   /* Application lowest precedence */

%start main
%type <Ast.expr> main

%%

main:
  | expr EOF { $1 }

/* Split into 'simple' vs 'expr' to fix application parsing */
simple:
  | INT                            { NumLit $1 }
  | IDENT                          { Var $1 }
  | TRUE                           { BoolLit true }
  | FALSE                          { BoolLit false }
  | LPAREN expr RPAREN             { $2 }
  | FUN IDENT ARROW expr           { Fun ($2, $4) }

expr:
  /* Unary */
  | NOT expr %prec NOT             { UnOp (OpNot, $2) }
  | MINUS expr %prec UMINUS        { UnOp (OpNeg, $2) }

  /* Binary */
  | expr AND expr                  { BinOp (OpAnd, $1, $3) }
  | expr OR expr                   { BinOp (OpOr, $1, $3) }
  | expr PLUS expr                 { BinOp (OpPlus, $1, $3) }
  | expr MINUS expr                { BinOp (OpMinus, $1, $3) }
  | expr TIMES expr                { BinOp (OpTimes, $1, $3) }
  | expr EQUALITY expr             { BinOp (OpEq, $1, $3) }
  | expr LT expr                   { BinOp (OpLt, $1, $3) }
  | expr GT expr                   { BinOp (OpGt, $1, $3) }

  /* Let-binding */
  | LET IDENT BE expr IN expr      { Let ($2, $4, $6) }

  /* Application — only simple applied to simple */
  | expr simple %prec APP          { App ($1, $2) }

  /* Promote simple to expr */
  | simple                         { $1 }
