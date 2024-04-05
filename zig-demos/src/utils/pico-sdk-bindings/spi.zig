//!
//! Copied from `zig-translate` result of `@cImport` and modified to avoid the compiler error!!!
//! I don't need to translate the entire "hardware/spi.h", I just need the minimal calling API bindings.
//!
//!  const spi = @cImport({
//!      @cInclude("hardware/spi.h");
//!  });
//!

pub extern fn __assert_func([*c]const u8, c_int, [*c]const u8, [*c]const u8) noreturn;

pub inline fn hw_set_bits(arg_addr: [*c]volatile io_rw_32, arg_mask: u32) void {
    const addr = arg_addr;
    const mask = arg_mask;
    @as([*c]volatile io_rw_32, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt((@as(c_uint, 2) << @intCast(12)) | @as(usize, @intCast(@intFromPtr(@as(?*volatile anyopaque, @ptrCast(addr)))))))))).* = mask;
}

pub inline fn hw_clear_bits(arg_addr: [*c]volatile io_rw_32, arg_mask: u32) void {
    const addr = arg_addr;
    const mask = arg_mask;
    @as([*c]volatile io_rw_32, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt((@as(c_uint, 3) << @intCast(12)) | @as(usize, @intCast(@intFromPtr(@as(?*volatile anyopaque, @ptrCast(addr)))))))))).* = mask;
}

pub inline fn hw_xor_bits(arg_addr: [*c]volatile io_rw_32, arg_mask: u32) void {
    const addr = arg_addr;
    const mask = arg_mask;
    @as([*c]volatile io_rw_32, @ptrCast(@alignCast(@as(?*anyopaque, @ptrFromInt((@as(c_uint, 1) << @intCast(12)) | @as(usize, @intCast(@intFromPtr(@as(?*volatile anyopaque, @ptrCast(addr)))))))))).* = mask;
}

pub inline fn hw_write_masked(arg_addr: [*c]volatile io_rw_32, arg_values: u32, arg_write_mask: u32) void {
    const addr = arg_addr;
    const values = arg_values;
    const write_mask = arg_write_mask;
    hw_xor_bits(addr, (addr.* ^ values) & write_mask);
}

pub const io_rw_32 = u32;
pub const io_ro_32 = u32;

pub const spi_hw_t = extern struct {
    cr0: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
    cr1: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
    dr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
    sr: io_ro_32 = @import("std").mem.zeroes(io_ro_32),
    cpsr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
    imsc: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
    ris: io_ro_32 = @import("std").mem.zeroes(io_ro_32),
    mis: io_ro_32 = @import("std").mem.zeroes(io_ro_32),
    icr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
    dmacr: io_rw_32 = @import("std").mem.zeroes(io_rw_32),
};

pub const SPI0_BASE: u32 = 0x4003c000;
pub const SPI1_BASE: u32 = 0x40040000;

pub const SPI_HARDWRE_STRUCT_PTR = *spi_hw_t;
pub const SPI_HARDWRE_STRUCT_CONST_PTR = *const spi_hw_t;
pub const spi0_hw: SPI_HARDWRE_STRUCT_PTR = @ptrFromInt(SPI0_BASE);
pub const spi1_hw: SPI_HARDWRE_STRUCT_PTR = @ptrFromInt(SPI1_BASE);
pub const spi0 = spi0_hw;
pub const spi1 = spi1_hw;

pub const SPI_CPHA_0: c_int = 0;
pub const SPI_CPHA_1: c_int = 1;
pub const spi_cpha_t = c_uint;
pub const SPI_CPOL_0: c_int = 0;
pub const SPI_CPOL_1: c_int = 1;
pub const spi_cpol_t = c_uint;
pub const SPI_LSB_FIRST: c_int = 0;
pub const SPI_MSB_FIRST: c_int = 1;
pub const spi_order_t = c_uint;
pub extern fn spi_init(spi: ?SPI_HARDWRE_STRUCT_PTR, baudrate: u32) u32;
pub extern fn spi_deinit(spi: ?SPI_HARDWRE_STRUCT_PTR) void;
pub extern fn spi_set_baudrate(spi: ?SPI_HARDWRE_STRUCT_PTR, baudrate: u32) u32;
pub extern fn spi_get_baudrate(spi: ?SPI_HARDWRE_STRUCT_CONST_PTR) u32;

