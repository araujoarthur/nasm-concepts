section .text
    global _start

_start:

    ; Writes the name
    mov edx, 9
    mov ecx, name
    mov ebx, 1
    mov eax, 4
    int 80h

    ; replaces the first 4 bytes
    mov [name], dword 'Nuha'

    ; writes again
    mov edx, 8 ; 1 byte less so it dont print the last space
    mov ecx, name
    mov ebx, 1
    mov eax, 4
    int 80h

    mov eax, 1
    int 80h

section .data

name db 'Zara Ali '

