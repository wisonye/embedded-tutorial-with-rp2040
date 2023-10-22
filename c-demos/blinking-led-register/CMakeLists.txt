cmake_minimum_required(VERSION 3.13)

#
# initialize the SDK directly
#
# include(~/pico/pico-sdk/pico_sdk_init.cmake)
include(pico_sdk_import.cmake)

#
# Generate `compile_commands.json` for `Neovim` LSP needed
#
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

# set(CMAKE_C_FLAGS "-pedantic-errors -std=gnu17")
# set(CMAKE_C_FLAGS "-std=gnu17")

project(blinking-led-register)

#
# initialize the Raspberry Pi Pico SDK
#
pico_sdk_init()

add_executable(${PROJECT_NAME}
src/register/reset.c
src/blinking-led.c
)


#
# Solve the "`<stdio.h>` file not found" issue
#
if (CMAKE_EXPORT_COMPILE_COMMANDS)
    set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
endif()


#
# Add library which aggregates commonly used features
#
# pico_stdlib - pico standard library, core functionality
#
target_link_libraries(${PROJECT_NAME} pico_stdlib)

#
# Solved the `printf` content lost after `stdio_init_all();`
#
target_compile_definitions(
    ${PROJECT_NAME}
    PRIVATE
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=-1
    ENABLE_DEBUG_LOG
)

#
# create map/bin/hex/uf2 file in addition to ELF.
#
pico_add_extra_outputs(${PROJECT_NAME})

#
# Enalbe serial port on USB per target 
#
pico_enable_stdio_usb(${PROJECT_NAME} 1)
pico_enable_stdio_uart(${PROJECT_NAME} 0)

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
# message(">>> ARM_STDLIB_INCLUDE: $ENV{ARM_STDLIB_INCLUDE}")
