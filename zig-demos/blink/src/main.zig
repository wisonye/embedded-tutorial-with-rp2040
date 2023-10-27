pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
    @cInclude("pico/cyw43_arch.h");
});
const std = @import("std");

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();

    _ = c.printf("\n>>> [ Zig blinking onboard LED ]");

    if (c.cyw43_arch_init() != 0) {
        return -1;
    }

    while (true) {
        c.cyw43_arch_gpio_put(c.CYW43_WL_GPIO_LED_PIN, true);
        c.sleep_ms(250);
        c.cyw43_arch_gpio_put(c.CYW43_WL_GPIO_LED_PIN, false);
        c.sleep_ms(250);
    }
}
