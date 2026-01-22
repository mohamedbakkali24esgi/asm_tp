section .data
    msg db "1337",10
    len equ $-msg

section .bss
    buf resb 3

section .text
global _start
_start:
    xor eax, eax       
    xor edi, edi       
    lea rsi, [rel buf]
    mov edx, 3
    syscall

    cmp byte [buf], '4'
    jne bad
    cmp byte [buf+1], '2'
    jne bad
    cmp byte [buf+2], 10
    jne bad

    mov eax, 1
    mov edi, 1
    lea rsi, [rel msg]
    mov edx, len
    syscall
    mov eax, 60
    xor edi, edi
    syscall

bad:
    mov eax, 60
    mov edi, 1
    syscall
