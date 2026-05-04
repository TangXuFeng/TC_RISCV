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

set(COMMON_FLAGS "-march=${RISCV_ARCH} -mabi=${RISCV_ABI} -ffreestanding -O3 -g")

set(CMAKE_C_FLAGS   "${COMMON_FLAGS}")
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS}")

add_executable(kernel.elf
    startup.S
    kernel.c
)

target_link_options(kernel.elf PRIVATE
    -nostdlib
    -nostartfiles
    -static
    -Wl,--gc-sections
)
