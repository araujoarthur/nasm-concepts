section .data

    prompt          db "Type up to 15 characters: "
    promptLen       equ $ - prompt
    nl              db 0xA
    outputPrompt    db "The characters were: " 
    outputPromptLen equ $ - outputPrompt


section .text

    global _start ; declaration of the start label only

_start:
    ; Here we are subtracting 16 bytes from the stack pointer (and the result is stored in the stack pointer as sub subtracts in place from the left operator)
    sub rsp, 16 ; Reserves 16 bytes. Remember 16 here is decimal as there is no further indications. Could be 0x10 (because the sequence 10 in base b is always = b in decimal)

    ; RDI = dest, RCX = count, AL = byte -> REP STOSB fills memory
    lea rdi, [rsp] ; lea is the instruction load effective address (intel AIO manual page 1193 as of June's 2025 version). Loads the address of the value in the RSP address (thus [rsp] and not just rsp)
    ; the above line is the same as lea rdi, rsp because 'lea' does not dereference the memory operand. it just takes the address of RSP (taking the effective address)
    ; as the effective address is the result of a computation of [base + index * scale + displacement], and there's no such computation in the line above, it just takes the effective address of rsp.
    ; Then the destination index register (rdi) holds the address of the buffer.

    mov ecx, 9 ; the count of bytes to store
    mov al, 0 ; the byte to be stored is moved into AL
    rep stosb ; rep = repeat string instruction (p. 1783, June 2025 version), stosb = store string (p. 1896, June 2025 version) -- effectively stores all 0 in the buffer (could be done using xor. but how?)
    
    ; write(fd=stdout(1), prompt, promptLen)
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout to RDI, not to rbx(as it is expected in x86 to be in ebx. Here x64 uses destination index register)
    mov rsi, prompt ; sys_write in linux x64 expects the starting address in RSI not RCX (as it does expect to be in ECX in x86)
    mov rdx, promptLen
    syscall

    ; nread = read(fd=stdin(0), buffer, len)
    mov rax, 0 ; sys_read
    lea rsi, [rsp] ; 
    xor rdi, rdi ; same as mov rdi, 0 -> but it is encoded way smaller (mov r64, imm64 encodes a full 64-bit immediate, even if it’s just 0; 48 BF 00 00 00 00 00 00 00 00; With xor it's 48 31 FF)
    ; in Linux x64, the destination is expected to be in rdi, not rbx (as it is expected to be in ebx in x86)
    mov rdx, 15 ; leave room for up to 15 characters. (the third argument is rdx)
    syscall ; from here, RAX stores -errno or, in case of success, the amount of bytes read.

    mov rbx, rax ; stores the len;

    ; write(fd=stdout(1), outputPrompt, outputPromptLen)
    mov rax, 1
    mov rdi, 1 ; stdout
    mov rsi, outputPrompt
    mov rdx, outputPromptLen
    syscall

    ; write (fd=stdout(1), buf, nread) - if nread > 0
    test rbx, rbx ; test if nread > 0
    jle .finish_echo; jumps if less or equal (SF != 0 and ZF = 1);
    mov rax, 1 ; syscall sys_write
    mov rdi, 1 ; stdout
    lea rsi, [rsp]
    mov rdx, rbx ; moves the length (that we stored on rbx above) 
    syscall

    ; ensure the existence of a trailing slash after the text IF last character wasn't '\n'
    mov rcx, rbx ; moves the len of input data to the count register
    dec rcx ; decrements it by 1
    js .finish_echo ; jump short if sign (SF = 1) (if the len was 0, then signal flag is set after a decrement)
    mov al, [rsp + rcx]
    cmp al, 0x0A
    je .finish_echo ; jump if equal

    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, nl ; newline character
    mov rdx, 1 ; count
    syscall


.finish_echo:
    add rsp, 16 ; "frees" the buffer on the stack.

    ; exiting
    mov rax, 60
    xor rdi, rdi ; exit code
    syscall
