global _start

section .text
_start:
    cmp qword [rsp], 2
    jl not_elf

    mov rsi, [rsp+16]

    mov eax, 257
    mov edi, -100
    xor edx, edx
    xor r10d, r10d
    syscall
    test eax, eax
    js not_elf
    mov r12d, eax

    xor eax, eax
    mov edi, r12d
    lea rsi, [rel hdr]
    mov edx, 8
    syscall
    cmp eax, 5
    jl close_and_fail

    mov eax, 3
    mov edi, r12d
    syscall

    cmp dword [rel hdr], 0x464C457F
    jne not_elf

    cmp byte [rel hdr+4], 2
    jne not_elf

    mov eax, 60
    xor edi, edi
    syscall

close_and_fail:
    mov eax, 3
    mov edi, r12d
    syscall

not_elf:
    mov eax, 60
    mov edi, 1
    syscall

section .bss
hdr resb 8
