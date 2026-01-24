section .text
global _start

_start:
    mov rsi, [rsp+16]
    mov rdx, 0

loop:
    cmp byte [rsi+rdx], 0
    je print
    inc rdx
    jmp loop

print:
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
