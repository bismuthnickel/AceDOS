org 0x7e00
bits 32

_start:
    call _debug
    mov eax, 4 ; _setcursor
    mov esi, (80*5)
    call functions
.loop:
    mov eax, 1 ; _keypress
    call functions
    mov esi, eax
    mov eax, 3 ; _printc
    mov edi, 0x0b
    call functions
    jmp .loop
    ret

_debug:
    push eax
    push ecx
    push esi
    push edi
    mov ecx, 256
    mov esi, 0
.loop:
    mov eax, 3 ; _printc
    inc esi
    mov edi, 0x07
    call functions
    loop .loop
    pop edi
    pop esi
    pop ecx
    pop eax
    ret

gah: db "gah!", 0

times (512*2)-($-$$) db 0

functions equ 0x8200