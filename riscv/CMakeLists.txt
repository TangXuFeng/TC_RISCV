cmake_minimum_required(VERSION 3.20)
project(riscv_kernel C)

message(STATUS "RISC-V ARCH = ${RISCV_ARCH}")
message(STATUS "RISC-V ABI  = ${RISCV_ABI}")
message(STATUS "C COMPILER  = ${CMAKE_C_COMPILER}")
message(STATUS "OBJCOPY     = ${CMAKE_OBJCOPY}")
message(STATUS "OBJDUMP     = ${CMAKE_OBJDUMP}")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_executable(kernel.elf kernel.c)

# 编译阶段
target_compile_options(kernel.elf PRIVATE
    -march=${RISCV_ARCH}
    -mabi=${RISCV_ABI}
    -O3
    -g
    -ffreestanding
)

# 链接阶段（关键：和 Makefile 一致）
target_link_options(kernel.elf PRIVATE
    -march=${RISCV_ARCH}
    -mabi=${RISCV_ABI}
    -nostdlib
    -nostartfiles
    -ffreestanding
    -static
)

# 生成 kernel.bin
add_custom_command(
    OUTPUT kernel.bin
    COMMAND ${CMAKE_OBJCOPY} -O binary kernel.elf kernel.bin
    DEPENDS kernel.elf
    COMMENT "Generating kernel.bin"
)

add_custom_target(bin ALL DEPENDS kernel.bin)

# 可选：dump
add_custom_target(dump
    COMMAND ${CMAKE_OBJDUMP} -D -b binary -m riscv:${RISCV_ARCH} --adjust-vma=0x0 kernel.bin
    DEPENDS kernel.bin
    COMMENT "Dumping kernel.bin"
)
