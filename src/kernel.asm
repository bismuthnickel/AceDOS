; KERNEL
; 3/2/25 Notoriginal

org 0x7e00
bits 16

_kernel:
    mov ax, 0
    mov bl, "E"
    call _asi
    mov ax, 1
    mov bl, 0x1b
    mov ch, 0
    mov cl, 1
    call _asi
    mov ax, 3
    call _asi
    mov bl, al
    mov ax, 0
    call _asi
.exit:
    ret

%include "src/asi.asm"

times (512*4)-($-$$) db 0