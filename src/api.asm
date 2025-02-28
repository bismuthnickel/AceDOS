org 0x8200
bits 32

; eax - function
; esi - arg0
; edi - arg1
; edx - arg2
_main:
    cmp eax, 0
    je .eax0

    cmp eax, 1
    je .eax1

    cmp eax, 2
    je .eax2

    jmp .return
.eax0: ; _write
    call _write
    jmp .return
.eax1: ; _keypress
    call _keypress
    jmp .return
.eax2: ; _waitforkeypress
    call _waitforkeypress
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
    mov ebx, edi
    mov ah, bl
    mov ebx, 0xb8000
    mov ecx, [cursor]
    shl ecx, 1
    mov [ebx + ecx], ax
    shr ecx, 1
    inc ecx
    mov [cursor], ecx
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
    in al, 0x60
    test al, al
    jz _keypress
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

cursor: dd 0

times (512*2)-($-$$) db 0
