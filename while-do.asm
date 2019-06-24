; nasm -f elf while-do.asm

%include "asm_io.inc"

%macro DO 0
    %ifctx WHILE
        jmp %$cont
	    %$ifend:
	        %pop
	%else
	    %push DO
	    %$ifnend:
	%endif
%endmacro

%macro WHILE 1
	%ifctx DO
		j%-1 %$ifnend
		%pop
	%else
		%push WHILE
		%$cont:
		    j%-1 %$ifend
	%endif
%endmacro


section .dat
msg_teste1 		db "Iniciando teste while-do...", 0xa, 0
newline 		db "", 0xa, 0


segment .bss

segment .text
  global  whileDo
  
	whileDo:
	enter	0,0               ; setup routine
	pusha

mov eax, msg_teste1
call print_string

mov ecx, 10

cmp ecx,0
WHILE ne
	mov eax, ecx
	call print_int
	mov eax, newline
	call print_string
	sub ecx, 1
  cmp ecx,0
DO

popa
mov	eax, 0
leave
ret