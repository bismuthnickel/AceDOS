; BOOTLOADER
; 3/2/25 Notoriginal

org 0x7c00
bits 16

_start:
    xor ax, ax
	mov ds, ax
	mov es, ax
	mov gs, ax
	mov ss, ax
	mov sp, 0x7b00

	mov ax, 0xb800
	mov fs, ax

    mov ah, 0x00
	mov al, 0x03
	int 0x10

    mov ah, 0x02
	mov al, 4
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov bx, 0x7e00
	int 0x13

	; SET UP NEW CURSOR
	mov word [0x7c00], 0

	jmp 0x7e00

	jmp $

times 510-($-$$) db 0
dw 0xaa55