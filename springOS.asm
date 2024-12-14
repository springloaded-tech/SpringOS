   ; SpringOS: Minimal OS in Assembly, inspired by Linux.
        ; Target size: Under 5MB.
        ; Created by Tyshaun, SpringLoaded Tech.

        ; Bootloader Code
        ; ----------------
        ; Set up system environment and load kernel from disk.

        org 0x7C00           ; BIOS loads boot sector here.
        mov ax, 0x07C0       ; Set up stack.
        mov ss, ax
        mov sp, 0xFFFF

        ; Print welcome message.
        lea si, welcome_msg
        call print_string

        ; Load kernel into memory.
        mov bx, 0x0800       ; Load kernel at 0x0800:0000.
        call load_kernel

        ; Jump to kernel.
        jmp 0x0800:0000

welcome_msg db 'Welcome to SpringOS, a minimal Linux-like OS!', 0

; Disk loading function
load_kernel:
        ; Implement BIOS disk interrupt to load kernel sectors into memory.
        mov ah, 0x02        ; BIOS Read Sectors function.
        mov al, 0x10        ; Number of sectors to read.
        mov ch, 0           ; Cylinder number.
        mov cl, 2           ; Start reading from second sector.
        mov dh, 0           ; Head number.
        mov dl, 0           ; Drive number (first floppy).
        int 0x13            ; BIOS interrupt.
        jc disk_error       ; Jump if carry flag is set (error).
        ret

disk_error:
        lea si, disk_error_msg
        call print_string
        cli                 ; Disable interrupts.
        hlt                 ; Halt CPU.

disk_error_msg db 'Disk load error. System halted.', 0

; Print string function
print_string:
        ; Print a null-terminated string to the screen.
        mov ah, 0x0E        ; BIOS Teletype Output function.
.print_next_char:
        lodsb               ; Load next byte from SI.
        or al, al           ; Check if null terminator.
        jz .done
        int 0x10            ; Print character.
        jmp .print_next_char
.done:
        ret

; Kernel Code (To be loaded at 0x0800:0000)
; -----------------------------------------
        org 0x0000          ; Start of kernel.

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

        times 510-($-$$) db 0 ; Pad to 512 bytes (boot sector size).
        dw 0xAA55             ; Boot sector signature.
