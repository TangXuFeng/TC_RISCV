cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(TC_RISCV_SuperBuild 
    VERSION 0.1
    DESCRIPTION "游戏图灵完备的RISC-V处理器硬件和软件超级项目"
    HOMEPAGE_URL "https://github.com/TangXuFeng/TC_RISCV"
)
enable_language(C)
enable_language(ASM)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_BUILD_RPATH "\$ORIGIN")
set(CMAKE_INSTALL_RPATH "\$ORIGIN")
set(CMAKE_SKIP_BUILD_RPATH ON)
set(CMAKE_SKIP_INSTALL_RPATH OFF)
set(CMAKE_BUILD_WITH_INSTALL_RPATH OFF)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 启用ccache
option(USE_CCACHE "Enable ccache" ON)
if (USE_CCACHE)
    find_program(CCACHE_PROGRAM ccache)
    if (CCACHE_PROGRAM)
        set(CMAKE_C_COMPILER_LAUNCHER   ${CCACHE_PROGRAM})
        set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
    endif()
endif()


add_subdirectory(tools)
add_subdirectory(riscv)


add_custom_target(runhello ALL
    COMMAND $<TARGET_FILE:hello>
    DEPENDS $<TARGET_FILE:hello>
)
