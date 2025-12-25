all:
	riscv64-unknown-linux-gnu-gcc \
    -march=rv32im -mabi=ilp32 \
    -ffreestanding -nostdlib -nostartfiles \
    -T link.ld \
    parking_baremetal.c \
    -S -o parking_baremetal.S
	riscv64-unknown-linux-gnu-gcc \
    -march=rv32im -mabi=ilp32 \
    -ffreestanding -nostdlib -nostartfiles \
    -T link.ld \
    start.S parking_baremetal.c \
	-o parking_baremetal.elf
	riscv64-unknown-linux-gnu-objcopy -O binary parking_baremetal.elf parking.bin
	riscv64-unknown-linux-gnu-objdump -D -m riscv:rv32 --adjust-vma=0x0 parking_baremetal.elf > parking.dis.S
	cat parking.dis.S | awk -F'\t' '{print $2}' > parking.dis.hex
