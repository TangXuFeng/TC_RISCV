all:
	riscv64-unknown-linux-gnu-gcc \
    -march=rv32im -mabi=ilp32 \
    -ffreestanding -nostdlib -nostartfiles \
    -T link.ld \
    start.S\
    -S -o b.S
	riscv64-unknown-linux-gnu-gcc \
    -march=rv32im -mabi=ilp32 \
    -ffreestanding -nostdlib -nostartfiles \
    -T link.ld \
    start.S \
	-o start.elf
	riscv64-unknown-linux-gnu-objcopy -O binary start.elf start.bin
	riscv64-unknown-linux-gnu-objdump -D -m riscv:rv32 --adjust-vma=0x0 start.elf > start.dis.S
	gcc bin2hex.c -o hex2bin
	./hex2bin start.bin > start.hex
