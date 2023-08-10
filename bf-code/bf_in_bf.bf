/* Command codes[
code | ASCII | Char 
0 91 [
1 93 ]
2 43 +
3 45 -
4 62 >
5 60 <
6 44 ,
7 46 .

8 33 ! 
]*/

/*
Command List
    Structure: {|0|*10, |c,l,n,0,1|*x }
    Zeros (controller):
        0th: 
        1st:
        2nd:
        3rd: execution trigger
        4th: cammand
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

//input parsing
>>>>> >>>>> +[-
    ,>++++[<-------->-]< //-32 {n,0,0}
    //case !
    [-
        >>+<< //{n,0,1}
        [>>-<<[->+<]] //if n>0: {0,n,0}; elif n==0 {0,0,1}
        >[<+>-] //move n from 1 to 0
        >[-<++++++++>>>>-<<<]<< //a too high command code won't get executed
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

        //set up link
        
    ]]]]]]]]]

    //|c=?,l=command index,backup=0,buffer=0,h=0|
    //pointer postition: l

    >[-<+>] //move command code from l to c
    <<<<<[->+>>>>+<<<<<]>[-<+>]>>>>+ //copy current command index into l variable
    >>>+ //build highway
        // build loop link (for previous command)
        // state |c=?,l=command index,backup=0,buffer=0,h=0|
    <<<<< <<<<  // go to previous command
            [-
            >>>+<<< //check if command==1
            [>>>-<<<[->>+<<]]
            >>+ //backup: account for minus 3 lines above 
            >[- //execute if buffer==1
                >[-] //open highway enterance (on closing braket)
                <<<<
                +[- //find openning braket
                    <<<<<[<<<<<] //find command with code 0 (openning braket)
                    >>>[-<+<<+>>>]<[->+<]<< //check buffer if already linked
                ]
                //link
                >[->+<]//backup opening braket index in its backup
                >>>[-] //open oppening braket highway enterance
                >>>>> [>>>>>] <<< //go to closing brakets command index
                [-<< [<<<<<] <<<+>>> >>>>> [>>>>>] <<<] //move closing brakets command index to openning brakets l variable
                << [<<<<<] <<// go to oppening brakets backup
                [->> >>>>> [>>>>>] <<<+<< [<<<<<] <<] //move openging brakets backed up command index to closing brakets l variable
                > + > + [>>>>>] //oppening braket: mark buffer, close highway entrance and go back to closing braket
                + //close closing braket's highway entrace
                < //back to the closing braket's buffer
            ]
            <<< //back to c variable
        ]>>[-<<+>>]>> //return backup & go to highway
    >>>>> // go back to the current command
>+]<

[<[-]<[-]<-<<] //back to start & clean up highway. Decrease command index by 1 to account for an off by 1 error.

/*
Command List
    Structure: {|0|*10, |c,l,n,0,h|*x }
    Zeros (controller):
        0th: 
        1st:
        2nd:
        3rd: execution trigger
        4th: cammand
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
        h: =1; highway segment
*/

//running the code
+[-
    //get command
    <[->+<]>[-<+> >>>>>+<<<<<]>>>>>- //copy command index onto highway
    [[->>>>>+<<<<<]+>>>>>--] // go to command index
    <<<<[-<[<<<<<] <<<<+>>>> >>>>>[>>>>>]<+<<<]// copy command into controller
    >>>[-<<<+>>>]>+[<<<<<] // clean up
    //execute command
    <<<<+
    [- //case // opening braket
        <<+>>
        [<<->>[-<+>]]
        <<[-//execute
            //if tape[head]==0: increment command by 1
            //if tape[head]!=0: set command to the one specified in the loop variable
            >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
            [[->>>>>+<<<<<]+>>>>>--]+ // go to tape index and close the highway behind you
            <<[>>-<<[->+<]]>>
            [// ==0 case
                [<<<<<] //go back to start
                <[->+<]>[->>>>>+<<<<<]>>>>>- //copy command index onto highway while zerroring the command index slot
                [[->>>>>+<<<<<]+>>>>>--] // go to command index
                <<<[->>+<< <<[<<<<<]<+>>>>>>[>>>>>]<<<] // copy loop variable into command index
                >>[-<<+>>]>+[<<<<<] //clean up & go back to highway start
                >>>>>[-]// go to "skipable" postition on tape and exit
            ]<[-<+>]>[-]+ //clean up
            [<<<<<] // go to highway start
            <<<<<+++++++++ //prevent other commands from executing
        <]
    ]>[- //case // closing braket
        <+>
        [<->[->+<]]
        <[- //execute
            //if tape[head]==0: increment command by 1
            //if tape[head]!=0: set command to the one specified in the loop variable
            >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
            [[->>>>>+<<<<<]+>>>>>--]+ // go to tape index
            <<[// !=0 case
                >>[<<<<<] //go back to start
                <[->+<]>[->>>>>+<<<<<]>>>>>- //copy command index onto highway while zerroring the command index slot
                [[->>>>>+<<<<<]+>>>>>--] // go to command index
                <<<[->>+<< <<[<<<<<]<+>>>>>>[>>>>>]<<<] // copy loop variable into command index
                >>[-<<+>>]>+[<<<<<] //clean up & go back to highway start
                >>>[->+<]// go to "skipable" postition on tape and exit
            ]>[-<+>] //clean up
            <<<<[<<<<<] // go to highway start
            <<<<++++++++ //prevent other commands from executing
        <<]
    ]>>[- //case +
        <<+>>
        [<<->>[-<+>]]
        <<[- //execute
            >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
            [[->>>>>+<<<<<]+>>>>>--]+ // go to tape index
            <<+ //incrament number
            <<<[<<<<<] //go back
            <<<<<+++++++ //prevent other commands from executing
        <]
    ]>[- //case -
        <+>
        [<->[->+<]]
        <[- //execute
            >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
            [[->>>>>+<<<<<]+>>>>>--]+ // go to tape index
            <<- //incrament tape index
            <<<[<<<<<] //go back
            <<<<++++++ //prevent other commands from executing (note the number of +es)
        <<]
    ]>>[- //case >
        <<+>>
        [<<->>[-<+>]]
        <<[- //execute
            >>>>+
            <<<+++++ //prevent other commands from executing
        <]
    ]>[- //case <
        <+>
        [<->[->+<]]
        <[- //execute
            >>>>-
            <<++++ //prevent other commands from executing
        <<]
    ]>>[- //case ,
        <<+>>
        [<<->>[-<+>]]
        <<[- //execute
            >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
            [[->>>>>+<<<<<]+>>>>>--]+ // go to tape index
            <<, //take input
            <<<[<<<<<] //go back
            <<<<<+++ //prevent other commands from executing
        <]
    ]>[- //case .
        <+>
        [<->[->+<]]
        <[- //execute
            >>>>[->>+<<]>>[-<<+>> >>>>>+<<<<<]>>>>>- //copy tape index onto highway
            [[->>>>>+<<<<<]+>>>>>--]+ // go to tape index
            <<. //print
            <<<[<<<<<] //go back
            <<<<++ //prevent other commands from executing (note the number of +es)
        <<]
    ]>>[- //case !
        <<+>>
        [<<->>[-<+>]]
        <<[- //execute
            >>>>>>-<<<<<<
        ]
    ]>[-]>>>>+ //clean up, and increase command index
>+]