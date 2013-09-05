a3: a3.o io.o
	ld -o a3 -melf_i386 a3.o io.o
a3.o: a3.asm
	nasm -f elf a3.asm
