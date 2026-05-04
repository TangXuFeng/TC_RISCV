cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(TC_RISCV_SuperBuild 
    VERSION 0.1
    DESCRIPTION "游戏图灵完备的RISC-V处理器硬件和软件超级项目"
    HOMEPAGE_URL "https://github.com/TangXuFeng/TC_RISCV"
)
enable_language(C)
enable_language(ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_EXTENSIONS ON) 
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_SKIP_BUILD_RPATH ON)
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF)

set(CMAKE_VERBOSE_MAKEFILE ON)


set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


add_subdirectory(tools)
add_subdirectory(riscv)


