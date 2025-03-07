; KERNEL
; 3/2/25 Notoriginal

org 0xa000
bits 16

_kernel:
    mov ax, 22 ; set cursor
    mov cx, (80*6)
    int 0x80

    mov ax, 21 ; print
    mov si, hello
    mov bh, 0x0c
    int 0x80

    mov ax, 10 ; legacy print
    mov si, disabled
    int 0x80

    mov ax, 22 ; set cursor
    mov cx, (80*7)
    int 0x80

    jmp .returntoloop
.loop:
    mov ax, 3 ; keystroke
    int 0x80
    cmp al, 0x0d
    je .nextline
    cmp al, 0x08
    je .undo
    inc byte [length]
    mov bl, al
    mov bh, 0x07
    mov di, [pointer]
    mov [di], bl
    mov byte [di+1], 0
    inc word [pointer]
    mov ax, 20 ; print character 
    int 0x80
    jmp .loop
.nextline:
    mov ax, 20
    mov bh, 0x07
    mov bl, 0x0d
    int 0x80
    mov word [pointer], buffer
    mov si, buffer
    mov di, clear
    mov ax, 23
    int 0x80
    test ax, ax
    jz .clear
    mov si, buffer
    mov di, testy
    mov ax, 23
    int 0x80
    test ax, ax
    jz .testy
    mov si, buffer
    mov di, run
    mov ax, 23
    int 0x80
    test ax, ax
    jz .run
    mov si, buffer
    mov di, help
    mov ax, 23
    int 0x80
    test ax, ax
    jz .help
    mov si, buffer
    mov di, load
    mov ax, 23
    int 0x80
    test ax, ax
    jz .load
    mov si, buffer
    mov di, unload
    mov ax, 23
    int 0x80
    test ax, ax
    jz .unload
    cmp byte [buffer], 0
    je .returntoloop
    mov bh, 0x0c
    mov si, notacommand
    mov ax, 21
    int 0x80
    jmp .returntoloop
.clear:
    mov ax, 5
    int 0x80
    mov ax, 22
    mov cx, 0
    int 0x80
    jmp .returntoloop
.testy:
    mov ax, 21
    mov si, testy_msg
    mov bh, 0x07
    int 0x80
    jmp .returntoloop
.run:
    cmp byte [.loaded], 0
    je .nothingloaded
    cmp byte [0xb000], 0x88
    jne .invalid
    call 0xb001
    jmp .returntoloop
.load:
    cmp byte [.loaded], 1
    je .alreadyloaded
    mov ah, 0x02
    mov al, 16
    mov ch, 0
    mov cl, 1
    mov dh, 0
    mov dl, 1
    mov bx, 0xb000
    int 0x13
    mov ax, 21
    mov si, load_msg
    mov bh, 0x07
    int 0x80
    mov byte [.loaded], 1
    jmp .returntoloop
.nothingloaded:
    mov ax, 21
    mov si, nothingloaded
    mov bh, 0x0c
    int 0x80
    jmp .returntoloop
.alreadyloaded:
    mov ax, 21
    mov si, alreadyloaded
    mov bh, 0x0c
    int 0x80
    jmp .returntoloop
.loaded: db 0
.unload:
    cmp byte [.loaded], 0
    je .nothingloaded
    mov ax, 21
    mov si, unload_msg
    mov bh, 0x07
    int 0x80
    mov byte [.loaded], 0
    jmp .returntoloop
.help:
    mov ax, 21
    mov si, help_msg
    mov bh, 0x07
    int 0x80
    jmp .returntoloop
.undo:
    cmp byte [length], 0
    je .loop
    mov ax, 20
    mov bl, 0x08
    mov bh, 0x07
    int 0x80
    mov di, [pointer]
    mov byte [di], 0
    dec di
    mov [pointer], di
    jmp .loop
.returntoloop:
    mov byte [buffer], 0
    mov cx, [0x7c00]
    mov ax, 24
    int 0x80
    cmp ah, 25
    jl .notoverflow
    mov cx, 2000
.clearloop:
    mov di, cx
    shl di, 1
    mov word [fs:di], 0
    loop .clearloop
    mov word [0x7c00], 0
.notoverflow:
    mov ax, 21
    mov si, prefix
    mov bh, 0x07
    int 0x80
    jmp .loop
.invalid:
    mov ax, 21
    mov si, invalid
    mov bh, 0x0c
    int 0x80
    jmp .returntoloop

    jmp _halt

_halt:
    jmp $

hello: db "Hello from Kernel!", 0
disabled: db "Legacy functions have been disabled. If you see this, you done messed something up.", 0
pointer: dw buffer
length: db 0
clear: db "clear", 0
testy: db "test", 0
testy_msg: db "test", 0x0d, 0
prefix: db "$ ", 0
load: db "load", 0
load_msg: db "Program loaded.", 0x0d, 0
run: db "run", 0
help: db "help", 0
help_msg: db "Commands: clear, test, run, help, load, unload", 0x0d, 0
nothingloaded: db "No program has been loaded! (use 'load' command)", 0x0d, 0
unload: db "unload", 0
unload_msg: db "Program unloaded.", 0x0d, 0
alreadyloaded: db "Program already loaded! (use 'unload' command)", 0x0d, 0
buffer: times 256 db 0
notacommand: db "That's not a command (probably mispelled, use 'help' to see all commands)", 0x0d, 0
lr: db "lr", 0
invalid: db "Program is missing the header byte (0x88) and was flagged as not executable.", 0x0d, 0

times (512*8)-($-$$) db 0