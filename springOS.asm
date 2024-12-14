   ; SpringOS: Minimal OS in Assembly, inspired by Linux.
        ; Target size: Under 5MB.
        ; Created by Tyshaun, SpringLoaded Tech.

        ; Bootloader Code
        ; ----------------
        ; Set up system environment and load kernel from disk.

section .text
    global start_kernel

start_kernel:
    ; Initialize multitasking (basic round-robin scheduler).
    call init_multitasking

    ; Initialize filesystem (simple FAT12 handler).
    call init_filesystem

    ; Start command-line interface (CLI).
    call start_cli

    ; Halt CPU when CLI exits.
    cli
    hlt

init_multitasking:
    ; Placeholder for multitasking initialization.
    ; Load task list, set up scheduler, etc.
    ret

init_filesystem:
    ; Placeholder for filesystem initialization.
    ; Implement FAT12 read/write support.
    ret

start_cli:
    ; Basic command-line interface.
.cli_loop:
    lea si, prompt_msg
    call print_string
    call read_input      ; Read user command.
    call execute_command ; Execute the command.
    jmp .cli_loop

prompt_msg db 'SpringOS> ', 0

read_input:
    ; Read user input into a buffer.
    mov ah, 0x0A        ; BIOS Input function.
    lea dx, input_buffer
    int 0x21            ; Read input.
    ret

input_buffer db 128, 0      ; Max 128 bytes, initialize to 0.

execute_command:
    ; Parse and execute basic commands (e.g., ls, cat).
    lea si, input_buffer + 1 ; Skip length byte.
    cmp byte [si], 'l'  ; Check if command is 'ls'.
    je .run_ls
    cmp byte [si], 'c'  ; Check if command is 'cat'.
    je .run_cat
    jmp .unknown_command

.run_ls:
    lea si, ls_msg
    call print_string
    ret

.run_cat:
    lea si, cat_msg
    call print_string
    ret

.unknown_command:
    lea si, unknown_msg
    call print_string
    ret

ls_msg db 'Executing ls: Listing files...', 0
cat_msg db 'Executing cat: Displaying file contents...', 0
unknown_msg db 'Unknown command. Try again.', 0

; Utility function to print strings
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

section .bss
    resb 512             ; Reserve space for kernel stack

section .data
prompt_msg db 'SpringOS> ', 0
error_msg db 'Error occurred!', 0
ls_msg db 'Executing ls: Listing files...', 0
cat_msg db 'Executing cat: Displaying file contents...', 0
unknown_msg db 'Unknown command. Try again.', 0

