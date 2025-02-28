org 0x7c00
bits 16

_start:
    xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov sp, 0x7c00

    mov ah, 0x00
	mov al, 0x03
	int 0x10

	mov ah, 0x1
	mov cx, 0x2607
	int 0x10

    mov ah, 0x02
	mov al, 15
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov bx, 0x7e00
	int 0x13


    lgdt [gdt_descriptor]

	mov eax, cr0
	or eax, 1
	mov cr0, eax

	cli
	jmp 0x8:_bits32

    jmp $

bits 32
_bits32:
    cli
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esp, 0x90000

    call 0x7e00

    jmp $

gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF

gdt_descriptor:
    dw gdt_descriptor - gdt_start - 1
    dd gdt_start

times 510-($-$$) db 0
dw 0xaa55