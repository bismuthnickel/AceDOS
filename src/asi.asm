; ACEDOS SYSTEM INTERFACE
; 3/2/25 Notoriginal

%macro CMPJMP 1
    cmp ax, %1
    je .ax%1
%endmacro

%macro LABEL 2
.ax%1:
    call %2
    jmp .return
%endmacro

_asi:
    CMPJMP 0
    CMPJMP 1
    CMPJMP 2
    CMPJMP 3
LABEL 0, _printc
LABEL 1, _setformat
LABEL 2, _setcursor
LABEL 3, _getkeystroke
.return:
    ret

; bl - character
_printc:
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
_setformat:
    pusha

    mov al, ch
    mov ah, 80
    mul ah
    mov ch, 0
    add cx, ax

    push es
    mov ax, 0xb800
    mov es, ax
    shl cx, 1
    add cx, 1
    mov di, cx
    mov [es:di], bl
    pop es

    popa
    ret

; bh - row
; bl - column
_setcursor:
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