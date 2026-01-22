section .data
    buf db "1337"

section .text
global _start
_start:

   
    mov rax, 1          
    mov rdi, 1          
    mov rsi, buf
    mov rdx, 4
    syscall
    mov rax, 60     
    mov rdi, 0     
    syscall
