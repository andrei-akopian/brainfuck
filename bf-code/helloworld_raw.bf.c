#include <stdio.h>
int main(){
    int tape[128] = {0};
    int head = 0;
    head = head + 1;
    tape[head] = tape[head] + 9;
    while (tape[head]!=0) {
         
        head = head - 1;
        tape[head] = tape[head] + 8;
        head = head + 1;
        tape[head] = tape[head] - 1;
    }
     
    head = head - 1;
    printf("%c",tape[head]);
    head = head + 1;
    tape[head] = tape[head] + 7;
    while (tape[head]!=0) {
         
        head = head - 1;
        tape[head] = tape[head] + 4;
        head = head + 1;
        tape[head] = tape[head] - 1;
    }
     
    head = head - 1;
    tape[head] = tape[head] + 1;
    printf("%c",tape[head]);
    tape[head] = tape[head] + 7;
    printf("%c",tape[head]);
    tape[head] = tape[head] + 3;
    printf("%c",tape[head]);
    while (tape[head]!=0) {
         
        tape[head] = tape[head] - 1;
    }
    head = head + 1;
    tape[head] = tape[head] + 8;
    while (tape[head]!=0) {
         
        head = head - 1;
        tape[head] = tape[head] + 4;
        head = head + 1;
        tape[head] = tape[head] - 1;
    }
     
    head = head - 1;
    printf("%c",tape[head]);
    head = head + 1;
    tape[head] = tape[head] + 11;
    while (tape[head]!=0) {
         
        head = head - 1;
        tape[head] = tape[head] + 8;
        head = head + 1;
        tape[head] = tape[head] - 1;
    }
     
    head = head - 1;
    tape[head] = tape[head] - 1;
    printf("%c",tape[head]);
    tape[head] = tape[head] - 8;
    printf("%c",tape[head]);
    tape[head] = tape[head] + 3;
    printf("%c",tape[head]);
    tape[head] = tape[head] - 6;
    printf("%c",tape[head]);
    tape[head] = tape[head] - 8;
    printf("%c",tape[head]);
    while (tape[head]!=0) {
         
        tape[head] = tape[head] - 1;
    }
    head = head + 1;
    tape[head] = tape[head] + 8;
    while (tape[head]!=0) {
         
        head = head - 1;
        tape[head] = tape[head] + 4;
        head = head + 1;
        tape[head] = tape[head] - 1;
    }
     
    head = head - 1;
    tape[head] = tape[head] + 1;
    printf("%c",tape[head]);
    while (tape[head]!=0) {
         
        tape[head] = tape[head] - 1;
    }
     
    tape[head] = tape[head] + 10;
    printf("%c",tape[head]);
}
