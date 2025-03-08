bits 16

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

mov ax, 21
lea si, [bp+message]
mov bh, 0x7e
int 0x80
ret

message: db "i love my mom", 0x0d, 0
