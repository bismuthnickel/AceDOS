bits 16

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

main:
    mov ax, 3
    int 0x80
    mov bl, al
    mov bh, 0x07
    mov ax, 20
    int 0x80
    mov bl, 0x0d
    mov bh, 0x07
    mov ax, 20
    int 0x80
    ret