pub fn spi_get_index(arg_spi: ?SPI_HARDWRE_STRUCT_CONST_PTR) callconv(.C) u32 {
    const spi = arg_spi;
    {
        if ((false or false) and !false) {
            _ = if (!((spi != @as(?SPI_HARDWRE_STRUCT_CONST_PTR, @ptrCast(@as(?SPI_HARDWRE_STRUCT_PTR, @ptrCast(@as([*c]spi_hw_t, @ptrFromInt(@as(c_uint, 1073987584)))))))) and (spi != @as(?SPI_HARDWRE_STRUCT_CONST_PTR, @ptrCast(@as(?SPI_HARDWRE_STRUCT_PTR, @ptrCast(@as([*c]spi_hw_t, @ptrFromInt(@as(c_uint, 1074003968)))))))))) @as(c_int, 0) else __assert_func("/Users/wison/pico/pico-sdk/src/rp2_common/hardware_spi/include/hardware/spi.h", @as(c_int, 152), "spi_get_index", "!(spi != ((spi_inst_t *)((spi_hw_t *)0x4003c000u)) && spi != ((spi_inst_t *)((spi_hw_t *)0x40040000u)))");
        }
    }
    return @as(u32, @bitCast(if (spi == @as(?SPI_HARDWRE_STRUCT_CONST_PTR, @ptrCast(@as(?SPI_HARDWRE_STRUCT_PTR, @ptrCast(@as([*c]spi_hw_t, @ptrFromInt(@as(c_uint, 1074003968)))))))) @as(c_int, 1) else @as(c_int, 0)));
}

pub fn spi_get_hw(arg_spi: ?SPI_HARDWRE_STRUCT_PTR) callconv(.C) [*c]spi_hw_t {
    const spi = arg_spi;
    _ = spi_get_index(spi);
    return @as([*c]spi_hw_t, @ptrCast(@alignCast(spi)));
}

pub fn spi_get_const_hw(arg_spi: ?SPI_HARDWRE_STRUCT_CONST_PTR) callconv(.C) [*c]const spi_hw_t {
    const spi = arg_spi;
    _ = spi_get_index(spi);
    return @as([*c]const spi_hw_t, @ptrCast(@alignCast(spi)));
}

pub fn spi_set_format(
    arg_spi: ?SPI_HARDWRE_STRUCT_PTR,
    arg_data_bits: u32,
    arg_cpol: spi_cpol_t,
    arg_cpha: spi_cpha_t,
    arg_order: spi_order_t,
) callconv(.C) void {
    const spi = arg_spi;
    const data_bits = arg_data_bits;
    const cpol = arg_cpol;
    const cpha = arg_cpha;
    const order = arg_order;
    {
        if ((false or false) and !false) {
            _ = if (!((data_bits < @as(u32, @bitCast(@as(c_int, 4)))) or (data_bits > @as(u32, @bitCast(@as(c_int, 16)))))) @as(c_int, 0) else __assert_func("/Users/wison/pico/pico-sdk/src/rp2_common/hardware_spi/include/hardware/spi.h", @as(c_int, 178), "spi_set_format", "!(data_bits < 4 || data_bits > 16)");
        }
    }
    {
        if ((false or false) and !false) {
            _ = if (!(order != @as(c_uint, @bitCast(SPI_MSB_FIRST)))) @as(c_int, 0) else __assert_func("/Users/wison/pico/pico-sdk/src/rp2_common/hardware_spi/include/hardware/spi.h", @as(c_int, 180), "spi_set_format", "!(order != SPI_MSB_FIRST)");
        }
    }
    {
        if ((false or false) and !false) {
            _ = if (!((cpol != @as(c_uint, @bitCast(SPI_CPOL_0))) and (cpol != @as(c_uint, @bitCast(SPI_CPOL_1))))) @as(c_int, 0) else __assert_func("/Users/wison/pico/pico-sdk/src/rp2_common/hardware_spi/include/hardware/spi.h", @as(c_int, 181), "spi_set_format", "!(cpol != SPI_CPOL_0 && cpol != SPI_CPOL_1)");
        }
    }
    {
        if ((false or false) and !false) {
            _ = if (!((cpha != @as(c_uint, @bitCast(SPI_CPHA_0))) and (cpha != @as(c_uint, @bitCast(SPI_CPHA_1))))) @as(c_int, 0) else __assert_func("/Users/wison/pico/pico-sdk/src/rp2_common/hardware_spi/include/hardware/spi.h", @as(c_int, 182), "spi_set_format", "!(cpha != SPI_CPHA_0 && cpha != SPI_CPHA_1)");
        }
    }
    const enable_mask: u32 = spi_get_hw(spi).*.cr1 & @as(c_uint, 2);
    hw_clear_bits(&spi_get_hw(spi).*.cr1, @as(c_uint, 2));
    hw_write_masked(&spi_get_hw(spi).*.cr0, (((data_bits -% @as(u32, @bitCast(@as(c_int, 1)))) << @intCast(0)) | (@as(u32, @bitCast(cpol)) << @intCast(6))) | (@as(u32, @bitCast(cpha)) << @intCast(7)), (@as(c_uint, 15) | @as(c_uint, 64)) | @as(c_uint, 128));
    hw_set_bits(&spi_get_hw(spi).*.cr1, enable_mask);
}

