// Para executar: nasm -felf64 main.asm && gcc main.c main.o && ./a.out
#include <stdio.h>

int Switch();

int doWhile();

int main() {
    int ret_status;

    printf(" ----- Testando macro SWITCH ----- \n");

    ret_status = Switch();

    printf("-------- Testando a macro DO-WHILE ---------- \n");

    ret_status = doWhile();
    
    return ret_status;
}