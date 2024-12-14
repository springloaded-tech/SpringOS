; boot.asm - not so shitty no more LOL

section .text
    global _start

_start:
    ; Set up the video mode (text mode)
    mov ax, 0x0003  ; Set video mode to 80x25 text mode
    int 0x10        ; BIOS interrupt

    ; Print "Welcome to SpringOS!"
    mov si, message  ; Load the address of the message
    call print_string ; Call the print function

    ; Display a graphical logo
    call display_logo

    ; Load and execute the kernel
    mov ax, 0x0800       ; Segment where the kernel will be loaded
    mov es, ax           ; Set ES to this segment
    xor bx, bx           ; Offset 0x0000
    mov ah, 0x02         ; BIOS read sectors function
    mov al, 0x10         ; Read 16 sectors
    mov ch, 0            ; Cylinder 0
    mov cl, 2            ; Start reading from sector 2
    mov dh, 0            ; Head 0
    mov dl, 0            ; Drive 0 (first floppy)
    int 0x13             ; BIOS disk interrupt
    jc disk_error        ; Jump to error if carry flag is set

    ; Jump to kernel entry point
    jmp 0x0800:0000

disk_error:
    mov si, error_msg
    call print_string
    hlt                 ; Halt the CPU

hang:
    jmp hang             ; Infinite loop

print_string:
    ; Print the string pointed to by SI
    mov ah, 0x0E         ; BIOS teletype function
.next_char:
    lodsb                ; Load byte at DS:SI into AL and increment SI
    cmp al, 0           ; Check for null terminator
    je .done            ; If null, we're done
    int 0x10            ; Print the character in AL
    jmp .next_char      ; Repeat for the next character
.done:
    ret

display_logo:
    ; ASCII art logo representation
    mov si, logo
    call print_string
    ret

section .data
message db 'Welcome to SpringOS!', 0  ; Null-terminated string
error_msg db 'Disk error! Halting...', 0
logo db '    ****    ', 0x0A
     db '  *      *  ', 0x0A
     db '  *      *  ', 0x0A
     db '    ****    ', 0
