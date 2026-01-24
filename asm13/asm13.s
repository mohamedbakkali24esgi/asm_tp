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

    mov rcx, 0
    mov rdx, r8

loop:
    cmp rcx, rdx
    jge yes

    mov al, [buffer+rcx]
    mov bl, [buffer+rdx]
    cmp al, bl
    jne no

    inc rcx
    dec rdx
    jmp loop

yes:
    mov rax, 60
    mov rdi, 0
    syscall

no:
    mov rax, 60
    mov rdi, 1
    syscall
