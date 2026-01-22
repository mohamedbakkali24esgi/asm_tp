section .bss
    buf resb 4

section .text
global _start

_start:
    xor eax, eax
    xor edi, edi
    mov rsi, buf
    mov edx, 4
    syscall

    mov al, [buf]
    sub al, '0'
    test al, 1
    jnz odd

    mov eax, 60
    xor edi, edi
    syscall

odd:
    mov eax, 60
    mov edi, 1
    syscall
