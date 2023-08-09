/* Command codes
code | ASCII | Char 
0 91 [
1 93 ]
2 43 +
3 45 -
4 62 >
5 60 <
6 44 ,
7 46 .

_ 33 ! 
*/

//input parsing
>>>>> >>>>> +[-
    ,>++++[<-------->-]< //-32 {n,0,0}
    //case !
    [-
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[->>>-<<<]<<
    //case +
    [----- -----
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<++>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case ,
    [-
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<++++++>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case -
    [-
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<+++>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case .
    [-
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<+++++++>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case <
    [>++[-<------->]<
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<+++++>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case >
    [--
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<++++>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case [
    [+>+++++[-<------>]<
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-]<< // if 2==1: {0,c,0}; else: {n,0,0}
    //case ]
    [--
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<+>]<< // if 2==1: {0,c,0}; else: {n,0,0}
    ]]]]]]]]]>[-<+>]>>>+>+
]<-

<<<<<[<<<<<]//back to start of highway (5)

/*
Command List
    Structure: {|0|*10, |c,l,n,0,1|*x }
    Zeros (controller):
        0th: 
        1st:
        2nd:
        3rd: execution trigger
        4th:
        5st: command
        6nd: n of active loops
        7rd: tape index
        8th: command index
        9th: highway start
    Highway:
        c: command
        l: loop
        n: number
        0: empty slot
        1: highway segment
*/

//get command
<[->+<]>[-<+> >>>>>+<<<<<]>>>>>- //copy command index onto highway
[[->>>>>+<<<<<]+>>>>>--] // go to command index
<<<<[-<[<<<<<] <<<<+>>>> >>>>>[>>>>>]<+<<<]// copy command into controller
>>>[-<<<+>>>]>+[<<<<<] // clean up
d
//execute command
<<<<- // temproary
[- //case +
    <<+>>
    [<<->>[-<+>]]
    <<[- //execute
        >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
        [[->>>>>+<<<<<]+>>>>>--] // go to tape index
        +<<+ //incrament number
        <<<[<<<<<] //go back
        <<<<<++++++ //prevent other commands from executing
    <]
]>[- //case -
    <+>
    [<->[->+<]]
    <[- //execute
        >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
        [[->>>>>+<<<<<]+>>>>>--] // go to tape index
        +<<- //incrament tape index
        <<<[<<<<<] //go back
        <<<<+++++ //prevent other commands from executing (note the number of +es)
    <<]
]>>[- //case >
    <<+>>
    [<<->>[-<+>]]
    <<[- //execute
        >>>>>+
        <<<<++++ //prevent other commands from executing
    <]
]>[- //case <
    <+>
    [<->[->+<]]
    <[- //execute
        >>>>>-
        <<<+++ //prevent other commands from executing
    <<]
]>>[- //case ,
    <<+>>
    [<<->>[-<+>]]
    <<[- //execute
        >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
        [[->>>>>+<<<<<]+>>>>>--] // go to tape index
        +<<, //take input
        <<<[<<<<<] //go back
        <<<<<++ //prevent other commands from executing
    <]
]>[- //case .
    <+>
    [<->[->+<]]
    <[- //execute
        >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
        [[->>>>>+<<<<<]+>>>>>--] // go to tape index
        +<<. //incrament tape index
        <<<[<<<<<] //go back
        // <<<<+ //prevent other commands from executing (note the number of +es)
    <<]
]>>

d

