import os
import strutils

type settings_tuple = tuple[
    ascii: bool,
    ascii_toogle: bool,
    debug: bool,
    breaks: bool,
    tape_size:int,
    transpile: char,
    output_file: string
]
type Command = ref object
    link_to_loop: bool
    loop: ref seq[Command]
    command: int

proc addLoopSequence(commandFile: string, commandFile_length: int, command_i: int, parent_command: Command, settings: settings_tuple): int =
    var command_i: int = command_i

    while command_i<commandFile_length:
        #dealing with comments
        if commandFile[command_i]=='/' and command_i<commandFile_length-1:
            if commandFile[command_i+1] == '/':
                while command_i<commandFile_length and commandFile[command_i]!='\n':
                    command_i+=1
                command_i+=1
            elif commandFile[command_i+1] == '*':
                while command_i<commandFile_length and commandFile[command_i..command_i+1]!="*/":
                    command_i+=1
                command_i+=2
        #process commands
        else:
            case commandFile[command_i]:
                of '>': # increases memory pointer, or moves the pointer to the right 1 block.
                    parent_command.loop[].add(Command(link_to_loop: false , command: 0))
                of '<': # decreases memory pointer, or moves the pointer to the left 1 block.
                    parent_command.loop[].add(Command(link_to_loop: false , command: 1))
                of '+': # increases value stored at the block pointed to by the memory pointer
                    parent_command.loop[].add(Command(link_to_loop: false , command: 2))
                of '-': # decreases value stored at the block pointed to by the memory pointer
                    parent_command.loop[].add(Command(link_to_loop: false , command: 3))
                of ',': # like c getchar(). input 1 character.
                    parent_command.loop[].add(Command(link_to_loop: false , command: 4))
                of '.': # like c putchar(). print 1 character to the console
                    parent_command.loop[].add(Command(link_to_loop: false , command: 5))
                of 'a': #toogles between ascii and numeric input/output
                    if settings.ascii_toogle:
                        parent_command.loop[].add(Command(link_to_loop: false , command: 6))
                of 'd': #prints the entire tape
                    if settings.debug:
                        parent_command.loop[].add(Command(link_to_loop: false , command: 7))
                of 'b': #waits for user input before proceeding
                    if settings.breaks:
                        parent_command.loop[].add(Command(link_to_loop: false , command: 8))
                of '[': # like c while(cur_block_value != 0) loop.
                    let new_command=Command(link_to_loop: true, loop: new seq[Command], command: 0)
                    parent_command.loop[].add(new_command)
                    command_i=addLoopSequence(commandFile,commandFile_length,command_i+1,new_command,settings)
                of ']': # if block currently pointed to's value is not zero, jump back to [
                    return command_i
                else:
                    discard
            command_i+=1
            
func compile(commandFile: string, settings: settings_tuple): Command = 
    # compiles the commandfile into a list of code numbers for each command
    var main_command: Command = Command(link_to_loop: true, loop: new seq[Command])
    discard addLoopSequence(commandFile,commandFile.len(),0,main_command,settings)
    return main_command

proc runCommand(command: Command, tape: ref seq[int], head: ref int, ascii: ref bool) =
    if command.link_to_loop:
        while tape[][head[]]!=0:
            for sub_c in command.loop[]:
                runCommand(sub_c,tape,head,ascii)
    else:
        case command.command:
            of 0: #>
                head[]+=1
            of 1: #<
                head[]-=1
            of 2: #+
                tape[][head[]]+=1
            of 3: #-
                tape[][head[]]-=1
            of 4: #,
                if ascii[]:
                    tape[][head[]]=ord(readChar(stdin))
                else:
                    tape[][head[]]=parseInt(readLine(stdin))
            of 5: #.
                if ascii[]:
                    stdout.write(chr(tape[][head[]]))
                else:
                    echo tape[][head[]]
                stdout.flushFile()
            of 6: #a
                ascii[]=not ascii[]
            of 7: #d
                echo "Tape: ",tape[]
                echo "Head: ",head[], " Ascii Toogle: ", ascii[]
            of 8: #b
                discard readLine(stdin)
            else:
                discard

proc run(main_command: Command, settings: settings_tuple) =
    var tape: ref seq[int] = new seq[int]; tape[].setLen(settings.tape_size)
    var head: ref int = new int
    var ascii: ref bool = new bool
    ascii[] = settings.ascii
    head[] = 0
    for sub_c in main_command.loop[]:
        runCommand(sub_c,tape,head,ascii)

