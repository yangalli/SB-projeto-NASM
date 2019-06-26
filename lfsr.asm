%include "macros-lfsr.inc"
%define NN 16 ; numero de intervalos

; Códigos Objeto: [nasm -f elf lfsr.asm
; nasm -f elf -d ELF_TYPE macros-lfsr.asm]
; Compilação: gcc -m32 lfsr.o -o lfsr-asm macros-lfsr.o

; popa -> restaura regs base, índice e de segmentos
; leave -> desaloca variáveis locais
; call -> salva endereço da prox Inst na pilha
; ret -> retira da pilha o endereço da Inst a executar
; loop, loope, loopz, loopne, jcxz -> desvios condicionais

SECTION .data
	output1 db "intervalo ", 0
	output2 db " tem ", 0
	output3 db " elementos", 0
	seed	dq 1	; seed inicial

SECTION .bss
	class resd NN ; vetor com a frequencia de cada intervalo

SECTION .text
global lfsr_main
lfsr_main:
	enter 0,0 		; setup routine
	pusha

	; Começo do código assembly
	mov ebx, seed ; coloca a seed no base
	mov edx, 0		; zera a extensão do acumulador
	
	do:
		; Fibonacci LFSR
		; Posições dos bits que afetam os próximo estado -> taps = 24 23 22 17 
		; feedback polinomial -> (x^24 + x^23 + x^22 + x^17 + 1) +1
		mov ecx, ebx  ; vetor com a frequencia de cada intervalo
		mov eax, ebx  ; coloca a seed no acumulador
		shr ecx, 2    ; shifta o valor de ecx em 2 bits
		xor eax, ecx	; aplica o xor entre o acumulador e o contador de objetos
		shr ecx, 1		;	shifta o acumulador
		xor eax, ecx	; aplica novamente xor entre o acumulador e o contador de objetos 
		shr ecx, 2
		xor eax, ecx
		shr ecx, 5    ; Fibonacci ...
		xor eax, ecx
		shr ecx, 8
		xor eax, ecx
		and eax, 1    ; realiza uma operação de and com o acumulador (1 do polinômio)

		shl eax, 23
		shr ebx, 1
		or eax, ebx
		mov ebx, eax

		and eax, 0x00FFFFFF   ; 24 bits

		; Calculando o intervalo do número
		and eax, 0x000F ; 16

		; Incrementa um no intervalo (vetor de frequencias)
		add dword [class + eax*4], 1

		inc edx
		cmp edx, 16777215
	jne do
	; Isso ocorre até o lfsr voltar ao seu estado inicial start_state

	; Mostra os valores -> usando o arquivo do Paul Carter
	mov ecx, 0
	results:
		mov eax, output1
		call print_string

		mov eax, ecx
		call print_int

		mov eax, output2
		call print_string

		mov eax, [class + ecx*4]
		call print_int

		mov eax, output3
		call print_string

		call print_nl
		inc ecx
		cmp ecx, NN
	jne results

	; Finaliza zerando o base e incrementando o acumulador
	mov ebx, 0
	mov eax, 1
	int 0x80

	popa
	mov eax, 0 	; retorne para o programa C
	leave
	ret