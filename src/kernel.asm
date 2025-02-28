org 0x7e00
bits 32

_start:
    mov eax, 2
    mov esi, 0xa4
    call api
    mov byte [0xb8000], "A"
    ret

gah: db "gah!", 0

times (512*2)-($-$$) db 0

api equ 0x8200