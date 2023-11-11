//!
//! How to use it
//!
//! 1. Call `init()`
//!
//! 2. The implementation uses DMA to simulate the `double-buffers`:
//!
//! - One for display the current frame (finish drawing).
//! - One for working on the next frame and flipping it when it's done.
//!
//! So, here are the steps for rendering each frame:
//!
//! A. `clear()`
//!
//! B. Call any following functions to draw on the current
//!
//!     fill_colour(BT_FrontBuffer, ...);
//!     draw_pixel(BT_FrontBuffer, ...);
//!     draw_line(BT_FrontBuffer, ...);
//!     draw_rectangle(BT_FrontBuffer, ...);
//!     draw_circle(BT_FrontBuffer, ...);
//!     draw_triangle(BT_FrontBuffer, ...);
//!
//! C. Call `refresh()` when finishing the drawing of the entire frame.
//!
//!     It calls `ssd1351_flush_dma` and switches the buffer internally.
//!     DMA transfers happen asynchronously in the background and most
//!     of the time the next frame will be ready before the first frame
//!     has been fully transferred.
//!
const std = @import("std");
const build_options = @import("build_options");
const print = std.debug.print;
const font_12x16 = @import("font12x16.h");
const font_16x16 = @import("font16x16.h");
const font_8x8 = @import("font8x8_basic.h");
const font_8x8_topaz = @import("font8x8_topaz.h");

const c = @cImport({
    @cInclude("hardware/dma.h");
    @cInclude("hardware/spi.h");
    @cInclude("pico/binary_info.h");
    @cInclude("pico/stdlib.h");
    @cInclude("math.h");
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("string.h");
});

// -----------------------------------------------------------------------------------
//
// zig-translate causes the following compile error:
//
// error: C pointers cannot point to opaque types
// pub const spi0 = @import("std").zig.c_translation.cast([*c]spi_inst_t, spi0_hw);
//
//
// That's why I have to add the following `handmake-translated` code:
//
// pub const spi_hw_t = extern struct {
//     cr0: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
//     cr1: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
//     dr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
//     sr: io_ro_32 = @import("std").mem.zeroes(io_ro_32),
//     cpsr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
//     imsc: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
//     ris: io_ro_32 = @import("std").mem.zeroes(io_ro_32),
//     mis: io_ro_32 = @import("std").mem.zeroes(io_ro_32),
//     icr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
//     dmacr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
// };
pub const spi0_hw: [*c]c.spi_hw_t = @ptrFromInt(c.SPI0_BASE);
pub const spi1_hw: [*c]c.spi_hw_t = @ptrFromInt(c.SPI1_BASE);
pub const spi0 = spi0_hw;
pub const spi1 = spi1_hw;
// -----------------------------------------------------------------------------------

const SSD1351_DEFAULT_SPI_GROUP = spi0; // SPI Group, either SPI0 or SPI1

// -----------------------------------------------------------------------------------
//
// SSD1351 OLED 128×128 pins:
//
// GND: Ground pin
//
// VCC: +3.3v pin
//
// SCL: SPI Clock, connect to PICO's SPI_SCK
//
// SDA: SPI Data, connect to PICO's SPI_TX (MOSI)
//
// RES: Reset pin, connect to any GPIO OUTPUT pin, set low to reset
//
// DC:  Data / Command pin, connect to any GPIO OUTPUT pin.
//      set low for a command being sent and high for data being sent
//
// CS:  Chip select pin, short to ground, otherwise, it ingores the data!!!
//
const SSD1351_DEFAULT_DATA_COMMAND_PIN = 21;
const SSD1351_DEFAULT_RESET_PIN = 20;
const SSD1351_DEFAULT_SPI_CLOCK_PIN = 18;
const SSD1351_DEFAULT_SPI_TX_PIN = 19;
// -----------------------------------------------------------------------------------

///
/// SSD1351 OLED 128×128 pixels, 1.5″ in size.
///
/// By default, it's 16 bits (2bytes) per pixel for colour, colour format is
/// `RGB565` (5 bits for red, 6 bits for green and 5 bits for blue).
///
/// That's why a full frame is 128x128x2 bytes = 32KB.
///
const SCREEN_HEIGHT = 128;
const SCREEN_WIDTH = 128;

