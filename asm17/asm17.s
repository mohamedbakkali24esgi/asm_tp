global _start

section .bss
buf resb 4096

section .text
_start:
    mov rcx, [rsp]
    cmp rcx, 2
    jl  exit_ok

    mov rdi, [rsp+16]
    call atoi

    xor edx, edx
    mov ecx, 26
    div ecx
    mov r12d, edx

    xor eax, eax
    xor edi, edi
    lea rsi, [rel buf]
    mov edx, 4096
    syscall
    test rax, rax
    jle exit_ok
    mov r13, rax

    lea rdi, [rel buf]
    mov rsi, r13

scan:
    test rsi, rsi
    jz out

    mov al, [rdi]

    cmp al, 'a'
    jb  upper
    cmp al, 'z'
    ja  upper

    movzx eax, al
    sub eax, 'a'
    add eax, r12d
    xor edx, edx
    mov ecx, 26
    div ecx
    mov eax, edx
    add al, 'a'
    mov [rdi], al
    jmp step

upper:
    cmp al, 'A'
    jb  step
    cmp al, 'Z'
    ja  step

    movzx eax, al
    sub eax, 'A'
    add eax, r12d
    xor edx, edx
    mov ecx, 26
    div ecx
    mov eax, edx
    add al, 'A'
    mov [rdi], al

step:
    inc rdi
    dec rsi
    jmp scan

out:
    mov eax, 1
    mov edi, 1
    lea rsi, [rel buf]
    mov rdx, r13
    syscall

exit_ok:
    mov eax, 60
    xor edi, edi
    syscall

atoi:
    xor eax, eax
.next:
    movzx ecx, byte [rdi]
    test cl, cl
    jz .done
    sub cl, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rdi
    jmp .next
.done:
    ret
