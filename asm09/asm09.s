section .data
hex db "0123456789ABCDEF"

section .bss
buffer resb 64

section .text
global _start

_start:
    mov rsi, [rsp+16]
    mov rbx, 16

    cmp byte [rsi], 45
    jne getnum
    cmp byte [rsi+1], 98
    jne getnum
    mov rbx, 2
    mov rsi, [rsp+24]

getnum:
    mov rax, 0
atoi:
    mov cl, [rsi]
    cmp cl, 0
    je convert
    sub cl, 48
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp atoi

convert:
    mov rdi, buffer
    add rdi, 63
    mov byte [rdi], 10
    dec rdi

    cmp rax, 0
    jne loop
    mov byte [rdi], 48
    dec rdi
    jmp print

loop:
    cmp rax, 0
    je print
    mov rdx, 0
    div rbx
    mov cl, [hex+rdx]
    mov [rdi], cl
    dec rdi
    jmp loop

print:
    inc rdi
    mov rsi, rdi
    mov rax, buffer
    add rax, 64
    sub rax, rdi
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
