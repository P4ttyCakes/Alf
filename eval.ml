open Ast

type value =
  | Int of int
  | Closure of string * expr * env
and env = (string * value) list

let rec eval_expr (env : env) (e : expr) : value =
  match e with
  | NumLit n -> Int n
  | Var x -> List.assoc x env
  | UnOp (OpNeg, e1) ->
      (match eval_expr env e1 with
       | Int n -> Int (-n)
       | _ -> failwith "Unary negation on non-integer")
  | BinOp (op, e1, e2) ->
      let v1 = eval_expr env e1 in
      let v2 = eval_expr env e2 in
      (match (op, v1, v2) with
       | (OpPlus, Int n1, Int n2) -> Int (n1 + n2)
       | (OpMinus, Int n1, Int n2) -> Int (n1 - n2)
       | (OpTimes, Int n1, Int n2) -> Int (n1 * n2)
       | _ -> failwith "Binary op on non-integers")
  | Let (x, e1, e2) ->
      let v1 = eval_expr env e1 in
      eval_expr ((x, v1) :: env) e2
  | Fun (x, body) -> Closure (x, body, env)
  | App (e1, e2) ->
      match eval_expr env e1 with
      | Closure (x, body, closure_env) ->
          let arg_val = eval_expr env e2 in
          eval_expr ((x, arg_val) :: closure_env) body
      | _ -> failwith "Application on non-function"
