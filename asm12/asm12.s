section .bss
buffer resb 256

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 255
    syscall
    mov r8, rax

    dec r8
    cmp byte [buffer+r8], 10
    jne nofix
    dec r8
nofix:

    mov rcx, r8

loop:
    cmp rcx, 0
    jl done
    mov rax, 1
    mov rdi, 1
    lea rsi, [buffer+rcx]
    mov rdx, 1
    push rcx
    syscall
    pop rcx
    dec rcx
    jmp loop

done:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    add rsi, r8
    inc rsi
    mov byte [rsi], 10
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
