org 0x8200
bits 32

; eax - function
; esi - arg0
; edi - arg1
; edx - arg2
_main:
    cmp eax, 0 ; _write
    je .eax0
    cmp eax, 1 ; _keypress
    je .eax1
    cmp eax, 2 ; _waitforkeypress
    je .eax2
    cmp eax, 3 ; _printc
    je .eax3
    cmp eax, 4 ; _setcursor
    je .eax4
    cmp eax, 5 ; _convert
    je .eax5
    cmp eax, 6 ; _roundupto
    je .eax6
    jmp .return
.eax0:
    call _write
    jmp .return
.eax1:
    call _keypress
    jmp .return
.eax2:
    call _waitforkeypress
    jmp .return
.eax3:
    call _printc
    jmp .return
.eax4:
    call _setcursor
    jmp .return
.eax5:
    call _convert
    jmp .return
.eax6:
    call _roundupto
    jmp .return
.return:
    ret

; esi - char*
; edi - formatting (only lower byte counts)
_write:
    push eax
    push esi
    push edi
    push ebx
    push ecx
.loop:
    mov al, [esi]
    cmp al, 0
    je .exit
    inc esi
    push esi
    mov esi, eax
    call _printc
    pop esi
    jmp .loop
.exit:
    pop eax
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

; returns ->
;           eax - key pressed
;           cf - make/break
_keypress:
    mov eax, 0
.wait:
    in al, 0x64
    test al, 1
    jz .wait
    in al, 0x60
    test al, al
    jz .wait
    clc
    test al, 0x80
    jne .return
    stc
.return:
    ret

; esi - key to be pressed (1 byte)
_waitforkeypress:
    push ebx
    mov ebx, esi
    and bl, 0x7f
.wait:
    in al, 0x60
    test al, al
    jz .wait
    cmp al, bl
    jne .wait
    pop ebx
    ret

; esi - character to be printed (1 byte)
; edi - formatting (1 byte)
_printc:
    test esi, esi
    jz .return
    push eax
    push ebx
    push ecx
    push esi
    push edi
.handlespecial:
    cmp esi, 0x0a
    je .newline
    cmp esi, 0x08
    je .backspace
    cmp esi, 0x09
    je .tab
    jmp .printable
.newline:
    mov esi, [cursor]
    mov edi, 80
    call _roundupto
    mov esi, eax
    call _setcursor
    jmp .return
.backspace:
    mov esi, [cursor]
    sub esi, 1
    call _setcursor
    mov ebx, 0xb8000
    mov ecx, [cursor]
    shl ecx, 1
    mov word [ebx + ecx], 0
    jmp .return
.tab:
    mov esi, [cursor]
    mov edi, 4
    call _roundupto
    mov esi, eax
    call _setcursor
    jmp .return
.printable:
    and esi, 0xff
    and edi, 0xff
    shl edi, 8
    mov eax, esi
    add eax, edi
    mov ebx, 0xb8000
    mov ecx, [cursor]
    shl ecx, 1
    mov [ebx + ecx], ax
    shr ecx, 1
    inc ecx
    mov [cursor], ecx
.return:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; esi - cursor
; returns (for debugging) ->
;                           eax - position of cursor in memory
_setcursor:
    cmp esi, 0
    jl .return
    mov [cursor], esi
    mov eax, cursor
.return:
    ret

; esi - ps/2 code to convert
; returns ->
;           eax - ascii
_convert:
    push esi
    push ebx
    mov ebx, 0x80
    not ebx
    and esi, ebx
    mov al, [keymap+esi]
    pop ebx
    pop esi
    ret

; esi - number
; edi - unit
; returns -> 
;           eax - number rounded up to nearest unit
_roundupto:
    push edx
    push ebx
    push esi
    push edi
    xor edx, edx
    mov eax, esi
    div edi
    inc eax
    mov ebx, edi
    mul ebx 
    pop edi
    pop esi
    pop ebx
    pop edx
    ret

cursor: dd 0

keymap: db 0,0,"1234567890-",0,0x08,0x09,"qwertyuiop",0,0,0x0a,0,"asdfghjkl",0,"'",0,0,0,"zxcvbnm,./",0,0,0,0x20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

times (512*2)-($-$$) db 0
