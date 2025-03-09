bits 16

db 0x89

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

lea si, [bp+message]
mov bh, 0x0c
mov ax, 21
int 0x80
lea si, [bp+message]
mov bh, 0x0e
mov ax, 21
int 0x80
lea si, [bp+message]
mov bh, 0x0a
mov ax, 21
int 0x80
lea si, [bp+message]
mov bh, 0x0b
mov ax, 21
int 0x80
lea si, [bp+message]
mov bh, 0x0d
mov ax, 21
int 0x80
ret

message: db "SIGMA RIZZ is sooo hot", 0x0d, 0

times (512*15)-($-$$) db 0

METADATATABLE:
.name:
    db "SIGMA RIZZ" ; up to 15 bytes of characters
    times (.name + 15)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
.description:
    db "A program with very great graphics. DO NOT WATCH UNLESS ALONE" ; up to 255 bytes of characters
    times (.description + 255)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
.date:
    db "03/08/2025" ; up to 10 bytes of characters
    times (.date + 10)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