///
/// Set SPI baudrate to `20MHz` (`spi_init` access unit in `Hz`).
///
/// Theoretically, We can do 76 PFS for a 32KB frame (pixels)in theory, but the
/// reality you need to consider some overhead like sending commands, so you
/// can't reach that speed, but it is stll fast enough.
///
const SSD1351_DEFAULT_SPI_SPEED = 20000000;

///
///
///
pub const SSD1351 = struct {
    ///
    ///
    ///
    const ScrollDirection = enum {
        Left,
        Right,
        Up,
        Down,
    };

    ///
    ///
    ///
    const BufferType = enum {
        FrontBuffer,
        ScrollBuffer,
    };

    ///
    ///
    ///
    const WriteType = enum(u8) { WriteCommand = 0, WriteData = 1 };

    ///
    ///
    ///
    const SSDCommand = enum(u8) {
        SetColumn = 0x15,
        WriteRam = 0x5C,
        ReadRam = 0x5D,
        SetRow = 0x75,
        Scroll_setup = 0x96,
        Scroll_start = 0x9E,
        Scroll_stop = 0x9F,
        SetRemap = 0xA0,
        StartLine = 0xA1,
        DisplayOffset = 0xA2,
        PixelsOff = 0xA4, // All off
        PixelsOn = 0xA5, // All on
        NonInvert = 0xA6,
        Invert = 0xA7,
        FunctionSel = 0xAB,
        DisplayOff = 0xAE,
        DisplayOn = 0xAF,
        Precharge = 0xB1,
        Enhance = 0xB2,
        ClockDiv = 0xB3,
        SetVsl = 0xB4,
        SetGpio = 0xB5,
        Precharge2 = 0xB6,
        Gamma_table = 0xB8,
        Reset_gamma = 0xB9,
        PrechargeV = 0xBB,
        Vcomh = 0xBe,
        ContrastAbc = 0xC1,
        ContrastMaster = 0xC7,
        MuxRatio = 0xCA,
        CommandLock = 0xFD,
    };

    ///
    ///
    ///
    const FontType = enum { FT_8x8, FT_12x16, FT_16x16, FT_Default };

    ///
    ///
    ///
    const ScreenPoint = struct {
        x: u8,
        y: u8,
    };

    ///
    ///
    ///
    const Size = struct {
        width: u8,
        height: u8,
    };

    ///
    /// spi_group - Only got 2 options: SSD1351.spi0, SSD1351.spi1. They point to the preset
    ///            struct instance.
    ///
    const Config = struct {
        show_fps: bool,
        fps_color: u16,
        spi_group: [*c]c.spi_hw_t,
        spi_baudrate: u32,
        data_and_command_pin: u32,
        reset_pin: u32,
        spi_clock_pin: u32,
        spi_tx_pin: u32,
    };

    const Self = @This();

    ///
    /// Use DMA to simulate the `double-buffers`:
    ///
    /// - One for display the current frame (finish drawing).
    /// - One for working on the next frame and flipping it when it's done.
    ///
    _oled_dma_1_buffer: [SCREEN_HEIGHT * SCREEN_WIDTH * 2]u8,
    _oled_dma_2_buffer: [SCREEN_HEIGHT * SCREEN_WIDTH * 2]u8,

    ///
    /// Buffered data to scroll into frame buffer
    ///
    _scroll_buffer: [SCREEN_HEIGHT * SCREEN_WIDTH * 2]u8,
    _scroll_pos: u16 = 0,
    _current_buffer: u8 = 1,
    _pos_x: u8 = 0,
    _pos_y: u8 = 0,

    _show_fps: bool = false,
    _fps: u16 = 0,
    _last_fps: u16 = 0,
    _timer: ?c.repeating_timer,

    _dma_tx: u32,

    _dma_config: c.dma_channel_config,

    config: Config,

    ///
    ///
    ///
    pub fn init(config: ?Config) Self {
        const dma_tx_result: u32 = @intCast(c.dma_claim_unused_channel(true));
        var me: Self = .{
            .config = .{
                .show_fps = if (config) |con| con.show_fps else false,
                .fps_color = if (config) |con| con.fps_color else 0xB1D2, // 0xFFFF,
                .spi_group = if (config) |con| con.spi_group else SSD1351_DEFAULT_SPI_GROUP,
                .spi_baudrate = if (config) |con| con.spi_baudrate else SSD1351_DEFAULT_SPI_SPEED,
                .data_and_command_pin = if (config) |con| con.data_and_command_pin else SSD1351_DEFAULT_DATA_COMMAND_PIN,
                .reset_pin = if (config) |con| con.reset_pin else SSD1351_DEFAULT_RESET_PIN,
                .spi_clock_pin = if (config) |con| con.spi_clock_pin else SSD1351_DEFAULT_SPI_CLOCK_PIN,
                .spi_tx_pin = if (config) |con| con.spi_tx_pin else SSD1351_DEFAULT_SPI_TX_PIN,
            },
            //
            // DO NOT use this way to init, as it causes init in compile time, init data (96KB 0x00)
            // will be added into the binary!!!
            //
            // ._oled_dma_1_buffer = .{0x00} ** (SCREEN_HEIGHT * SCREEN_WIDTH * 2),
            // ._oled_dma_2_buffer = .{0x00} ** (SCREEN_HEIGHT * SCREEN_WIDTH * 2),
            // ._scroll_buffer = .{0x00} ** (SCREEN_HEIGHT * SCREEN_WIDTH * 2),
            ._oled_dma_1_buffer = undefined,
            ._oled_dma_2_buffer = undefined,
            ._scroll_buffer = undefined,
            ._dma_tx = dma_tx_result,
            ._dma_config = c.dma_channel_get_default_config(dma_tx_result),
            ._timer = null,
        };

        //
        // Run time init all buffers
        //
        for (0..(SCREEN_HEIGHT * SCREEN_WIDTH * 2)) |index| {
            me._oled_dma_1_buffer[index] = 0x00;
            me._oled_dma_2_buffer[index] = 0x00;
            me._scroll_buffer[index] = 0x00;
        }

        if (build_options.enable_debug_log) {
            const show_fps_str = if (me.config.show_fps) "True" else "False";
            const spi_group_str = if (me.config.spi_group == spi0) "SPI0" else "SPI1";
            _ = c.printf(
                "\n>>> [ OLED-SSD1351 > init ] - {" ++
                    "\n\tfps_color: 0x%X" ++
                    "\n\tshow_fps: %s" ++
                    "\n\tspi_group: %s" ++
                    "\n\tspi_baudrate: %d" ++
                    "\n\tspi_clock_pin: GPIO_%d" ++
                    "\n\tspi_tx_pin: GPIO_%d" ++
                    "\n\tdata_and_command_pin: GPIO_%d" ++
                    "\n\treset_pin: GPIO_%d" ++
                    "\n}\n",
                me.config.fps_color,
                @as([*]const u8, @ptrCast(show_fps_str)),
                @as([*]const u8, @ptrCast(spi_group_str)),
                me.config.spi_baudrate,
                me.config.spi_clock_pin,
                me.config.spi_tx_pin,
                me.config.data_and_command_pin,
                me.config.reset_pin,
            );

            _ = c.printf("\n>>> [ OLED-SSD1351 > init ] - oled_dma1_buffer: ");
            for (0..10) |index| {
                _ = c.printf("0x%02X, ", me._oled_dma_1_buffer[index]);
            }
            _ = c.printf("\n>>> [ OLED-SSD1351 > init ] - oled_dma_2_buffer: ");
            for (0..10) |index| {
                _ = c.printf("0x%02X, ", me._oled_dma_2_buffer[index]);
            }
            _ = c.printf("\n>>> [ OLED-SSD1351 > init ] - scroll_buffer: ");
            for (0..10) |index| {
                _ = c.printf("0x%02X, ", me._scroll_buffer[index]);
            }
        }

        return me;
    }

    ///
    ///
    ///
    pub fn clear() void {}

    ///
    ///
    ///
    pub fn refresh() void {}
};
