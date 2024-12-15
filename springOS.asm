; springOS.asm - kernel for SpringOS

[bits 16]
[org 0x8000]

section .text
global _start

_start:
    ; Set up segments
    mov ax, 0x0800
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0xFFFE

    ; Initialize system
    call init_video
    call init_interrupts

    ; Start command-line interface
    call start_cli

    ; Halt if CLI exits
    cli
    hlt

init_video:
    mov ax, 0x0003  ; 80x25 text mode
    int 0x10
    ret

init_interrupts:
    ; Set up basic interrupt handler
    mov ax, 0
    mov es, ax
    mov word [es:0x21*4], keyboard_handler
    mov word [es:0x21*4+2], 0x0800
    ret

keyboard_handler:
    ; Basic keyboard handler
    in al, 0x60     ; Read scan code
    iret

start_cli:
    mov si, welcome_msg
    call print_string

.cli_loop:
    mov si, prompt
    call print_string
    call read_input
    call execute_command
    jmp .cli_loop

read_input:
    mov di, input_buffer
    xor cx, cx
.read_char:
    mov ah, 0
    int 0x16
    cmp al, 13  ; Enter key
    je .done
    stosb
    inc cx
    mov ah, 0x0E
    int 0x10
    jmp .read_char
.done:
    mov byte [di], 0
    ret

execute_command:
    mov si, input_buffer
    call str_to_lower
    cmp byte [si], 'h'
    je .help
    cmp byte [si], 'e'
    je .exit
    cmp byte [si], 's'
    je .sysinfo
    jmp .unknown

.help:
    mov si, help_msg
    jmp .print_and_return

.exit:
    mov si, exit_msg
    call print_string
    ret

.sysinfo:
    call display_sysinfo
    jmp .return

.unknown:
    mov si, unknown_msg

.print_and_return:
    call print_string

.return:
    ret

display_sysinfo:
    mov si, sysinfo_msg
    call print_string
    call memory_check
    ret

memory_check:
    mov ah, 0x88
    int 0x15
    mov si, mem_msg
    call print_string
    mov ax, cx
    call print_hex
    ret

print_string:
    mov ah, 0x0E
.next_char:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .next_char
.done:
    ret

print_hex:
    push ax
    mov cx, 4
.next_digit:
    rol ax, 4
    mov dl, al
    and dl, 0x0F
    add dl, '0'
    cmp dl, '9'
    jbe .print
    add dl, 7
.print:
    mov ah, 0x0E
    mov al, dl
    int 0x10
    loop .next_digit
    pop ax
    ret

str_to_lower:
    push si
.loop:
    lodsb
    or al, al
    jz .done
    cmp al, 'A'
    jb .next
    cmp al, 'Z'
    ja .next
    add al, 32
    mov [si-1], al
.next:
    jmp .loop
.done:
    pop si
    ret

section .data
welcome_msg db 'Welcome to SpringOS!', 13, 10, 0
prompt db 'SpringOS> ', 0
help_msg db 'Commands: help, exit, sysinfo', 13, 10, 0
exit_msg db 'Exiting SpringOS...', 13, 10, 0
unknown_msg db 'Unknown command. Type "help" for a list of commands.', 13, 10, 0
sysinfo_msg db 'System Information:', 13, 10, 0
mem_msg db 'Available memory: ', 0

section .bss
input_buffer resb 256
