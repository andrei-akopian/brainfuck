// run with the non ascii interpreter
// algorithm uses 4 blocks
// move means target_block=origin_block and origin_block=0
, //take fibonachi N into block 0
>>+<< // put 1 into block 2
// [fibonachi N, fibonachi number, last fibonachi number, last last fibonachi number]
[ //while N is greater than 0
>>> [<<+>>-] //move block 3 value to block 1
< [>+<<+>-] //move block 2 value to blocks 1 and 3
< . [>+<-] //print block 1 and move it to block 2
<-] //decrease N and repeat