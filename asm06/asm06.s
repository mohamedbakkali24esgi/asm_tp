section .bss
buffer resb 20

section .text
global _start

_start:
    mov rsi, [rsp+16]
    mov rax, 0
atoi1:
    mov cl, [rsi]
    cmp cl, 0
    je done1
    sub cl, 48
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp atoi1
done1:
    mov rbx, rax

    mov rsi, [rsp+24]
    mov rax, 0
atoi2:
    mov cl, [rsi]
    cmp cl, 0
    je done2
    sub cl, 48
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp atoi2
done2:
    add rax, rbx

    mov rdi, buffer
    add rdi, 19
    mov byte [rdi], 10
    dec rdi
    mov rcx, 10
itoa:
    mov rdx, 0
    div rcx
    add dl, 48
    mov [rdi], dl
    dec rdi
    cmp rax, 0
    jne itoa

    inc rdi
    mov rsi, rdi
    mov rax, buffer
    add rax, 20
    sub rax, rdi
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
