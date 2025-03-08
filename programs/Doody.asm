bits 16

db 0x88

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

mov cx, 50
looped:
mov ax, 21
lea si, [bp+message]
mov bh, cl
and bh, 0x0f
int 0x80
loop looped
lea si, [bp+end]
mov ax, 21
mov bh, 0x00
int 0x80
ret

message: db "doodoo cheeks ", 0
end: db 0x0d, 0
