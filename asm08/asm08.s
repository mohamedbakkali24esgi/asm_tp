section .bss
buffer resb 20

section .text
global _start

_start:
    mov rsi, [rsp+16]
    mov rax, 0
atoi:
    mov cl, [rsi]
    cmp cl, 0
    je done
    sub cl, 48
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp atoi
done:
    mov rbx, rax
    dec rbx
    mov rax, 0

sum:
    cmp rbx, 0
    je print
    add rax, rbx
    dec rbx
    jmp sum

print:
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
