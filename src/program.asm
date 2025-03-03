bits 16

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

main:
    mov ax, 21
    lea si, [bp + helloworld]
    mov bh, 0x07
    int 0x80
    mov ax, 21
    lea si, [bp + relative]
    mov bh, 0x07
    int 0x80
    ret

helloworld: db "Hello! (FROM PROGRAM!)", 0x0d, 0
relative: db "Introducing: RELATIVE ADDRESSING", 0x0d, 0

times (512*8)-($-$$) db 0
