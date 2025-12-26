[BITS 32]
section .multiboot

header_start:
    dd 0x1BADB002       ; magic
    dd 0x00             ; flags
    dd -(0x1BADB002 + 0x00) ; checksum
header_end:

[GLOBAL start]
[EXTERN kmain]

section .text
start:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:kmain      

gdt_start:
    dq 0x0
gdt_code:
    dw 0xffff, 0x0, 0x9a00, 0x00cf
gdt_data:
    dw 0xffff, 0x0, 0x9200, 0x00cf
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start
