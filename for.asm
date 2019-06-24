    global  For
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
        mov   eax, 4
        mov   ebx, 1
        mov   ecx, message
        mov   edx, 9
        int   80h
        ; finaliza o programa
        mov eax,1                ;system call number (sys_exit)
        int 0x80                 ;call kernel                         ; invoke operating system to exit


%endmacro

For: for 0x8

          section   .data
message:  db        "Cafebabe", 10      ; note the newline at the end
loopmessage:  db        "Hello, Ladeira", 10      ; note the newline at the end