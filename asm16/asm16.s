global _start

section .data
    search      db "1337"
    search_len  equ $ - search
    replace     db "H4CK"
    err_msg     db "Error", 10
    err_len     equ $ - err_msg

section .bss
    fd      resq 1
    fsize   resq 1
    mapaddr resq 1
    off     resq 1

section .text
_start:
    cmp qword [rsp], 2
    jne fail

    mov rdi, [rsp+16]
    mov eax, 2
    mov esi, 2
    xor edx, edx
    syscall
    test eax, eax
    js fail
    mov [fd], rax

    mov eax, 8
    mov rdi, [fd]
    xor esi, esi
    mov edx, 2
    syscall
    test rax, rax
    js cleanup_fail
    mov [fsize], rax

    cmp rax, search_len
    jb cleanup_fail

    mov eax, 9
    xor edi, edi
    mov rsi, [fsize]
    mov edx, 3
    mov r10d, 1
    mov r8, [fd]
    xor r9d, r9d
    syscall
    test rax, rax
    js cleanup_fail
    mov [mapaddr], rax

    xor rbx, rbx
    mov rcx, [fsize]
    sub rcx, search_len

scan:
    cmp rbx, rcx
    ja  unmap_fail

    mov rdi, [mapaddr]
    add rdi, rbx

    mov al, [rdi]
    cmp al, byte [rel search]
    jne next
    mov al, [rdi+1]
    cmp al, byte [rel search+1]
    jne next
    mov al, [rdi+2]
    cmp al, byte [rel search+2]
    jne next
    mov al, [rdi+3]
    cmp al, byte [rel search+3]
    jne next

    mov al, byte [rel replace]
    mov [rdi], al
    mov al, byte [rel replace+1]
    mov [rdi+1], al
    mov al, byte [rel replace+2]
    mov [rdi+2], al
    mov al, byte [rel replace+3]
    mov [rdi+3], al
    jmp success

next:
    inc rbx
    jmp scan

success:
    mov eax, 11
    mov rdi, [mapaddr]
    mov rsi, [fsize]
    syscall

    mov eax, 3
    mov rdi, [fd]
    syscall

    mov eax, 60
    xor edi, edi
    syscall

unmap_fail:
    mov eax, 11
    mov rdi, [mapaddr]
    mov rsi, [fsize]
    syscall

cleanup_fail:
    mov eax, 3
    mov rdi, [fd]
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
