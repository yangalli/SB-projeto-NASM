%include "asm_io.inc"

;----------------------------------------------------------------------
; Switch - Case - Default - EndSwitch
; Usage:
;
;   SWITCH expression
;     CASE argument1
;       statements 
;				BREAK
;     CASE argumentN
;       statements 
;     DEFAULT 
;       statements
;   ENDSWITCH
;
; nasm -f elf switch.asm
;----------------------------------------------------------------------

%macro SWITCH 1
	%push SWITCH                    ; Push context
	%assign %$case 1                ; Assign 1 to the nextcase index
	mov eax, dword %1               ; Store argument
%endmacro

%macro CASE 1
	%ifctx SWITCH
	    %$next%$case:
            %assign %$case %$case+1     ; Increment nextcase index value
    		cmp eax, %1
            jne %$next%$case            ; Jump to next case if not equal
    %else
        %error "CASE is not allowed outside a SWITCH block."
	%endif
	
%endmacro

%macro DEFAULT 0
  %ifctx SWITCH                 ; Verify context
    %$next%$case:
  %else 
    %error "DEFAULT is not allowed outside a SWITCH block."
  %endif 
%endmacro

%macro BREAK 0
  %ifctx SWITCH                 ; Verify context
    jmp %$endswitch
  %else 
    %error "DEFAULT is not allowed outside a SWITCH block."
  %endif 
%endmacro

%macro ENDSWITCH 0
	%ifctx SWITCH
		%$endswitch:
	  	  %pop SWITCH             ; Remove context from context stack
    %else
        %error "ENDSWITCH is not allowed outside a SWITCH block."
	%endif
	
%endmacro

segment .data
; mensagens para ilustrar cada caso
caso1_msg 		db "CASO 1", 0xa, 0
caso2_msg 		db "CASO 2", 0xa, 0
caso3_msg 		db "CASO 3", 0xa, 0
deflt_msg 		db "DEFAULT", 0xa, 0

msg_teste1 		db "Caso esperado: CASO 1", 0xa, 0
msg_teste2 		db "Caso esperado: CASO 2", 0xa, 0
msg_teste3 		db "Caso esperado: CASO 3", 0xa, 0
msg_teste4 		db "Caso esperado: DEFAULT", 0xa, 0

; valores que determinarão qual caso terá sua condição satisfeita
valor1	equ 100
valor2	equ 111
valor3	equ 101
valor0	equ 000

v_caso1	equ 100
v_caso2	equ 111
v_caso3	equ 101

segment .text
        global  Switch

Switch:
    enter	0,0               ; setup routine
	pusha

    mov eax, msg_teste1
	call print_string

    SWITCH valor1
	CASE v_caso1
		mov eax, caso1_msg
		call print_string
		BREAK
	CASE v_caso2
		mov eax, caso2_msg
		call print_string
		BREAK
	CASE v_caso3
		mov eax, caso3_msg
		call print_string
		BREAK
	DEFAULT
		mov eax, deflt_msg
		call print_string
		BREAK
	ENDSWITCH

    	SWITCH valor2
	CASE v_caso1
		mov eax, caso1_msg
		call print_string
		BREAK
	CASE v_caso2
		mov eax, caso2_msg
		call print_string
		BREAK
	CASE v_caso3
		mov eax, caso3_msg
		call print_string
		BREAK
	DEFAULT
		mov eax, deflt_msg
		call print_string
		BREAK
	ENDSWITCH

	mov eax, msg_teste3
	call print_string

	SWITCH valor3
	CASE v_caso1
		mov eax, caso1_msg
		call print_string
		BREAK
	CASE v_caso2
		mov eax, caso2_msg
		call print_string
		BREAK
	CASE v_caso3
		mov eax, caso3_msg
		call print_string
		BREAK
	DEFAULT
		mov eax, deflt_msg
		call print_string
		BREAK
	ENDSWITCH

	mov eax, msg_teste4
	call print_string

	SWITCH valor0
	CASE v_caso1
		mov eax, caso1_msg
		call print_string
		BREAK
	CASE v_caso2
		mov eax, caso2_msg
		call print_string
		BREAK
	CASE v_caso3
		mov eax, caso3_msg
		call print_string
		BREAK
	DEFAULT
		mov eax, deflt_msg
		call print_string
		BREAK
	ENDSWITCH

    popa
    mov	eax, 0
    leave
    ret