// pub fn spi_set_slave(arg_spi: ?SPI_HARDWRE_STRUCT_PTR, arg_slave: bool) callconv(.C) void {
//     var spi = arg_spi;
//     var slave = arg_slave;
//     var enable_mask: u32 = spi_get_hw(spi).*.cr1 & @as(c_uint, 2);
//     hw_clear_bits(&spi_get_hw(spi).*.cr1, @as(c_uint, 2));
//     if (slave) {
//         hw_set_bits(&spi_get_hw(spi).*.cr1, @as(c_uint, 4));
//     } else {
//         hw_clear_bits(&spi_get_hw(spi).*.cr1, @as(c_uint, 4));
//     }
//     hw_set_bits(&spi_get_hw(spi).*.cr1, enable_mask);
// }

// pub fn spi_is_writable(arg_spi: ?SPI_HARDWRE_STRUCT_CONST_PTR) callconv(.C) bool {
//     var spi = arg_spi;
//     return (spi_get_const_hw(spi).*.sr & @as(c_uint, 2)) != 0;
// }

// pub fn spi_is_readable(arg_spi: ?SPI_HARDWRE_STRUCT_CONST_PTR) callconv(.C) bool {
//     var spi = arg_spi;
//     return (spi_get_const_hw(spi).*.sr & @as(c_uint, 4)) != 0;
// }

// pub fn spi_is_busy(arg_spi: ?SPI_HARDWRE_STRUCT_CONST_PTR) callconv(.C) bool {
//     var spi = arg_spi;
//     return (spi_get_const_hw(spi).*.sr & @as(c_uint, 16)) != 0;
// }

pub extern fn spi_write_read_blocking(
    spi: ?SPI_HARDWRE_STRUCT_PTR,
    src: [*c]const u8,
    dst: [*c]u8,
    len: usize,
) c_int;

pub extern fn spi_write_blocking(
    spi: ?SPI_HARDWRE_STRUCT_PTR,
    src: [*c]const u8,
    len: usize,
) c_int;

pub extern fn spi_read_blocking(
    spi: ?SPI_HARDWRE_STRUCT_PTR,
    repeated_tx_data: u8,
    dst: [*c]u8,
    len: usize,
) c_int;

pub extern fn spi_write16_read16_blocking(
    spi: ?SPI_HARDWRE_STRUCT_PTR,
    src: [*c]const u16,
    dst: [*c]u16,
    len: usize,
) c_int;

pub extern fn spi_write16_blocking(
    spi: ?SPI_HARDWRE_STRUCT_PTR,
    src: [*c]const u16,
    len: usize,
) c_int;

pub extern fn spi_read16_blocking(
    spi: ?SPI_HARDWRE_STRUCT_PTR,
    repeated_tx_data: u16,
    dst: [*c]u16,
    len: usize,
) c_int;
