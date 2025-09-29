section .data
    prompt              db      "Type up to 15 characters: "
    promptLen           equ     $ - prompt
    nl                  db      0xA
    outputPrompt        db      "The characteres were: "
    outputPromptLen     equ     $ - outputPrompt


section .text
    global _start

_start:
    ; buf = mmap(NULL, 16, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) - more info on man mmap
    ; Linux x86-64 syscall args: rdi, rsi, rdx, r10, r8, r9; rax = number of the system call
    mov rax, 9 ; SYS_mmap
    xor rdi, rdi ; addr = NULL
    mov rsi, 16 ; length

    ; setting up the protection flags (equivalent to 'mov rdx, 3')
    xor rdx, rdx
    mov rdx, 0x1
    or  rdx, 0x2
    
    ; Setup the mapping flags
    mov r10, 0x22 ; MAP_PRIVATE(0x02) | MAP_ANONYMOUS(0x20)
    
    mov r8, -1    ; Stores the file descriptor. It's is ignored with anonymous flag

    xor r9, r9  ; offset = 0
    syscall

    ; test for error
    test rax, rax
    js .mmap_fail

    mov r12, rax ; save the buffer address.

    ; (optional) zero first 9 bytes REP STOSB
    lea rdi, [r12] ; load effective address
    mov ecx, 9 ; count
    xor eax, eax ; zero the eax register, that holds the byte data that will be inserted via stosb
    rep stosb 

    ; write(1, prompt, promptLen)
    mov rax, 1
    mov rdi, 1 ; stdout
    mov rsi, prompt
    mov rdx, promptLen
    syscall

    ; nread = read(0, buf, 15)
    xor rax,rax ; same as mov rax, 0
    xor rdi, rdi ; fd stdin(0)
    mov rsi, r12 ; in this case, lea rsi, [r12] would work, but the effective address of r12 is just the value of r12, and as we are moving data between registers, the canonical instruction is mov. buf = heap buffer
    mov rdx, 15 ; count
    syscall
    mov rbx, rax ; saves the number of read bytes

    ; writes to output (write(1, outputPrompt, outputPromptLen)
    mov rax, 1
    mov rdi, 1
    mov rsi, outputPrompt
    mov rdx, outputPromptLen
    syscall

    ; writes the typed text if nread > 0 (because 0 inserted nothing, and less than zero is errorno)
    test rbx, rbx ; we saved read in rbx above...
    jle .after_echo
    mov rax, 1
    mov rdi, 1
    mov rsi, r12
    mov rdx, rbx
    syscall

    ; adds the trailing '\n' if last char wasn't '\n' and there was something typed.

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
    
    ;munmap(buf, 16) it's optional before exiting the program but it's just good practice.
    mov rax, 11 ; SYS_munmap
    mov rdi, r12 ; addr
    mov rsi, 16
    syscall

    ;exit
    mov rax, 60
    xor rdi,rdi
    syscall


.mmap_fail:
    mov rax, 60
    mov rdi, 1
    syscall