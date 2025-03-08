; ACEDOS SYSTEM INTERFACE
; 3/2/25 Notoriginal

%macro CMPJMP 1
    cmp ax, %1
    je .ax%1
%endmacro

%macro LABEL 3
.ax%1:
    %if %3 == 1
        cmp byte [.legacy], 1
        jne .return
    %endif
    call %2
    jmp .return
%endmacro

_asi_interruptwrapper:
    call _asi
    iret

_asi:
    CMPJMP 0
    CMPJMP 1
    CMPJMP 2
    CMPJMP 3
    CMPJMP 4
    CMPJMP 5
    CMPJMP 8
    CMPJMP 10
    CMPJMP 20
    CMPJMP 21
    CMPJMP 22
    CMPJMP 23
    CMPJMP 24
    jmp .return
LABEL 0, _legacy_putc, 1
LABEL 1, _legacy_setformat, 1
LABEL 2, _legacy_setcursor, 1
LABEL 3, _getkeystroke, 0
LABEL 4, _printhex, 1
LABEL 5, _clearscreen, 0
LABEL 8, _formatscreen, 1
LABEL 10, _legacy_puts, 1
LABEL 20, _putc, 0
LABEL 21, _puts, 0
LABEL 22, _setcursor, 0
LABEL 23, _strcmp, 0
LABEL 24, _cursor_to_2d, 0
.return:
    ret
.legacy: db 1

; bl - character
_legacy_putc:
    pusha
    mov al, bl
    mov bx, 0
    mov ah, 0x0e
    int 0x10
    popa
    ret

; bl - formatting
; ch - cursor row
; cl - cursor column
_legacy_setformat:
    pusha

    mov al, ch
    mov ah, 80
    mul ah
    mov ch, 0
    add cx, ax

    shl cx, 1
    add cx, 1
    mov di, cx
    mov [fs:di], bl

    popa
    ret

; bh - row
; bl - column
_legacy_setcursor:
    pusha

    mov ah, 0x02
    mov dx, bx
    mov bh, 0
    int 0x10

    popa
    ret

; returns ->
;           ah - row
;           al - column
_getcursor:
    pusha
    mov ah, 0x03
    mov bh, 0
    int 0x10
    mov [.results], dx
    popa
    mov ax, [.results]
    ret
.results: dw 0

; returns ->
;           ah - bios scan code
;           al - ascii character
_getkeystroke:
    pusha
    mov ah, 0x00
    int 0x16
    mov [.results], ax
    popa
    mov ax, [.results]
    ret
.results: dw 0

; bl - hex byte
_printhex:
    pusha
    mov ah, 0x0e
    mov bh, 0
    mov [.bl], bl
    shr bl, 4
    and bl, 0xf
    mov si, bx
    add si, .hexdigits
    mov al, [si]
    int 0x10
    mov bl, [.bl]
    and bl, 0xf
    mov si, bx
    add si, .hexdigits
    mov al, [si]
    int 0x10
    popa
    ret
.hexdigits: db "0123456789ABCDEF"
.bl: db 0

_clearscreen:
    pusha
    mov ah, 0x00
	mov al, 0x03
	int 0x10
    popa
    ret

; bl - attribute byte
_formatscreen:
    pusha
    mov ah, 0x06
    mov al, 0
    mov bh, bl
    mov bl, 0
    mov cx, 0
    mov dx, 0x184F
    int 0x10
    popa
    ret

; si - char*
_legacy_puts:
    pusha
.loop:
    mov al, [si]
    cmp al, 0
    je .return
    mov bl, al
    call _legacy_putc
    inc si
    jmp .loop
.return:
    popa
    ret

; bl - character
; bh - formatting
_putc:
    pusha
    mov si, [0x7c00]
.handlespecial:
    cmp bl, 0x0d
    je .newline
    cmp bl, 0x08
    je .backspace
    cmp bl, 0
    je .return
    jmp .printable
.newline:
    mov bx, 80
    xor dx, dx 
    mov ax, si
    div bx
    inc ax
    mul bx
    mov cx, ax
    call _setcursor
    jmp .return
.backspace:
    dec si
    mov di, si
    shl di, 1
    mov byte [fs:di], 0
    mov cx, si
    call _setcursor
    jmp .return
.printable:
    mov di, si
    shl di, 1
    mov [fs:di], bx
    mov [.lastformat], bh
    inc si
    mov cx, si
    call _setcursor
.return:
    popa
    ret
.lastformat: db 0

; si - char*
; bh - formatting
_puts:
    pusha
.loop:
    mov bl, [si]
    inc si
    cmp bl, 0
    je .return
    call _putc
    jmp .loop
.return:
    popa
    ret

; cx - 1D cursor
_setcursor:
    pusha
    mov [0x7c00], cx
    call _cursor_to_2d
    mov bh, 0
    mov dh, ah
    mov dl, al
    mov ah, 0x02
    int 0x10
    mov bh, [_putc.lastformat]
    mov di, cx
    shl di, 1
    inc di
    mov [fs:di], bh
    popa
    ret

; cx - 1D cursor
; returns ->
;           ah - row
;           al - column
_cursor_to_2d:
    pusha
    mov ax, cx
    mov cx, 80
    xor dx, dx
    div cx
    shl ax, 8
    or ax, dx
    mov [.results], ax
    popa
    mov ax, [.results]
    ret
.results: dw 0

; si - string1
; di - string2
; returns ->
;           ax - equal if 0
_strcmp:
.loop:
    mov al, [si]
    mov ah, [di]
    inc si
    inc di
    cmp al, ah
    jne .notequal
    cmp al, 0
    je .endofstring
    jmp .loop
.endofstring:
    xor ax, ax
    ret
.notequal:
    mov ax, 1
    ret