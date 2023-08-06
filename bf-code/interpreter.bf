/* Command codes
62 > 19
60 < 17
43 + 0
45 - 2
91 [ 48
93 ] 50
44 , 1
46 . 3
*/

//LIST prototype
//list are pairs: [zero,data]
,[>>+<<-]>>//copy to zero of the first pair
[[>>+<<-]+>>-]+ //move forward while leaving behind "a trail" of 1s
>,< // DO THE OPERATION (eg write)
>.< // DO THE OPERATION (eg print)
[-<<] //return to index 0 using the "trail of 1s"
