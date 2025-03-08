bits 16

db 0x88

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

lea si, [bp + m1]
mov bh, 0x07
mov ax, 21
int 0x80
mov ax, 3
int 0x80
cmp al, "6"
je correct
lea si, [bp + m2]
mov bh, 0x0c
mov ax, 21
int 0x80
ret
correct:
lea si, [bp + m3]
mov bh, 0x0a
mov ax, 21
int 0x80
ret

m1: db "What's 3*2?", 0x0d, 0
m2: db "wrong", 0x0d, 0
m3: db "correct", 0x0d, 0
