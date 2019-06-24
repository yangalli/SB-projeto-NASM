/*
    Programa em C que executa as macros do-while, while-do, for e switch
    feitas em Assembly NASM.

    Grupo:
    Nicholas Nishimoto Marques - 15/0019343
    Vinicíus Costa e Silva - 15/0052138
    Yan Pietro Barcellos Galli - 16/0149207
    João Gabriel Lima Neves - 150131992 

 */

// Para executar: nasm -felf64 main.asm && gcc main.c main.o && ./a.out
#include <stdio.h>

int Switch();
int doWhile();
int For();
int whileDo();

int main() {
    int status;

    printf("----- INICIANDO TESTE DAS MACROS ----- \n");

    printf(" ----- Testando macro SWITCH ----- \n");

    status = Switch();

    printf("-------- Testando a macro DO-WHILE ---------- \n");

    status = doWhile();

    printf("-------- Testando a macro WHILE-DO -------- \n");

    status = whileDo();

    printf("-------- Testando a macro FOR --------- \n");

    status = For();

    
    return status;
}