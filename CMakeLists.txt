cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(TC_RISCV_SuperBuild 
    VERSION 0.1
    DESCRIPTION "游戏图灵完备的RISC-V处理器硬件和软件超级项目"
    HOMEPAGE_URL "https://github.com/TangXuFeng/TC_RISCV"
    LANGUAGES C ASM
)

# ============================================================================
# 全局 CMake 配置
# ============================================================================

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 外部项目构建目录
set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR}/subprojects)

# 输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# ============================================================================
# ExternalProject 模块
# ============================================================================

include(ExternalProject)

# ============================================================================
# host_tools 子项目（本机 gcc/g++）
# ============================================================================

ExternalProject_Add(host_tools_project
    SOURCE_DIR
        ${CMAKE_CURRENT_LIST_DIR}/host_tools
    BINARY_DIR
        ${CMAKE_BINARY_DIR}/subprojects/host_tools-build
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_C_COMPILER=gcc
        -DCMAKE_CXX_COMPILER=g++
        -DCMAKE_C_STANDARD=11
        -DCMAKE_CXX_STANDARD=17
    CMAKE_CACHE_ARGS
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
    BUILD_COMMAND
        ${CMAKE_COMMAND} --build . &&
        ${CMAKE_COMMAND} -E copy
            ${CMAKE_BINARY_DIR}/subprojects/host_tools-build/hello
            ${CMAKE_BINARY_DIR}/hello
    INSTALL_COMMAND
        ""
    BUILD_ALWAYS
        0
)

# ============================================================================
# RISC-V 工具链配置
# ============================================================================

set(RISCV_ARCH "rv32im" CACHE STRING "RISC-V architecture (e.g., rv32i, rv32im)")
set(RISCV_ABI  "ilp32"  CACHE STRING "RISC-V ABI (e.g., ilp32, ilp32d)")

# 工具链前缀（名字），仍然允许用户改
set(RISCV_CROSS_COMPILE "riscv64-unknown-linux-gnu-" CACHE STRING "RISC-V cross compiler prefix")

# 用 find_program 把它们解析成绝对路径
find_program(RISCV_GCC
    NAMES ${RISCV_CROSS_COMPILE}gcc
)
find_program(RISCV_OBJCOPY
    NAMES ${RISCV_CROSS_COMPILE}objcopy
)
find_program(RISCV_OBJDUMP
    NAMES ${RISCV_CROSS_COMPILE}objdump
)

if(NOT RISCV_GCC OR NOT RISCV_OBJCOPY OR NOT RISCV_OBJDUMP)
    message(FATAL_ERROR "RISC-V toolchain not found for prefix: ${RISCV_CROSS_COMPILE}")
endif()

message(STATUS "✓ RISC-V GCC     : ${RISCV_GCC}")
message(STATUS "✓ RISC-V OBJCOPY : ${RISCV_OBJCOPY}")
message(STATUS "✓ RISC-V OBJDUMP : ${RISCV_OBJDUMP}")

# ============================================================================
# RISC-V 子项目（使用 RISC-V 工具链）
# ============================================================================

ExternalProject_Add(riscv_project
    SOURCE_DIR
        ${CMAKE_CURRENT_LIST_DIR}/riscv
    BINARY_DIR
        ${CMAKE_BINARY_DIR}/subprojects/riscv-build
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_C_COMPILER=${RISCV_GCC}
        -DCMAKE_OBJCOPY=${RISCV_OBJCOPY}
        -DCMAKE_OBJDUMP=${RISCV_OBJDUMP}
        -DCMAKE_C_STANDARD=11
        -DRISCV_ARCH=${RISCV_ARCH}
        -DRISCV_ABI=${RISCV_ABI}
    CMAKE_CACHE_ARGS
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    BUILD_COMMAND
        ${CMAKE_COMMAND} --build . &&
        ${CMAKE_COMMAND} -E copy
            ${CMAKE_BINARY_DIR}/subprojects/riscv-build/kernel.elf
            ${CMAKE_BINARY_DIR}/kernel.elf &&
        ${CMAKE_COMMAND} -E copy
            ${CMAKE_BINARY_DIR}/subprojects/riscv-build/kernel.bin
            ${CMAKE_BINARY_DIR}/kernel.bin
    INSTALL_COMMAND
        ""
    BUILD_ALWAYS
        0
)
