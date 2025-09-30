
; Assembly directive equ does not need to be in a physical memory section representation
SYS_EXIT    equ     1
SYS_READ    equ     3
SYS_WRITE   equ     4
STDIN       equ     0
STDOUT      equ     1

section .data
    msg1 db "Enter a digit: ", 0xA, 0xD ; 0xA = new line; 0xD = carriage return
    len1 equ $ - msg1

    msg2 db "Please enter a second digit: ", 0xA, 0xD
    len2 equ $ - msg2

    msg3 db "The sum is: "
    len3 equ $ - msg3


segment .bss
    num1 resb 2
    num2 resb 2
    res resb 1


section .text
    global _start

_start:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 80h

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 2
    int 80h

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 80h

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2 ; why not lea [num2]
    mov edx, 2
    int 80h

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 80h

    
    ; Now to be able to sum...
    mov eax, [num1]
    sub eax, '0' ; remember, num1 is a character, so we subtract the ascii code representing the character 0 to get the digits code. Funny enough, it wouldnt work with multidigit number (i guess, didnt compile yet)

    mov ebx, [num2]
    sub ebx, '0'

    ; The actual sum
    add eax, ebx

    ; Gets the character code back
    add eax, '0'

    ; store to memory
    mov [res], eax

    ; finally prints
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 1
    int 80h


exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 80h