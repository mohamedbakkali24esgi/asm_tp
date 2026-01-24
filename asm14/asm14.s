section .data
msg db "Hello Universe!", 10
len equ 16

section .text
global _start

_start:
    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 65
    mov rdx, 420
    syscall

    mov rbx, rax

    mov rax, 1
    mov rdi, rbx
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 3
    mov rdi, rbx
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
