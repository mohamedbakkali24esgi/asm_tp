section .data
    msg db "1337",10
    len equ $-msg

section .text
global _start

_start:
    cmp qword [rsp], 2
    jne bad

    mov rsi, [rsp+16]

    cmp byte [rsi], '4'
    jne bad
    cmp byte [rsi+1], '2'
    jne bad
    cmp byte [rsi+2], 0
    jne bad

    mov eax, 1
    mov edi, 1
    mov rsi, msg
    mov edx, len
    syscall

    mov eax, 60
    xor edi, edi
    syscall

bad:
    mov eax, 60
    mov edi, 1
    syscall
