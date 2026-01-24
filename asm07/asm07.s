section .bss
buffer resb 20

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 20
    syscall

    mov rsi, buffer
    mov rax, 0
    mov rcx, 0
atoi:
    mov cl, [rsi]
    cmp cl, 10
    je done
    cmp cl, 0
    je done
    cmp cl, 48
    jl done
    cmp cl, 57
    jg done
    sub cl, 48
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp atoi
done:
    mov rbx, rax

    cmp rbx, 2
    jl notprime
    cmp rbx, 2
    je prime
    cmp rbx, 3
    je prime

    mov rax, rbx
    mov rdx, 0
    mov rcx, 2
    div rcx
    cmp rdx, 0
    je notprime

    mov rcx, 3
check:
    mov rax, rcx
    imul rax, rcx
    cmp rax, rbx
    jg prime

    mov rax, rbx
    mov rdx, 0
    push rcx
    div rcx
    pop rcx
    cmp rdx, 0
    je notprime

    add rcx, 2
    jmp check

prime:
    mov rax, 60
    mov rdi, 0
    syscall

notprime:
    mov rax, 60
    mov rdi, 1
    syscall
