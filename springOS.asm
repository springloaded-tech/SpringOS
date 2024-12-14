; springOS.asm - Kernel for SpringOS
; Created by Tyshaun, SpringLoaded Tech.

section .text
    global start_kernel

start_kernel:
    ; Initialize multitasking
    call init_multitasking

    ; Initialize filesystem (FAT12)
    call init_filesystem

    ; Display system status
    call display_status

    ; Start command-line interface (CLI)
    call start_cli

    ; Halt CPU when CLI exits
    cli
    hlt

init_multitasking:
    ; Basic round-robin multitasking setup
    ; Placeholder: Switch between dummy tasks
    mov si, multitask_msg
    call print_string
    ret

init_filesystem:
    ; FAT12 Initialization Placeholder
    mov si, filesystem_msg
    call print_string
    ret

display_status:
    ; Show system information (uptime, memory, tasks)
    mov si, status_msg
    call print_string
    call memory_check
    ret

start_cli:
    ; Basic command-line interface
.cli_loop:
    lea si, prompt_msg
    call print_string
    call read_input        ; Read user command
    call execute_command   ; Execute the command
    jmp .cli_loop

read_input:
    ; Read user input into input_buffer
    mov ah, 0x0A           ; BIOS Input function
    lea dx, input_buffer
    int 0x21               ; Read input
    ret

execute_command:
    ; Execute basic commands (help, ls, cat, sysinfo)
    lea si, input_buffer + 1 ; Skip length byte
    cmp byte [si], 'h'     ; Check if command is 'help'
    je .run_help
    cmp byte [si], 'l'     ; Check if command is 'ls'
    je .run_ls
    cmp byte [si], 'c'     ; Check if command is 'cat'
    je .run_cat
    cmp byte [si], 's'     ; Check if command is 'sysinfo'
    je .run_sysinfo
    jmp .unknown_command

.run_help:
    lea si, help_msg
    call print_string
    ret

.run_ls:
    lea si, ls_msg
    call print_string
    ret

.run_cat:
    lea si, cat_msg
    call print_string
    ret

.run_sysinfo:
    lea si, sysinfo_msg
    call print_string
    call memory_check      ; Display available memory
    ret

.unknown_command:
    lea si, unknown_msg
    call print_string
    ret

memory_check:
    ; Check and display available memory
    mov ah, 0x88           ; BIOS function to get extended memory size
    int 0x15
    mov si, mem_msg
    call print_string
    mov ax, cx             ; Extended memory in KB
    call print_hex         ; Print in hex format
    ret

print_string:
    ; Print the string pointed to by SI
    mov ah, 0x0E           ; BIOS teletype function
.next_char:
    lodsb                  ; Load byte at DS:SI into AL and increment SI
    cmp al, 0              ; Check for null terminator
    je .done               ; If null, we’re done
    int 0x10               ; Print the character in AL
    jmp .next_char         ; Repeat for the next character
.done:
    ret

print_hex:
    ; Print AX in hexadecimal format
    push ax
    mov cx, 4              ; Four hexadecimal digits
.next_digit:
    rol ax, 4              ; Rotate left by 4 bits
    mov bl, al             ; Copy the lowest nibble to BL
    and bl, 0x0F           ; Mask the lower 4 bits
    add bl, '0'            ; Convert to ASCII
    cmp bl, '9'
    jbe .print
    add bl, 7              ; Adjust for A-F
.print:
    mov ah, 0x0E
    int 0x10
    loop .next_digit
    pop ax
    ret

section .data
prompt_msg db 'SpringOS> ', 0
help_msg db 'Commands: help, ls, cat, sysinfo', 0
ls_msg db 'Listing files... (not yet implemented)', 0
cat_msg db 'Displaying file... (not yet implemented)', 0
sysinfo_msg db 'System Information:', 0
unknown_msg db 'Unknown command. Try again.', 0
mem_msg db 'Memory Available: ', 0
status_msg db 'System Status: Multitasking and FAT12 ready.', 0
multitask_msg db 'Multitasking initialized.', 0
filesystem_msg db 'FAT12 Filesystem initialized.', 0

section .bss
input_buffer resb 128          ; Reserve space for input buffer
