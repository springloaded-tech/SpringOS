; CLI in assembly wow
; Whopper whopper whopper whopper jr double chicken whopper

org 0x7C00          

section .text
start:
 
    mov ax, 0x0003   ; Set video mode 3 (80x25 text mode)
    int 0x10

e
    mov si, welcome_message
    call print_string

main_loop:

    mov si, prompt
    call print_string

    call read_command


    cmp byte [command_buffer], 'e'
    jne not_exit
    cmp byte [command_buffer + 1], 'x'
    jne not_exit
    cmp byte [command_buffer + 2], 'i'
    jne not_exit
    cmp byte [command_buffer + 3], 't'
    jne not_exit
    
    jmp exit_program

not_exit:
    
    mov si, command_buffer
    call print_string
    jmp main_loop

exit_program:
    ; Hang the system (in a real OS, you would return to the bootloader or halt)
    hlt

; Function to print a null-terminated string (Don't mess with this Tyshaun)
print_string:
    mov ah, 0x0E      ; BIOS teletype output
.next_char:
    lodsb             ; Load byte at DS:SI into AL and increment SI
    cmp al, 0        ; Check for null terminator
    je .done
    int 0x10         ; Print character in AL
    jmp .next_char
.done:
    ret


read_command:
    mov di, command_buffer
    mov cx, 0
.read_loop:
    ; Read a character
    mov ah, 0x00      ; BIOS keyboard read
    int 0x16
    cmp al, 0x0D      ; Check for Enter key
    je .done_reading
    stosb             ; Store character in command_buffer
    inc cx
    jmp .read_loop
.done_reading:
    mov byte [di], 0  ; Null-terminate the string
    ret

section .data
welcome_message db 'Welcome toSpringOS!', 0
prompt db '> ', 0
command_buffer db 128 dup(0)  ; Buffer for command input

times 510 - ($ - $$) db 0      ; Fill the rest of the boot sector with zeros
dw 0xAA55                       ; Boot signature
