[bits 16]
[org 0x7C00]

; Include the bootloader
%include "boot.asm"

; Pad to 512 bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55

; Include the kernel right after the bootloader
%include "springOS.asm"
