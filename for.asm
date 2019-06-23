    global  _start
    section   .text

%macro write_string 2 
    mov   eax, 4
    mov   ebx, 1
    mov   ecx, %1
    mov   edx, %2
    int   80h
%endmacro

%macro for 1
    mov edi, 1
    ;mov ecx, %1
    innerLoop:

        write_string loopmessage, 15
        ;loop innerLoop
        add edi, 1
        cmp edi, %1
        jne innerLoop
    done:
        mov       rax, 1                  ; system call for write
        mov       rdi, 1                  ; file handle 1 is stdout
        mov       rsi, message            ; address of string to output
        mov       rdx, 9                 ; number of bytes
        syscall                           ; invoke operating system to do the write
        mov       rax, 60                 ; system call for exit
        xor       rdi, rdi                ; exit code 0
        syscall                           ; invoke operating system to exit


%endmacro

_start: for 0x8

          section   .data
message:  db        "Cafebabe", 10      ; note the newline at the end
loopmessage:  db        "Hello, Ladeira", 10      ; note the newline at the end