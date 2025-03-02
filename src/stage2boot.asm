; STAGE2BOOT
; 3/2/25 Notoriginal

org 0x7e00
bits 16

_entry:
    mov [drive], dl
    mov ax, 8
    mov bl, 0x02
    call _asi
    mov ax, 10
    mov si, messages.detecting
    call _asi
    clc
    int 0x12
    jc .error
    mov dx, ax
    mov ax, 10
    mov si, messages.done
    call _asi
    mov si, messages.p0x
    call _asi
    mov ax, 4
    mov bl, dh
    call _asi
    mov bl, dl
    call _asi
    mov ax, 10
    mov si, messages.kilobytes
    call _asi

    mov byte [_asi.legacy], 0

    mov ax, 22
    mov cx, (80*5)
    call _asi

    mov word [0x7da0], _asi

    mov ax, 21
    mov si, messages.a
    mov bh, 0x0a
    call _asi

    mov ah, 0x02
    mov al, 8
    mov ch, 0
    mov cl, 6
    mov dh, 0
    mov dl, [drive]
    mov bx, 0xa000
    int 0x13

    jmp 0xa000

    jmp $

.error:
    mov ax, 10
    mov si, messages.error
    call _asi
    jmp $

%include "src/asi.asm"

messages:
.p0x: db "0x", 0
.detecting: db "AceDOS is detecting memory...", 0x0d, 0x0a, 0
.done: db "Done!", 0x0d, 0x0a, 0x07, 0
.error: db "Error!", 0x0d, 0x0a, 0
.kilobytes: db " kilobytes", 0x0d, 0x0a, 0
.a: db "Entering kernel", 0

drive: db 0

times (512*4)-($-$$) db 0