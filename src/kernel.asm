org 0xa000
bits 16

%define ASI [0x7da0]

_kernel:
    mov ax, 22
    mov cx, (80*6)
    call ASI

    mov ax, 21
    mov si, hello
    mov bh, 0x0c
    call ASI

    mov ax, 10
    mov si, disabled
    call ASI

    mov ax, 22
    mov cx, (80*7)
    call ASI

.loop:
    mov ax, 3
    call ASI
    mov bl, al
    mov bh, 0x07
    mov ax, 20
    call ASI
    jmp .loop

    jmp _halt

_halt:
    jmp $

hello: db "Hello from Kernel!", 0
disabled: db "Legacy functions have been disabled. If you see this, you done messed something up.", 0

times (512*8)-($-$$) db 0