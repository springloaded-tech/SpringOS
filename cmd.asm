; cmd.asm - (this is the final update i swear ty)

section .text
   global _start

_start: 
    ; Set up the vidya mode shit or text mode
    mov ax, 0x0003  ; Set vidya mode to 80x25 text mode
    int 0x10        ; BIOS interrupt

    ; Print "SpringOS"
    mov si, message  ; Load the address of the message
    call print_string ; Call the print function

    ; Hang the system
hang:
    jmp hang         ; Infinite loop

print_string:
    ; Print the string pointed to by SI
    mov ah, 0x0E     ; BIOS teletype function
.next_char: 
    lodsb            ; Load byte at DS:SI into AL and SI
    cmp al, 0       ; Check for null terminator
    je .done        ; If null, we're done
    int 0x10        ; Print the character in AL
    jmp .next_char  ; Repeat for the next character
.done:
    ret

section .data
message db 'SpringOS', 0 ; Null-terminated string
