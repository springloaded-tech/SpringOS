; boot.asm - bootloader
[bits 16]
[org 0x7C00]

section .text
global _start

_start:
    ; Set up segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Display welcome message
    mov si, welcome_msg
    call print_string

    ; Load kernel
    call load_kernel

    ; Jump to kernel
    jmp 0x0800:0000

load_kernel:
    mov ax, 0x0800  ; Segment where the kernel will be loaded
    mov es, ax
    xor bx, bx      ; Offset 0x0000
    mov ah, 0x02    ; BIOS read sectors function
    mov al, 16      ; Read 16 sectors (8 KB)
    mov ch, 0       ; Cylinder 0
    mov cl, 2       ; Start from sector 2
    mov dh, 0       ; Head 0
    mov dl, 0x80    ; Boot drive (usually 0x80 for hard disk)
    int 0x13        ; BIOS interrupt
    jc disk_error
    ret

disk_error:
    mov si, error_msg
    call print_string
    jmp $

print_string:
    mov ah, 0x0E    ; BIOS teletype function
.next_char:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .next_char
.done:
    ret

section .data
welcome_msg db 'SpringOS Bootloader', 13, 10, 0
error_msg db 'Disk error!', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
