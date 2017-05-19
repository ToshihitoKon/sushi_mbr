; sushi.asm

section .data
    loop_count db 0x00

section .text

; mbr setup
mov ax, 0x07c0
mov ds, ax

; clean display
mov ah, 0x0
mov al, 0x3
int 0x10

mov cx, 0x0

print_sushi_loop:
    
    ; set cursor position
    mov al, [loop_count]
    add al, cl
    cmp al, 33
    js cur_set
    sub al, 32

    cur_set:
    cmp al, 28
    jns LEFT
    cmp al, 16
    jns UNDER
    cmp al, 12
    jns RIGHT

    ; TOP
    mov dl, al
    mov al, 2
    mul dl
    mov dh, 0  ; row
    mov dl, al ; column
    jmp SUSHI

    RIGHT:
    sub al, 11
    mov dh, al ; row
    mov dl, 22 ; column
    jmp SUSHI

    UNDER:
    mov dh, 5  ; row
    mov dl, 27 ; column
    sub dl, al
    mov al, 2
    mul dl
    mov dl, al
    jmp SUSHI

    LEFT:
    mov dh, 32 ; row
    sub dh, al
    mov dl, 0  ; column

    SUSHI:
    mov ah, 0x02
    mov bh, 0x00 ; page
    int 0x10

    ; print sushi
    mov ah, 0x0e
    mov bx, cx
    mov al, [sushi+bx]
    int 0x10

    ; counter incriment
    add cx, 1

    ; if cx==6
    cmp cx, 6
    jnz sub_skip

    ; wait loop
    push cx
    mov cx, 0
    ffor_begin:
        push cx
        mov cx, 0
        for_begin:
            add cx, 1
            cmp cx, 0xFFFF
            jnz for_begin
        pop cx
        add cx, 1
        cmp cx, 0x02FF
        jnz ffor_begin
    pop cx
    
    add cx, 1
    push cx
    mov cx, 0
    
    ; counter and display clear
    mov ah, 0x00
    mov al, 0x02
    ; int 0x10
    
    mov dl, [loop_count]
    add dl, 0x01
    cmp dl, 32
    jnz no_reset
    mov dl, 0

    no_reset:
    mov [loop_count], dl

    sub_skip:
    jmp print_sushi_loop
    
sushi:
    db ' sushi'


    times 510-($-$$) db 0
    
    db 0x55
    db 0xAA
