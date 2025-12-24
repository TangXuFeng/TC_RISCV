CROSS = riscv64-unknown-elf-
CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib -ffreestanding

all:
	@echo system:gentoo, crossdev -t riscv64-unknown-elf --ex-gdb
	$(CROSS)gcc $(CFLAGS) -T link.ld start.S main.c -o test.elf

clean:
	rm -f test.elf
	
run:
	qemu-system-riscv32 -machine virt -nographic -bios none -kernel test.elf
