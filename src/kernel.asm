org 0x7e00
bits 32

_start:
.loop:
    mov eax, 1
    call functions
    jc .loop
    mov esi, eax
    mov eax, 5
    call functions
    cmp eax, 0x0a
    je .nextline
    mov edi, [pointer]
    mov [edi], al
    inc edi
    mov byte [edi], 0x0a
    inc edi
    mov byte [edi], 0
    inc dword [pointer]
    mov esi, eax
    mov eax, 3
    mov edi, 0x07
    call functions
    jmp .loop
.nextline:
    mov dword [pointer], buffer.main
    mov eax, 0
    mov esi, buffer
    mov edi, 0x1b
    call functions
    jmp .loop
    ret

buffer:
.paddingfront: db 0x0a
.main: times 256 db 0
pointer: dd buffer.main

times (512*2)-($-$$) db 0

functions equ 0x8200