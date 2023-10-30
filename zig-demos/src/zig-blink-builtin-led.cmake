#
# There is NO source file list here, as `src/main.zig` will be compiled as an
# `.obj` file and link to the final executable!!!
#
add_executable(zig-blink-builtin-led)

#
# Add library which aggregates commonly used features
#
target_link_libraries(zig-blink-builtin-led
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
# in `build.zig`.
#
"${CMAKE_SOURCE_DIR}/zig-out/zig-blink-builtin-led.o"
)

#
# create map/bin/hex/uf2 file in addition to ELF.
#
pico_add_extra_outputs(zig-blink-builtin-led)

# #
# # Solved the `printf` content lost after `stdio_init_all();`
# #
# target_compile_definitions(
#     zig-blink-builtin-led
#     PRIVATE
#     PICO_STDIO_USB_CONNECT_WAIT_TIMEOUT_MS=-1
#     ENABLE_DEBUG_LOG
# )

#
# Enalbe serial port on USB per target
#
pico_enable_stdio_usb(zig-blink-builtin-led 1)
pico_enable_stdio_uart(zig-blink-builtin-led 0)
