bits 16

db 0x89

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

mov si, [0x7db0] ; _asi.legacy
mov byte [si], 1 ; enable the funi
; below are legacy functions
mov ax, 5
int 0x80
mov ax, 2
mov bx, 0
int 0x80
mov ax, 10
lea si, [bp+disabled]
int 0x80
mov cx, 3
yes:
mov ax, 20
mov bl, 0x0d
int 0x80
loop yes
ret

disabled: db "Legacy functions have been disabled. If you see this, you done messed something up.", 0

times (512*15)-($-$$) db 0

METADATATABLE:
.name:
    db "LEGACYSWITCH" ; up to 15 bytes of characters
    times (.name+15)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
.description:
    db "Unlock your AceDOS! This simple program sets the legacy flag again so you can use the old and unimproved interrupts!" ; up to 255 bytes of characters
    times (.description + 255)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
.date:
    db "03/11/2025" ; up to 10 bytes of characters
    times (.date + 10)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
