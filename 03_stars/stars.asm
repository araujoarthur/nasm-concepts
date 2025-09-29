section .text

    global _start

_start:
    mov edx,len
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    syscall

    mov edx, 9
    mov ecx, s2
    mov ebx, 1 ; really needed? isnt ebx already holding 1?
    mov eax, 4
    syscall

    mov edx, 1
    mov ecx, nl
    mov ebx, 1
    mov eax, 4
    syscall

    mov eax, 1
    syscall

section .data

msg db 'Displaying 9 Stars', 0xa
len equ $ - msg

s2 times 9 db '*' ; s2 is the label, times 9 is an assembler directive that tells the assembler to repeat it 9 times, db stores the character * (and because of times 9, stores it 9 times)

nl db 0xa