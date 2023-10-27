cmake_minimum_required(VERSION 3.27)

#
# initialize the SDK directly
#
include(${PICO_SDK_PATH}/external/pico_sdk_import.cmake)

#
# Generate `compile_commands.json` for `Neovim` LSP needed
#
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

project(zig-blink)

#
# initialize the Raspberry Pi Pico SDK
#
pico_sdk_init()

#
# There is NO source file list here, as `src/main.zig` will be compiled as an
# `.obj` file and link to the final executable!!!
#
add_executable(${PROJECT_NAME})

#
# Solve the "`<stdio.h>` file not found" issue
#
if (CMAKE_EXPORT_COMPILE_COMMANDS)
    set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
endif()


#
# Add library which aggregates commonly used features
#
target_link_libraries(${PROJECT_NAME}
#
# pico_stdlib - pico standard library, core functionality
#
pico_stdlib
#
# pico_cyw43_arch_none  - WIFI support
# pico_cyw43_arch_lwip_threadsafe_background - WIFI support (TCP/IP)
#
pico_cyw43_arch_none 
#
# The compiled zig obj file, the filename comes from `b.addInstallFile(compiled, "xxx.o");`
# in `build.zig`. Better to have the same name with ${PROJECT_NAME} for convenient.
#
"${CMAKE_SOURCE_DIR}/zig-out/${PROJECT_NAME}.o"
)

#
# create map/bin/hex/uf2 file in addition to ELF.
#
pico_add_extra_outputs(${PROJECT_NAME})

# #
# # Solved the `printf` content lost after `stdio_init_all();`
# #
# target_compile_definitions(
#     ${PROJECT_NAME}
#     PRIVATE
#     PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=-1
#     ENABLE_DEBUG_LOG
# )

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
