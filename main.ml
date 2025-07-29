let () =
  let lexbuf = Lexing.from_channel stdin in
  let expr = Parser.main Lexer.read_token lexbuf in
  let result = Eval.eval_expr [] expr in
  match result with
  | Int n -> Printf.printf "Result: %d\n" n
  | Closure _ -> print_endline "<function>"
