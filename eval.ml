open Ast

type value =
  | Int of int
  | Closure of string * expr * env
and env = (string * value) list

let rec eval_expr (env : env) (e : expr) : value =
  match e with

  (* Numlits literals evaluate to themselves *)
  | NumLit n ->
      Int n

  (* Look up variable in current environment *)
  | Var x ->
      List.assoc x env

  (* Unary negation *)
  | UnOp (OpNeg, e1) ->
      let v1 = eval_expr env e1 in
      (match v1 with
       | Int n -> Int (-n)
       | _ -> failwith "Unary negation on non-integer")

  (* Binary operations *)
  | BinOp (op, e1, e2) ->
      let v1 = eval_expr env e1 in
      let v2 = eval_expr env e2 in
      (match (op, v1, v2) with
       | (OpPlus, Int n1, Int n2) -> Int (n1 + n2)
       | (OpMinus, Int n1, Int n2) -> Int (n1 - n2)
       | (OpTimes, Int n1, Int n2) -> Int (n1 * n2)
       | _ -> failwith "Binary operation on non-integers")

  (* Let-binding: let x = e1 in e2 *)
  | Let (x, e1, e2) ->
      let v1 = eval_expr env e1 in                    (* Evaluate e1 *)
      let extended_env = (x, v1) :: env in            (* Extend environment with (x, v1) *)
      eval_expr extended_env e2                      (* Evaluate e2 in the extended env *)

  (* Function definition: fun x -> body *)
  | Fun (x, body) ->
      Closure (x, body, env)                          (* Create closure with param x, body, and current env *)

  (* Function application: e1 e2 *)
  | App (e1, e2) ->
      let f = eval_expr env e1 in                     (* Evaluate function expression *)
      let arg = eval_expr env e2 in                   (* Evaluate argument expression *)
      (match f with
       | Closure (x, body, closure_env) ->
           let extended_env = (x, arg) :: closure_env in   (* Extend captured env with parameter binding *)
           eval_expr extended_env body               (* Evaluate body of function in new env *)
       | _ -> failwith "Attempted to apply a non-function")
