type unOp = 
  | OpNeg 
  | OpNot (* For Booleans*)

type binOp =
  | OpPlus
  | OpMinus
  | OpTimes
  | OpAnd
  | OpOr
  | OpEq (*equality*)
  | OpGt (*Greater Than*)
  | OpLt (*Less Than*)


type expr =
  | BoolLit of bool
  | NumLit of int
  | Var of string
  | UnOp of unOp * expr
  | BinOp of binOp * expr * expr
  | Let of string * expr * expr
  | Fun of string * expr
  | App of expr * expr