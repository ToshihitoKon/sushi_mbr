sushi: asm/sushi.asm
	nasm -f bin asm/sushi.asm -o bin/sushi.bin

run: bin/sushi.bin
	qemu-system-x86_64 bin/sushi.bin
 
