section .text
    global _start ; deve ser declarado por exigência do linker (ld)

_start:
    mov edx, len ; move o tamanho da mensagem para o registro EDX.
    mov ecx, msg ; move o ponteiro da string para ECX.
    mov ebx, 1   ; move o id do file descriptor no qual será escrito (nesse caso, stdout) (estou correto??) para EBX.
    mov eax, 4   ; move o id da system call 'sys_write' (estou correto??) para EAX.
    int 0x80     ; INT causa um interrupt no programa com vetor 0x80, que indica entry point de uma system call, que deve estar específicada em EAX.

    mov eax, 1   ; move o id da system call 'sys_exit' para EAX.
    int 0x80     ; Interrupt que chama o Kernel e Realiza a saida do programa através da execução da system call 'sys_exit', informada em EAX.


section .data

msg db 'Hello, World!', 0xA ; string to be printed. The syntax is: label(msg) mnemonic(define bytes, db| diretiva do assembler, reserva o espaço na memoria para o valor a seguir) VALUE
; O valor, no caso, é 'Hello, World!\n' onde o '\n' é o 0xA (10 decimal, codigo do linefeed). As virgulas com hex podem ser adicionadas infinitamente. O assembler determina o tamanho.

len equ $ - msg  
; aqui novamente: label(len) equ(diretiva do assembler, equate, define que um nome vale uma expressão fixa no momento do assembling, $ representa o endereço atual
; no momento dessa linha, $ é diretamente ao final da string.
; $ - msg é a subtração do endereço inicial (msg) da string do endereço final (que é o atual no momento, $), resultando no comprimento.

