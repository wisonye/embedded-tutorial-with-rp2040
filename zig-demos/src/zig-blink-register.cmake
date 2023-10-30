#
# There is NO source file list here, as `src/main.zig` will be compiled as an
# `.obj` file and link to the final executable!!!
#
add_executable(zig-blink-register)

#
# Add library which aggregates commonly used features
#
target_link_libraries(zig-blink-register
#
# pico_stdlib - pico standard library, core functionality
#
pico_stdlib
#
# The compiled zig obj file, the filename comes from `b.addInstallFile(compiled, "xxx.o");`
# in `build.zig`.
#
"${CMAKE_SOURCE_DIR}/zig-out/zig-blink-register.o"
)

#
# create map/bin/hex/uf2 file in addition to ELF.
#
pico_add_extra_outputs(zig-blink-register)

#
# Solved the `printf` content lost after `stdio_init_all();`
#
target_compile_definitions(
    zig-blink-register
    PRIVATE
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=-1
    ENABLE_DEBUG_LOG
)

#
# Enalbe serial port on USB per target
#
pico_enable_stdio_usb(zig-blink-register 1)
pico_enable_stdio_uart(zig-blink-register 0)
