section .data

    userMsg db 'Please enter a number: '
    lenUserMsg equ $ - userMsg
    dispMsg db 'You have entered: '
    lenDispMsg equ $ - dispMsg


section .bss
    ; The code below does not work because it tries to initialize data in .bss but bss is for uninitialized data ONLY. 
    ; it means the programmer gotta use the directive 'resb' or, alternatively, create the memory storage on the stack (example 05). Or on the heap (example 06)
    ;num db 0,0,0,0,0 ; reserves 5 bytes in .bss section with value 0h (0x0) (1 for signal, 4 usable; totaling 5 numeric bytes)
    num resb 5

section .text
    global _start

_start:

    ; Prompts the user:
    mov eax, 4 ; syscall sys_write(4)
    mov ebx, 1 ; file descriptor
    mov ecx, userMsg
    mov edx, lenUserMsg
    int 80h ; same as 0x80 (80h means 80 base _h_ex)

    ; Reads and stores the input:
    mov eax, 3 ; syscall sys_read
    mov ebx, 2 ; file descriptor (stdin)
    mov ecx, num ; pointer to memory (buffer) that will store the read data
    mov edx, 5 ; size of the buffer.
    int 80h

    ; Outputs the information
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, dispMsg
    mov edx, lenDispMsg
    int 0x80

    ; Outputs the typed number
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 5 ; 5 bytes
    int 80h

    ; Exit code
    mov eax, 1 ; Syscall sys_exit
    mov ebx, 0 ; exit code
    int 0x80
