My playground for the [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) (I will call it "bf") programming language.

### Contents    
bf-code
- helloworld.bf
- fibonachi.bf

interpreters
- `interpreter.nim` writting in [Nim](https://nim-lang.org/) (can handle comments; no bracket validator)
  - has extra options for debugging and printing. Type `--help` to see them.

### Run commands
`./interpreters/interpreter bf-code/`

### code segments
```c
[-] \\zeros the slot
[>+<-] \\moves a value 1 slot forward
[>] \\ finds zero on the right
```

# TODO
- [ ] in interperter, redesign ascii_toogle command (mb use ':' and ';' for numeric)
- [ ] more transpilers & output filename option
- [ ] fix transpiler spacing