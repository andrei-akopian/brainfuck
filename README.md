My playground for the [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) (I will call it "bf") programming language.

### Contents    
bf-code
- helloworld.bf
- fibonachi.bf

interpreters
- `interpreter.nim` writting in [Nim](https://nim-lang.org/) (can handle comments; no bracket validator)
  - has extra options for debugging and printing. Type `--help` to see them.
  - can transpile to C `-tc`
- `brainfuck.c` by Daniel B Cristofani
- `bfibf_by_dbc.bf` by Daniel B Cristofani
- `bf_in_bf.bf` by me

### Run commands
`./interpreters/interpreter bf-code/`

# Credit
- [some brainfuck fluff](http://brainfuck.org/) was extreamly usefull

# Cool code segments

# TODO
- [ ] in interperter, redesign ascii_toogle command (mb use ':' and ';' for numeric)
- [ ] more transpilers & output filename option
- [ ] fix transpiler spacing
- [ ] 2d bf: add V and ^ commands
- [ ] make a higher level language