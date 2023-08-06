My playground for the [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) (I will call it "bf") programming language.

### Contents    
bf-code
- helloworld.bf

interpreters
- normal [Nim](https://nim-lang.org/) (can handle comments; no bracket validator)

### Run commands
`./interpreters/interpreter bf-code/`

### code segments
```c
[-] \\zeros the slot
[>+<-] \\moves a value 1 slot forward
[>] \\ finds zero on the right
```