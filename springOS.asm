; springOS.asm - Kernel for SpringOS
; Created by Tyshaun, SpringLoaded Tech.

[org 0x7C00]                ; Origin for boot sector (512-byte boundary)

section .text
_start:
    cli                     ; Disable interrupts
    xor ax, ax              ; Clear AX register
    mov ds, ax              ; Set data segment to 0
    mov es, ax              ; Set extra segment to 0

    ; Print welcome message
    mov si, welcome_msg
    call print_string

    ; Initialize subsystems
    call init_multitasking
    call init_filesystem

    ; Display system status
    call display_status

    ; Start command-line interface
    call start_cli

    ; Halt when CLI exits
    hlt

init_multitasking:
    ; Placeholder for multitasking initialization
    mov si, multitask_msg
    call print_string
    ret

init_filesystem:
    ; Placeholder for FAT12 initialization
    mov si, filesystem_msg
    call print_string
    ret

display_status:
    mov si, status_msg
    call print_string
    call memory_check
    ret

start_cli:
.cli_loop:
    mov si, prompt_msg
    call print_string
    call read_input
    call execute_command
    jmp .cli_loop

read_input:
    ; Read input into input_buffer
    mov ah, 0x0A            ; DOS input function (requires DOSBox)
    lea dx, [input_buffer]  ; Address of input buffer
    int 0x21
    ret

execute_command:
    lea si, [input_buffer + 2] ; Skip length and CR byte
    cmp byte [si], 'h'
    je .run_help
    cmp byte [si], 'l'
    je .run_ls
    cmp byte [si], 'c'
    je .run_cat
    cmp byte [si], 's'
    je .run_sysinfo
    jmp .unknown_command

.run_help:
    mov si, help_msg
    call print_string
    ret

.run_ls:
    mov si, ls_msg
    call print_string
    ret

.run_cat:
    mov si, cat_msg
    call print_string
    ret

.run_sysinfo:
    mov si, sysinfo_msg
    call print_string
    call memory_check
    ret

.unknown_command:
    mov si, unknown_msg
    call print_string
    ret

memory_check:
    mov ah, 0x88            ; BIOS function for memory
    int 0x15
    mov si, mem_msg
    call print_string
    mov ax, cx              ; Memory size in KB
    call print_hex
    ret

print_string:
    ; Print the string at DS:SI
.next_char:
    lodsb                   ; Load byte from DS:SI into AL
    or al, al               ; Check for null terminator
    jz .done
    mov ah, 0x0E            ; BIOS teletype
    int 0x10
    jmp .next_char
.done:
    ret

print_hex:
    ; Print AX in hex
    pusha
    mov cx, 4
.next_digit:
    rol ax, 4
    mov bl, al
    and bl, 0x0F
    add bl, '0'
    cmp bl, '9'
    jbe .output
    add bl, 7
.output:
    mov ah, 0x0E
    mov al, bl
    int 0x10
    loop .next_digit
    popa
    ret

; Bootloader padding
times 510-($-$$) db 0
dw 0xAA55               ; Boot signature

section .data
welcome_msg db 'Welcome to SpringOS!', 0
prompt_msg db 'SpringOS> ', 0
help_msg db 'Commands: help, ls, cat, sysinfo', 0
ls_msg db 'Listing files... (not yet implemented)', 0
cat_msg db 'Displaying file... (not yet implemented)', 0
sysinfo_msg db 'System Information:', 0
unknown_msg db 'Unknown command. Try again.', 0
mem_msg db 'Memory Available: ', 0
status_msg db 'System Status: All systems go!', 0
multitask_msg db 'Multitasking initialized.', 0
filesystem_msg db 'FAT12 Filesystem initialized.', 0

section .bss
input_buffer resb 128
