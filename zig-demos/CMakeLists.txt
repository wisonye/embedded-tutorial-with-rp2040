cmake_minimum_required(VERSION 3.27)

#
# initialize the SDK directly
#
include(${PICO_SDK_PATH}/external/pico_sdk_import.cmake)

#
# Generate `compile_commands.json` for `Neovim` LSP needed
#
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

project(zig-embedded-demos)

#
# initialize the Raspberry Pi Pico SDK
#
pico_sdk_init()

#
# Solve the "`<stdio.h>` file not found" issue
#
if (CMAKE_EXPORT_COMPILE_COMMANDS)
    set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

#
# Add sub `CMakeLists.txt`
#
include(src/zig-blink-builtin-led.cmake)
include(src/zig-blink-register.cmake)
include(src/touch-switch-button-demo.cmake)
include(src/ps-joystick-demo.cmake)

#
# Debug log
#
message(">>> CMAKE_EXPORT_COMPILE_COMMANDS: ${CMAKE_EXPORT_COMPILE_COMMANDS}")
message(">>> CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message(">>> CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message(">>> CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(">>> CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(">>> CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
message(">>> CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
message(">>> CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
message(">>> CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(">>> CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")
message(">>> CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES: ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}")
message(">>> CMAKE_C_STANDARD_INCLUDE_DIRECTORIES: ${CMAKE_C_STANDARD_INCLUDE_DIRECTORIES}")
message(">>> PICO_SDK_PATH: ${PICO_SDK_PATH}")
message(">>> PICO_PLATFORM: ${PICO_PLATFORM}")
message(">>> PICO_BOARD: ${PICO_BOARD}")
message(">>> PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS: ${PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS}")
message(">>> PROJECT_NAME: ${PROJECT_NAME}")
