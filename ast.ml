type unOp = OpNeg

type binOp =
  | OpPlus
  | OpMinus
  | OpTimes

type expr =
  | NumLit of int
  | Var of string
  | UnOp of unOp * expr
  | BinOp of binOp * expr * expr
  | Let of string * expr * expr
  | Fun of string * expr
  | App of expr * expr