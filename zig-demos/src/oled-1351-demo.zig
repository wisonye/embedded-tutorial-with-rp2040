pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");
const SSD1351 = @import("./utils/driver/oled/ssd1351.zig").SSD1351;
const SPI1 = @import("./utils/driver/oled/ssd1351.zig").spi1;

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();

    _ = c.printf("\n>>> [ OLED 1351 Demo ]");

    const oled = SSD1351.init(null);
    // const oled = SSD1351.init(.{
    //     .show_fps = true,
    //     .fps_color = 0xE4F5,
    //     .spi_group = SPI1,
    //     .spi_baudrate = 9600,
    //     .data_and_command_pin = 1,
    //     .reset_pin = 2,
    //     .spi_clock_pin = 6,
    //     .spi_tx_pin = 7,
    // });
    _ = oled;

    while (true) {
        c.sleep_ms(10);
    }
}