proc transpile_command_to_c(command: int, command_stack: int, ascii: ref bool): string =
    if command_stack==0:
        return " "
    case command:
        of 0:
            return "head = head + " & $command_stack & ";"
        of 1:
            return "head = head - " & $command_stack & ";"
        of 2:
            return "tape[head] = tape[head] + " & $command_stack & ";"
        of 3:
            return "tape[head] = tape[head] - " & $command_stack & ";"
        of 4:
            if ascii[]:
                return "tape[head] = getchar();"
            else:
                return "scanf(\"%d\",&tape[head]);"
        of 5:
            if ascii[]:
                return "printf(\"%c\",tape[head]);"
            else:
                return "printf(\"%d\\n\",tape[head]);"
        of 6:
            ascii[]=not ascii[]
        else:
            discard
    return ""

proc transpile_loop_to_c(command: Command, ascii: ref bool,indentation: int): seq[string] =
    var c_code: seq[string] = @[]
    var command_stack = 0
    var last_command = 0
    var c_i = 0
    while c_i<command.loop[].len():
        let this_command = command.loop[][c_i]
        if this_command.link_to_loop:
            c_code.add(strutils.repeat("    ",indentation) & transpile_command_to_c(last_command,command_stack,ascii))
            last_command=0
            command_stack=0

            c_code.add(strutils.repeat("    ",indentation) & "while (tape[head]!=0) {")
            c_code &= transpile_loop_to_c(this_command,ascii,indentation+1)
            c_code.add(strutils.repeat("    ",indentation) & "}")
        elif this_command.command == last_command:
            command_stack+=1
        else:
            c_code.add(strutils.repeat("    ",indentation) & transpile_command_to_c(last_command,command_stack,ascii))
            last_command=this_command.command
            command_stack=1
        c_i+=1
    c_code.add(strutils.repeat("    ",indentation) & transpile_command_to_c(last_command,command_stack,ascii))
    return c_code

proc transpile_to_c(main_command: Command, settings: settings_tuple) =
    #prep
    echo "Transpiling to C, \nNote: debug and break are unsupported, ascii_toogle is at compile time"
    var c_code: seq[string] = @[]
    var ascii: ref bool = new bool
    ascii[] = settings.ascii
    #transpile
    c_code.add("#include <stdio.h>")
    c_code.add("int main(){")
    c_code.add("    int tape[" & $settings.tape_size & "] = {0};")
    c_code.add("    int head = 0;")
    c_code &= transpile_loop_to_c(main_command,ascii,1)
    c_code.add("}")
    #save
    let f = open(settings.output_file, fmWrite)
    for line in c_code:
        f.write(line)
        f.write("\n")
    f.close()
    echo "Created ",settings.output_file

proc main() =
    var cli_args: seq[string]
    let cli_arg_count = paramCount() # includes executable name
    for arg_i in countup(1,cli_arg_count):
        cli_args.add(paramStr(arg_i))
    if cli_arg_count>0:
        if cli_args[0] in "--help":
            echo "-h --help: this message" /
            "\n-a --ascii: display output as ascii" /
            "\n-at --ascii_toogle: add 'a' command to brainfuck, that toggles between ascii and number outputs" /
            "\n-d --debug: add 'd' command to brainfuck, that prints debug information" /
            "\n-b --breaks: add 'b' command into brainfuck, that holds the code" /
            "\n-s --tape_size: specify int tape size. default -s=128" /
            "\n-tc --transpile_to_c: will transpile into a C file."
        else:
            var error_occured: bool = false
            var commandFile: string
            try:
                commandFile = readFile(cli_args[^1])
            except CatchableError:
                echo "Error: Can't input open file"
                error_occured = true
            if not error_occured:
                var settings: settings_tuple = (false,false,false,false,256,' ',cli_args[^1] & ".c")
                var arg_i = 0
                while arg_i<cli_arg_count-1:
                    let arg = cli_args[arg_i].split('=')
                    case arg[0]:
                        of "-a", "--ascii":
                            settings.ascii = true
                        of "-at", "--ascii_toogle":
                            settings.ascii_toogle = true
                        of "-d", "--debug":
                            settings.debug = true
                        of "-b", "--breaks":
                            settings.breaks = true
                        of "-s", "--tape_size":
                            settings.tape_size = parseInt(arg[1])
                        of "-tc", "--transpile_to_c":
                            settings.transpile = 'c'
                        else:
                            echo "Unknown argument: ", arg
                    arg_i+=1
                if settings.transpile == ' ':
                    run(compile(commandFile,settings),settings)
                elif settings.transpile == 'c':
                    transpile_to_c(compile(commandFile,settings),settings)
                
    else:
        echo "No arguments! Enter -h for help"
main()