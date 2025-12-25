# GodOS
GodOS: Это ОС создана на ассамблере которая вдохвлена богом. Там есть кликер, молитва, и многие другие игры!

Чтобы запустить ОС надо QEMI
1 команда (Linux): nasm -f elf32 loader.asm -o loader.o
nasm -f elf32 kernel.asm -o kernel.o
2 команда(Linux): ld -m elf_i386 -T linker.ld -o kernel.bin loader.o kernel.o
3 команда(Linux): qemu-system-i386 -kernel kernel.bin
qemi (Ubuntu Debian): sudo apt install nasm qemu-system-x86
