global _start

section .data
    send_msg    db "Hello, client!", 10
    send_len    equ $ - send_msg

    timeout_msg db "Timeout: no response from server", 10
    timeout_len equ $ - timeout_msg

    prefix      db 'message: "'
    prefix_len  equ $ - prefix
    suffix      db '"', 10
    suffix_len  equ $ - suffix

    addr:
        dw 2
        dw 0x901f
        dd 0x0100007f
        dq 0

section .bss
    s       resq 1
    buffer  resb 512
    pollfd  resb 8

section .text
_start:
    mov eax, 41
    mov edi, 2
    mov esi, 2
    xor edx, edx
    syscall
    test eax, eax
    js fail
    mov [s], rax

    mov eax, 44
    mov rdi, [s]
    lea rsi, [rel send_msg]
    mov edx, send_len
    xor r10d, r10d
    lea r8, [rel addr]
    mov r9d, 16
    syscall

    mov eax, [s]
    mov dword [pollfd], eax
    mov word  [pollfd+4], 1
    mov word  [pollfd+6], 0

    mov eax, 7
    lea rdi, [rel pollfd]
    mov esi, 1
    mov edx, 5000
    syscall
    test eax, eax
    jle timed_out

    test word [pollfd+6], 1
    jz timed_out

    mov eax, 45
    mov rdi, [s]
    lea rsi, [rel buffer]
    mov edx, 512
    xor r10d, r10d
    xor r8d, r8d
    xor r9d, r9d
    syscall
    test eax, eax
    jle timed_out
    mov r14, rax

    mov eax, 1
    mov edi, 1
    lea rsi, [rel prefix]
    mov edx, prefix_len
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [rel buffer]
    mov rdx, r14
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [rel suffix]
    mov edx, suffix_len
    syscall

    jmp done

timed_out:
    mov eax, 1
    mov edi, 1
    lea rsi, [rel timeout_msg]
    mov edx, timeout_len
    syscall

done:
    mov eax, 60
    xor edi, edi
    syscall

fail:
    mov eax, 60
    mov edi, 1
    syscall
