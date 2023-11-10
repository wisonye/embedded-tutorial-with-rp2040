#
# There is NO source file list here, as `src/main.zig` will be compiled as an
# `.obj` file and link to the final executable!!!
#
add_executable(oled-1351-demo)

#
# Add library which aggregates commonly used features
#
target_link_libraries(oled-1351-demo
#
# pico_stdlib - pico standard library, core functionality
#
pico_stdlib
hardware_spi
hardware_dma
#
# The compiled zig obj file, the filename comes from `b.addInstallFile(compiled, "xxx.o");`
# in `build.zig`.
#
"${CMAKE_SOURCE_DIR}/zig-out/oled-1351-demo.o"
)

#
# create map/bin/hex/uf2 file in addition to ELF.
#
pico_add_extra_outputs(oled-1351-demo)

#
# Solved the `printf` content lost after `stdio_init_all();`
#
target_compile_definitions(
    oled-1351-demo
    PRIVATE
    PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=-1
    ENABLE_DEBUG_LOG
)

#
# Enalbe serial port on USB per target
#
pico_enable_stdio_usb(oled-1351-demo 1)
pico_enable_stdio_uart(oled-1351-demo 0)

#
# Floating-point support
#
pico_set_float_implementation(oled-1351-demo "pico")
