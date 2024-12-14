; boot.asm - Shitty bootloader

section .text
    global _start

_start:
    ; Set up the video mode (text mode)
    mov ax, 0x0003  ; Set video mode to 80x25 text mode
    int 0x10        ; BIOS interrupt

    ; Print "Welcome to My Linux OS!"
    mov si, message  ; Load the address of the message
    call print_string ; Call the print function

    ; Hang the system
hang:
    jmp hang         ; Infinite loop

print_string:
    ; Print the string pointed to by SI
    mov ah, 0x0E     ; BIOS teletype function
.next_char:
    lodsb            ; Load byte at DS:SI into AL and increment SI
    cmp al, 0       ; Check for null terminator
    je .done        ; If null, we're done
    int 0x10        ; Print the character in AL
    jmp .next_char  ; Repeat for the next character
.done:
    ret

section .data
message db 'Welcome 2 SpringOS!', 0  ; Null-terminated string
