const std = @import("std");

///
///
///
pub const FormatBitWidth = enum {
    FBW_8,
    FBW_16,
    FBW_32,
    FBW_64,
};

///
/// Example:
///
/// ```zig
/// bit_utils.print_bit(0x04, bit_utils.FormatBitWidth.FBW_8);
/// bit_utils.print_bit(0x04, bit_utils.FormatBitWidth.FBW_16);
/// bit_utils.print_bit(0x04, bit_utils.FormatBitWidth.FBW_32);
/// bit_utils.print_bit(0x04, bit_utils.FormatBitWidth.FBW_64);
/// ```
///
/// Output:
///
/// ```bash
/// # >>> [ bit_utils -> print_bit ] - bit value of 4 is: 00000100
/// # >>> [ bit_utils -> print_bit ] - bit value of 4 is: 0000000000000100
/// # >>> [ bit_utils -> print_bit ] - bit value of 4 is: 00000000000000000000000000000100
/// # >>> [ bit_utils -> print_bit ] - bit value of 4 is: 0000000000000000000000000000000000000000000000000000000000000100
/// ```
///
pub fn print_bit(value: usize, format_bit_width: FormatBitWidth, out_buffer: []u8) !void {
    _ = switch (format_bit_width) {
        .FBW_8 => try std.fmt.bufPrint(out_buffer, "{b:0>8}", .{value}),
        .FBW_16 => try std.fmt.bufPrint(out_buffer, "{b:0>16}", .{value}),
        .FBW_32 => try std.fmt.bufPrint(out_buffer, "{b:0>32}", .{value}),
        .FBW_64 => try std.fmt.bufPrint(out_buffer, "{b:0>64}", .{value}),
    };
}
