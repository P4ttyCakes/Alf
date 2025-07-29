# ALF - Simply Typed Lambda Calculus with Booleans, Numbers, and Let Expressions

This project is a simple interpreter for the **Arithmetic Language with Functions (ALF)**, implemented in OCaml. ALF is an extension of the Arithmetic Language (AL), and supports:
- Integer arithmetic
- Unary negation
- `let`-bindings
- First-class anonymous functions
- Function application with full **currying** support

The implementation includes:
- An abstract syntax tree (AST)
- A recursive evaluator (interpreter)
- A parser (via Menhir)
- A lexer (via OCamllex)
- A simple REPL-style interface

---

## Usage

You can run the interpreter from the command line using `dune`. Pipe an expression to the executable to see the result.

**Example:**
```sh
echo "let x = 10 in (fun y -> y * 2) (x + 5)" | dune exec ./main.exe
```
This will output:
```
Result: 30
```

---

## Assignment Background

I built this apart of Cyrus Omar's Future of Programming Lab. It is  based on the specifications provided in [Assignment 3] of [EECS 490 - Programming Languages] coursework at the University of Michigan.

The assignment focused on two styles of semantics:
1. **Evaluation Semantics**: Defines *how* an expression evaluates to a result by recursively interpreting subcomponents.
2. **Equational Semantics**: Defines *what* an expression means in terms of other expressions via substitution and rewriting.

---

##  Language Features

### Syntax

| Construct         | Concrete Syntax             | OCaml AST Representation      |
|------------------|-----------------------------|-------------------------------|
| Integer literal   | `42`                        | `NumLit 42`                   |
| Unary negation    | `-e`                        | `UnOp(OpNeg, e)`              |
| Binary operations | `e1 + e2`, `e1 - e2`, `e1 * e2` | `BinOp(OpPlus, e1, e2)` etc. |
| Let-binding       | `let x = e1 in e2`          | `Let("x", e1, e2)`            |
| Functions         | `fun x -> e`                | `Fun("x", e)`                 |
| Application       | `e1 e2`                     | `App(e1, e2)`                 |

### Semantics

- **E-Num**: `NumLit n` evaluates to `n`.
- **E-Neg**: `-e` evaluates to the negation of the value of `e`.
- **E-BinOp**: Binary operations are evaluated left-to-right on numeric subexpressions.
- **E-Let**: `let x = e1 in e2` evaluates `e1`, then substitutes the result in `e2`.
- **E-Fun**: `fun x -> e` creates a closure with the current environment.
- **E-App**: `e1 e2` evaluates `e1` to a closure and `e2` to a value, then applies the closure.

---

## Project Structure

```