# stockexsim
A stock exchange simulator using OCaml

Build
======================================
Create switch: `$ opam switch create . ocaml-base-compiler.4.09.0`

Install dependencies: `$ opam install dune utop extlib ounit graphics`

Update environment: `$ eval $(opam env)`

Build: `$ dune build src/main.exe`

Run
======================================
Run: `./_build/default/src/main.exe`

Output data will be found in `agents.csv` and `prices.csv`
