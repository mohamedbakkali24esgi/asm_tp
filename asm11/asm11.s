section .bss
input resb 256
output resb 20

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 255
    syscall
    mov r8, rax

    mov rcx, 0
    mov rbx, 0

loop:
    cmp rcx, r8
    jge print
    mov al, [input+rcx]
    cmp al, 10
    je print

    cmp al, 97
    je found
    cmp al, 101
    je found
    cmp al, 105
    je found
    cmp al, 111
    je found
    cmp al, 117
    je found
    cmp al, 65
    je found
    cmp al, 69
    je found
    cmp al, 73
    je found
    cmp al, 79
    je found
    cmp al, 85
    je found
    jmp next

found:
    inc rbx

next:
    inc rcx
    jmp loop

print:
    mov rax, rbx
    mov rdi, output
    add rdi, 19
    mov byte [rdi], 10
    dec rdi
    mov rcx, 10

    cmp rax, 0
    jne itoa
    mov byte [rdi], 48
    dec rdi
    jmp out

itoa:
    cmp rax, 0
    je out
    mov rdx, 0
    div rcx
    add dl, 48
    mov [rdi], dl
    dec rdi
    jmp itoa

out:
    inc rdi
    mov rsi, rdi
    mov rax, output
    add rax, 20
    sub rax, rdi
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
