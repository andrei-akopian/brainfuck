import os
import strutils

let commandFile = readFile(paramStr(1))

func compile(commandFile: string): seq[int8] = 
    # compiles the commandfile into a list of code numbers for each command
    var commands: seq[int8] = @[]

    var comment: bool = false
    var longComment: bool = false
    var star_flag: bool = false
    var comment_start_flag: bool = false
    
    for commandCharacter in commandFile:
        #dealing with comments
        case commandCharacter:
            of '/':
                if star_flag: #end long comment
                    comment=false
                    longComment=false
                elif not comment:
                    comment=true
                    comment_start_flag=true
            of '*':
                    if comment_start_flag:
                        longComment=true
                    elif longComment:
                        star_flag=true
            of '\n':
                if not longComment and comment:
                    comment=false
            else:
                star_flag=false
                comment_start_flag=false
                #dealing with commands and disregard other characters
        if not comment:
            case commandCharacter:
                of '>': # increases memory pointer, or moves the pointer to the right 1 block.
                    commands.add(0)
                of '<': # decreases memory pointer, or moves the pointer to the left 1 block.
                    commands.add(1)
                of '+': # increases value stored at the block pointed to by the memory pointer
                    commands.add(2)
                of '-': # decreases value stored at the block pointed to by the memory pointer
                    commands.add(3)
                of '[': # like c while(cur_block_value != 0) loop.
                    commands.add(4)
                of ']': # if block currently pointed to's value is not zero, jump back to [
                    commands.add(5)
                of ',': # like c getchar(). input 1 character.
                    commands.add(6)
                of '.': # like c putchar(). print 1 character to the console
                    commands.add(7)
                else:
                    discard
    return commands

proc run(commands: seq[int8]) =
    var tape: array[256, int32]
    var loop_starts: seq[int] = @[]
    var head: int32 = 0
    var commandI = 0
    var skip: int = 0 #skip inactive loop
    while commandI<commands.len():
        let command=commands[commandI]
        if skip>0:
            if command==4:
                skip+=1
            if command==5:
                skip-=1
        else:
            case command:
                of 0: # increases memory pointer, or moves the pointer to the right 1 block.
                    head+=1 
                of 1: # decreases memory pointer, or moves the pointer to the left 1 block.
                    head-=1 
                of 2: # increases value stored at the block pointed to by the memory pointer
                    tape[head]+=1
                of 3: # decreases value stored at the block pointed to by the memory pointer
                    tape[head]-=1
                of 4: # like c while(cur_block_value != 0) loop.
                    if tape[head]==0:
                        skip=1
                    else:
                        loop_starts.add(commandI)
                of 5: # if block currently pointed to's value is not zero, jump back to [
                    if tape[head]==0:
                        loop_starts.delete(loop_starts.len-1)
                    else:
                        commandI=loop_starts[loop_starts.len-1]
                of 6: # like c getchar(). input 1 character.
                    tape[head]=int32(parseInt(readLine(stdin)))
                of 7: # like c putchar(). print 1 character to the console
                    echo tape[head]
                else:
                    discard
        commandI+=1

run(compile(commandFile))