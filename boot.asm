; boot.asm - boot.asm but bad

section .text
    global _start

_start:
    ; Set up the video mode (text mode)
    mov ax, 0x0003       ; Set video mode to 80x25 text mode
    int 0x10             ; BIOS interrupt

    ; Display a splash screen
    call splash_screen

    ; Print "Welcome to SpringOS!"
    mov si, welcome_msg  ; Load the address of the message
    call print_string    ; Call the print function

    ; Perform a memory check
    call memory_check

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

memory_check:
    ; Check and display available memory
    mov ah, 0x88         ; BIOS function to get extended memory size
    int 0x15
    mov si, mem_msg
    call print_string
    mov ax, cx          ; Store extended memory in AX
    call print_hex       ; Print memory size in KB
    ret

splash_screen:
    mov si, splash_msg
    call print_string
    ret

hang:
    jmp hang             ; Infinite loop

print_string:
    ; Print the string pointed to by SI
    mov ah, 0x0E         ; BIOS teletype function
.next_char:
    lodsb                ; Load byte at DS:SI into AL and increment SI
    cmp al, 0            ; Check for null terminator
    je .done             ; If null, we're done
    int 0x10             ; Print the character in AL
    jmp .next_char       ; Repeat for the next character
.done:
    ret

print_hex:
    ; Print AX in hexadecimal format
    push ax
    mov cx, 4            ; Four hexadecimal digits
.next_digit:
    rol ax, 4            ; Rotate left by 4 bits
    mov bl, al           ; Copy the lowest nibble to BL
    and bl, 0x0F         ; Mask the lower 4 bits
    add bl, '0'          ; Convert to ASCII
    cmp bl, '9'
    jbe .print
    add bl, 7            ; Adjust for A-F
.print:
    mov ah, 0x0E
    int 0x10
    loop .next_digit
    pop ax
    ret

section .data
welcome_msg db 'Welcome to SpringOS!', 0
error_msg db 'Disk error! Halting...', 0
mem_msg db 'Available memory: ', 0
splash_msg db '*** SpringOS Bootloader ***', 0
