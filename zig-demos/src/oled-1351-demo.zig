pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");
const SSD1351 = @import("./utils/driver/oled/ssd1351.zig").SSD1351;

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();

    _ = c.printf("\n>>> [ OLED 1351 Demo ]");

    const oled = SSD1351.init(null);
    _ = oled;

    while (true) {
        c.sleep_ms(10);
    }
}
