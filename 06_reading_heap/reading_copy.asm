section .data
    prompt              db      "Type up to 15 characters: "
    promptLen           equ     $ - prompt
    nl                  db      0xA
    outputPrompt        db      "The characteres were: "
    outputPromptLen     equ     $ - outputPrompt


section .text
    global _start

_start:
    mov rax, 9
    xor rdi, rdi
    mov rsi, 16
    xor rdx, rdx
    mov rdx, 0x1
    or  rdx, 0x2
    mov r10, 0x22
    mov r8, -1
    xor r9, r9
    syscall

    test rax, rax
    js .mmap_fail

    mov r12, rax

    lea rdi, [r12]
    mov ecx, 9
    xor eax, eax
    rep stosb 

    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    xor rax,rax
    xor rdi, rdi
    mov rsi, r12
    mov rdx, 15
    syscall
    mov rbx, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, outputPrompt
    mov rdx, outputPromptLen
    syscall

    test rbx, rbx
    jle .after_echo
    mov rax, 1
    mov rdi, 1
    mov rsi, r12
    mov rdx, rbx
    syscall

    mov rcx, rbx
    dec rcx
    js .after_echo
    mov al, [r12 + rcx]
    cmp al, 0xA
    je .after_echo
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall


.after_echo:
    mov rax, 11
    mov rdi, r12
    mov rsi, 16
    syscall

    mov rax, 60
    xor rdi,rdi
    syscall


.mmap_fail:
    mov rax, 60
    mov rdi, 1
    syscall
