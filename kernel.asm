[GLOBAL kmain]
kmain:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    call boot_animation

    mov dword [cursor_pos], 0xb8000 + 1990

    call draw_ui
    jmp main_loop

boot_animation:
    mov edi, 0xb8000
    mov ecx, 2000
    mov ah, 0x00
    mov al, ' '
    rep stosw
    
    mov edi, 0xb8000 + 1000
    mov esi, anim_msg
    mov ah, 0x0A
    call print_string

    mov bl, 0
anim_loop:
    cmp bl, 4
    je anim_done

    mov edi, 0xb8000 + 1000 + 32
    mov cl, bl
    mov ax, 0x0A2E
    rep stosw

    mov ecx, 0x9FFFFF
    anim_delay:
        loop anim_delay

    inc bl
    jmp anim_loop
anim_done:
    ret

draw_ui:
    mov edi, 0xb8000
    mov ecx, 2000
    mov ah, 0x1F
    mov al, ' '
    rep stosw
    
    mov edi, 0xb8000 + 160
    mov esi, menu_msg
    mov ah, 0x1E
    call print_string

    call draw_cross

main_loop:
    call draw_cursor
    call get_key

    cmp al, 0x02
    je run_clicker_setup
    cmp al, 0x03
    je run_calculator
    cmp al, 0x04
    je run_sysinfo_setup
    cmp al, 0x05
    je run_prayer_setup
    cmp al, 0x06
    je run_game2_stub
    
    cmp al, 0x48
    je move_up
    cmp al, 0x50
    je move_down
    cmp al, 0x4B
    je move_left
    cmp al, 0x4D
    je move_right
    jmp main_loop

move_up:
    sub dword [cursor_pos], 160
    jmp main_loop
move_down:
    add dword [cursor_pos], 160
    jmp main_loop
move_left:
    sub dword [cursor_pos], 2
    jmp main_loop
move_right:
    add dword [cursor_pos], 2
    jmp main_loop

draw_cursor:
    mov edi, [cursor_pos]
    mov ax, [edi]
    xor ah, 0xFF
    mov [edi], ax
    ret

run_clicker_setup:
    mov edi, 0xb8000 + 320
    mov esi, clicker_msg
    mov ah, 0x1A
    call print_string
    call run_clicker_game
    jmp draw_ui

run_clicker_game:
    mov byte [click_count], '0'
    click_loop:
        call get_key
        cmp al, 0x01
        je .exit_game
        cmp al, 0x02
        inc byte [click_count]
        mov al, [click_count]
        mov [0xb8000 + 334], al
        jmp click_loop
    .exit_game:
    ret

run_calculator:
    mov edi, 0xb8000 + 320
    mov esi, calc_msg
    mov ah, 0x1C
    call print_string
    call wait_for_esc
    jmp draw_ui

run_sysinfo_setup:
    mov edi, 0xb8000 + 320
    mov esi, info_os
    mov ah, 0x1B
    call print_string
    mov edi, 0xb8000 + 480
    mov esi, info_cpu_stub
    mov ah, 0x1B
    call print_string
    call wait_for_esc
    jmp draw_ui

run_prayer_setup:
    mov edi, 0xb8000 + 320
    mov esi, prayer_msg1
    mov ah, 0x1D
    call print_string
    mov edi, 0xb8000 + 480
    mov esi, prayer_msg2
    mov ah, 0x1F
    call print_string
    call wait_for_esc
    jmp draw_ui

run_game2_stub:
    mov edi, 0xb8000 + 320
    mov esi, game2_msg
    mov ah, 0x1D
    call print_string
    call wait_for_esc
    jmp draw_ui

draw_cross:
    mov ah, 0x1F
    mov al, '|'
    mov [0xb8000 + 3598], ax
    mov [0xb8000 + 3758], ax
    mov al, '-'
    mov [0xb8000 + 3756], ax
    mov [0xb8000 + 3760], ax
    mov al, '+'
    mov [0xb8000 + 3758], ax
    mov al, '|'
    mov [0xb8000 + 3918], ax
    ret

get_key:
    in al, 0x64
    test al, 0x01
    jz get_key
    in al, 0x60
    ret

wait_for_esc:
    call get_key
    cmp al, 0x01
    jne wait_for_esc
    ret

print_string:
    lodsb
    test al, al
    jz .done
    mov [edi], ax
    add edi, 2
    jmp print_string
.done:
    ret

menu_msg     db "1: Clicker | 2: Calc(Stub) | 3: SysInfo | 4: Prayer | 5: Game(Stub)", 0
clicker_msg  db "SCORE: 0 (Press 1 to click, Esc to exit)", 0
calc_msg     db "Calculator app TBD. Press ESC to return.", 0
info_os      db "OS: GodOS v2.3 (Multiboot x32, Animated)", 0
info_cpu_stub db "CPU: Generic x86 detected.", 0
prayer_msg1  db "I AM LOVE GOD.", 0
prayer_msg2  db "GodOS is blessed.", 0
game2_msg    db "Another game TBD. Press ESC to return.", 0
anim_msg     db "Loading GodOS you're cool :3 (OS created by genaadolf)", 0
click_count  db 0
cursor_pos   dd 0
