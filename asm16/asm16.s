section .data
    search      db  0x31, 0x33, 0x33, 0x37, 0x0A
    search_len  equ $ - search
    replace     db  0x48, 0x34, 0x43, 0x4B
    err_msg     db  "Error", 10
    err_len     equ $ - err_msg

section .bss
    fd          resq 1
    fsize       resq 1
    mapaddr     resq 1

section .text
global _start

_start:
    mov rbx, rsp
    mov rcx, [rbx]
    cmp rcx, 2
    jl fail

    mov rdi, [rbx+16]
    mov eax, 2
    mov esi, 2
    xor edx, edx
    syscall
    test eax, eax
    js fail
    mov [fd], eax

    mov eax, 8
    mov edi, [fd]
    xor esi, esi
    mov edx, 2
    syscall
    test eax, eax
    js cleanup
    mov [fsize], eax

    cmp rax, search_len
    jl cleanup

    mov eax, 9
    xor edi, edi
    mov rsi, [fsize]
    mov edx, 3
    mov r10d, 1
    mov r8, [fd]
    xor r9d, r9d
    syscall
    cmp eax, -1
    je cleanup
    mov [mapaddr], rax

    mov rdi, rax
    mov rcx, [fsize]
    sub rcx, search_len
    jl unmap

scan:
    mov rsi, search
    mov rdx, search_len
    push rdi
    repe cmpsb
    pop rdi
    je replace_here
    inc rdi
    loop scan
    jmp unmap

replace_here:
    mov rsi, replace
    mov rcx, 4
    rep movsb

unmap:
    mov eax, 11
    mov rdi, [mapaddr]
    mov rsi, [fsize]
    syscall

cleanup:
    mov eax, 3
    mov rdi, [fd]
    syscall

    mov eax, 60
    xor edi, edi
    syscall

fail:
    mov eax, 1
    mov edi, 1
    mov rsi, err_msg
    mov edx, err_len
    syscall

    mov eax, 60
    mov edi, 1
    syscall
