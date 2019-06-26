%include "macros-lfsr.inc"
%define NN 16 ; numero de classes

SECTION .data
	output1 db "classe ", 0
	output2 db " tem ", 0
	output3 db " elementos", 0
	seed	dq 3	; seed inicial

SECTION .bss
	class resd NN ; vetor com a frequencia de cada classe

SECTION .text
global main
main:

	mov ebx, seed ; coloca a seed no base
	mov edx, 0		; zera a extensão do acumulador
	do:
		; fibonacci lsfr
		mov ecx, ebx  ; vetor com a frequencia de cada classe
		mov eax, ebx  ; coloca a seed no acumulador
		shr ecx, 2    ; shifta o valor de ecx em 2 bits
		xor eax, ecx	; aplica o xor entre o acumulador e o contador de objetos
		shr ecx, 1		;	shifta o acumulador
		xor eax, ecx	; aplica novamente xor entre o acumulador e o contador de objetos 
		shr ecx, 2
		xor eax, ecx
		shr ecx, 3
		xor eax, ecx
		shr ecx, 5    ; Fibonacci ...
		xor eax, ecx
		shr ecx, 8
		xor eax, ecx
		and eax, 1    ; realiza uma operação de and com o acumulador

		shl eax, 23
		shr ebx, 1
		or eax, ebx
		mov ebx, eax

		and eax, 0x00FFFFFF   ; 24 bits

		; Calculando o intervalo do número
		and eax, 0x0FFF

		; incrementa um no intervalo (vetor de frequencias)
		add dword [class + eax*4], 1

		inc edx
		cmp edx, 40960
	jne do

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