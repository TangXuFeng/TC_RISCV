cmake_minimum_required(VERSION 3.16)
project(kernel C ASM)

set(CMAKE_SYSTEM_NAME Generic)

# 统一使用裸机工具链
set(RISCV_PREFIX riscv64-unknown-elf)

set(CMAKE_C_COMPILER   ${RISCV_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${RISCV_PREFIX}-g++)
set(CMAKE_ASM_COMPILER ${RISCV_PREFIX}-gcc)
set(CMAKE_OBJCOPY      ${RISCV_PREFIX}-objcopy)
set(CMAKE_OBJDUMP      ${RISCV_PREFIX}-objdump)

# RISC-V 架构参数
set(RISCV_ARCH "rv32im")
set(RISCV_ABI  "ilp32")

set(COMMON_FLAGS "-march=${RISCV_ARCH} -mabi=${RISCV_ABI} -fPIC -ffreestanding -O0 -g")

set(CMAKE_C_FLAGS   "${COMMON_FLAGS}")
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS}")

add_executable(kernel.elf
    startup.S
    kernel.c
)

target_link_options(kernel.elf PRIVATE
    -fPIC
    -nostdlib
    -nostartfiles
    -static
    -Wl,--gc-sections
    -Wl,--build-id=none
)

add_custom_command(
    OUTPUT kernel.bin
    COMMAND ${CMAKE_OBJCOPY} -O binary kernel.elf kernel.bin
    DEPENDS kernel.elf
)

add_custom_target(kernel_bin ALL
    DEPENDS kernel.bin
)



add_custom_command(
    OUTPUT kernel.dump
    COMMAND ${CMAKE_OBJDUMP} -D -b binary -m riscv:rv32 --adjust-vma=0x0 kernel.bin > kernel.dump
    DEPENDS kernel.bin
    COMMENT "Dumping kernel.bin"
)

add_custom_target(dump ALL
    DEPENDS kernel.dump
)


