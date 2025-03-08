bits 16

db 0x88

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

mov ah, 0x1a
mov al, "A"
mov word [fs:0], ax
ret