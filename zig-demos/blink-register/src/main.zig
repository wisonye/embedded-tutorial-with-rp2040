pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");

const LED_PIN = 0;

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();

    _ = c.printf("\n>>> [ Zig blinking LED on GPIO_0 pin ]");

    c.gpio_init(LED_PIN);
    c.gpio_set_dir(LED_PIN, true);

    while (true) {
        c.gpio_put(LED_PIN, true);
        c.sleep_ms(250);
        c.gpio_put(LED_PIN, false);
        c.sleep_ms(250);
    }
}
