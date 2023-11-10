//! Reworking of BigFont from http://www.rinkydinkelectronics.com/r_fonts.php
//! Under public domain

pub const font_16x16: [][32]u8 = .{
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 20
    .{ 0x00, 0x00, 0xe0, 0x00, 0xf0, 0x01, 0xf0, 0x01, 0xf0, 0x01, 0xf0, 0x01, 0xf0, 0x01, 0xe0, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x00, 0x00 }, // 21
    .{ 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x60, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 22
    .{ 0x30, 0x0c, 0x30, 0x0c, 0x30, 0x0c, 0xfe, 0x7f, 0xfe, 0x7f, 0x30, 0x0c, 0x30, 0x0c, 0x30, 0x0c, 0x30, 0x0c, 0xfe, 0x7f, 0xfe, 0x7f, 0x30, 0x0c, 0x30, 0x0c, 0x30, 0x0c, 0x00, 0x00 }, // 23
    .{ 0x40, 0x02, 0x40, 0x02, 0xf0, 0x1f, 0xf8, 0x1f, 0x58, 0x02, 0x58, 0x02, 0xf8, 0x0f, 0xf0, 0x1f, 0x40, 0x1a, 0x40, 0x1a, 0xf8, 0x1f, 0xf8, 0x0f, 0x40, 0x02, 0x40, 0x02, 0x00, 0x00 }, // 24
    .{ 0x00, 0x00, 0x00, 0x00, 0x70, 0x08, 0x70, 0x0c, 0x70, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x0e, 0x30, 0x0e, 0x10, 0x0e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 25
    .{ 0x00, 0x00, 0xf0, 0x00, 0x98, 0x01, 0x98, 0x01, 0x98, 0x01, 0xf0, 0x00, 0xf0, 0x10, 0xf0, 0x19, 0x98, 0x1f, 0x18, 0x0f, 0x18, 0x07, 0x98, 0x0f, 0xf0, 0x19, 0x00, 0x00, 0x00, 0x00 }, // 26
    .{ 0x00, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 27
    .{ 0x00, 0x00, 0x00, 0x0f, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0xe0, 0x00, 0xc0, 0x01, 0x80, 0x03, 0x00, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 28
    .{ 0x00, 0x00, 0xf0, 0x00, 0xc0, 0x01, 0x80, 0x03, 0x00, 0x07, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 29
    .{ 0x00, 0x00, 0x80, 0x01, 0x88, 0x11, 0x90, 0x09, 0xe0, 0x07, 0xe0, 0x07, 0xfc, 0x3f, 0xfc, 0x3f, 0xe0, 0x07, 0xe0, 0x07, 0x90, 0x09, 0x88, 0x11, 0x80, 0x01, 0x00, 0x00, 0x00, 0x00 }, // 2a
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x01, 0x80, 0x01, 0x80, 0x01, 0xf0, 0x0f, 0xf0, 0x0f, 0x80, 0x01, 0x80, 0x01, 0x80, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 2b
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x70, 0x00, 0x00, 0x00 }, // 2c
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x1f, 0xf8, 0x1f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 2d
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 2e
    .{ 0x00, 0x00, 0x00, 0x40, 0x00, 0x60, 0x00, 0x70, 0x00, 0x38, 0x00, 0x1c, 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x00, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 2f
    .{ 0x00, 0x00, 0xf0, 0x0f, 0x38, 0x1c, 0x38, 0x1e, 0x38, 0x1f, 0x38, 0x1f, 0xb8, 0x1d, 0xb8, 0x1d, 0xf8, 0x1c, 0xf8, 0x1c, 0x78, 0x1c, 0x38, 0x1c, 0xf0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 30
    .{ 0x00, 0x00, 0x80, 0x01, 0x80, 0x01, 0xc0, 0x01, 0xf8, 0x01, 0xf8, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xf8, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 31
    .{ 0x00, 0x00, 0xf0, 0x07, 0x38, 0x0e, 0x38, 0x1c, 0x00, 0x1c, 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x1c, 0x38, 0x1c, 0xf8, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 32
    .{ 0x00, 0x00, 0xf0, 0x07, 0x38, 0x0e, 0x38, 0x1c, 0x00, 0x1c, 0x00, 0x0e, 0xc0, 0x03, 0xc0, 0x03, 0x00, 0x0e, 0x00, 0x1c, 0x38, 0x1c, 0x38, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 33
    .{ 0x00, 0x00, 0x00, 0x07, 0x80, 0x07, 0xc0, 0x07, 0x60, 0x07, 0x30, 0x07, 0x18, 0x07, 0xf8, 0x1f, 0xf8, 0x1f, 0x00, 0x07, 0x00, 0x07, 0x00, 0x07, 0xc0, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 34
    .{ 0x00, 0x00, 0xf8, 0x1f, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0xf8, 0x07, 0xf8, 0x0f, 0x00, 0x1e, 0x00, 0x1c, 0x38, 0x1c, 0x38, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 35
    .{ 0x00, 0x00, 0xc0, 0x07, 0xe0, 0x00, 0x70, 0x00, 0x38, 0x00, 0x38, 0x00, 0xf8, 0x0f, 0xf8, 0x1f, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0xf0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 36
    .{ 0x00, 0x00, 0xf8, 0x3f, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x00, 0x38, 0x00, 0x1c, 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0x00, 0x00, 0x00, 0x00 }, // 37
    .{ 0x00, 0x00, 0xf0, 0x0f, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0xf8, 0x1c, 0xe0, 0x07, 0xe0, 0x07, 0x38, 0x1f, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0xf0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 38
    .{ 0x00, 0x00, 0xf0, 0x0f, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0xf8, 0x1f, 0xf0, 0x1f, 0x00, 0x1c, 0x00, 0x1c, 0x00, 0x0e, 0x00, 0x07, 0xe0, 0x03, 0x00, 0x00, 0x00, 0x00 }, // 39
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 3a
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 3b
    .{ 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x00, 0x38, 0x00, 0x38, 0x00, 0x70, 0x00, 0xe0, 0x00, 0xc0, 0x01, 0x80, 0x03, 0x00, 0x07, 0x00, 0x0e, 0x00, 0x00 }, // 3c
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfc, 0x3f, 0xfc, 0x3f, 0x00, 0x00, 0x00, 0x00, 0xfc, 0x3f, 0xfc, 0x3f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 3d
    .{ 0x38, 0x00, 0x70, 0x00, 0xe0, 0x00, 0xc0, 0x01, 0x80, 0x03, 0x00, 0x07, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x00, 0x38, 0x00, 0x00, 0x00 }, // 3e
    .{ 0xc0, 0x03, 0xf0, 0x0f, 0x78, 0x1e, 0x18, 0x1c, 0x00, 0x1c, 0x00, 0x0e, 0x00, 0x07, 0x80, 0x03, 0x80, 0x03, 0x00, 0x00, 0x00, 0x00, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x00, 0x00 }, // 3f
    .{ 0xf0, 0x1f, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x3f, 0x38, 0x3f, 0x38, 0x3f, 0x38, 0x3f, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0xf8, 0x0f, 0xe0, 0x1f, 0x00, 0x00 }, // 40
    .{ 0x00, 0x00, 0xc0, 0x03, 0xe0, 0x07, 0x70, 0x0e, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0xf8, 0x1f, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x00, 0x00, 0x00, 0x00 }, // 41
    .{ 0x00, 0x00, 0xf8, 0x0f, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xf0, 0x0f, 0xf0, 0x0f, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xf8, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 42
    .{ 0x00, 0x00, 0xe0, 0x0f, 0x70, 0x1c, 0x38, 0x1c, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0x38, 0x1c, 0x70, 0x1c, 0xe0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 43
    .{ 0x00, 0x00, 0xf8, 0x07, 0x70, 0x0e, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x0e, 0xf8, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 44
    .{ 0x00, 0x00, 0xf8, 0x1f, 0x70, 0x18, 0x70, 0x10, 0x70, 0x00, 0x70, 0x0c, 0xf0, 0x0f, 0xf0, 0x0f, 0x70, 0x0c, 0x70, 0x00, 0x70, 0x10, 0x70, 0x18, 0xf8, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 45
    .{ 0x00, 0x00, 0xf8, 0x1f, 0x70, 0x18, 0x70, 0x10, 0x70, 0x00, 0x70, 0x0c, 0xf0, 0x0f, 0xf0, 0x0f, 0x70, 0x0c, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0xf8, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 46
    .{ 0x00, 0x00, 0xe0, 0x0f, 0x70, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x00, 0x38, 0x00, 0x38, 0x00, 0x38, 0x1f, 0x38, 0x1c, 0x38, 0x1c, 0x70, 0x1c, 0xe0, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 47
    .{ 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf8, 0x0f, 0xf8, 0x0f, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x00, 0x00, 0x00, 0x00 }, // 48
    .{ 0x00, 0x00, 0xf0, 0x07, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 49
    .{ 0x00, 0x00, 0x80, 0x3f, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x1c, 0x0e, 0x1c, 0x0e, 0x1c, 0x0e, 0x1c, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 4a
    .{ 0x00, 0x00, 0x78, 0x1c, 0x70, 0x1c, 0x70, 0x0e, 0x70, 0x07, 0xf0, 0x03, 0xf0, 0x01, 0xf0, 0x01, 0xf0, 0x03, 0x70, 0x07, 0x70, 0x0e, 0x70, 0x1c, 0x78, 0x1c, 0x00, 0x00, 0x00, 0x00 }, // 4b
    .{ 0x00, 0x00, 0xf8, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x10, 0x70, 0x18, 0x70, 0x1c, 0xf8, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 4c
    .{ 0x00, 0x00, 0x38, 0x38, 0x78, 0x3c, 0xf8, 0x3e, 0xf8, 0x3f, 0xf8, 0x3f, 0xb8, 0x3b, 0x38, 0x39, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x00, 0x00, 0x00, 0x00 }, // 4d
    .{ 0x00, 0x00, 0x38, 0x38, 0x38, 0x38, 0x78, 0x38, 0xf8, 0x38, 0xf8, 0x39, 0xb8, 0x3b, 0x38, 0x3f, 0x38, 0x3e, 0x38, 0x3c, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x00, 0x00, 0x00, 0x00 }, // 4e
    .{ 0x00, 0x00, 0xc0, 0x07, 0xe0, 0x0f, 0x70, 0x1c, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x70, 0x1c, 0xe0, 0x0f, 0xc0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 4f
    .{ 0x00, 0x00, 0xf8, 0x0f, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xf0, 0x0f, 0xf0, 0x0f, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0xf8, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 50
    .{ 0x00, 0x00, 0xc0, 0x07, 0xf0, 0x1e, 0x70, 0x1c, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x3e, 0x38, 0x3f, 0xf0, 0x1f, 0xf0, 0x1f, 0x00, 0x1c, 0x00, 0x3f, 0x00, 0x00 }, // 51
    .{ 0x00, 0x00, 0xf8, 0x0f, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xf0, 0x0f, 0xf0, 0x0f, 0x70, 0x0e, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x78, 0x1c, 0x00, 0x00, 0x00, 0x00 }, // 52
    .{ 0x00, 0x00, 0xf0, 0x0f, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x00, 0xf0, 0x07, 0xe0, 0x0f, 0x00, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0x38, 0x1c, 0xf0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 53
    .{ 0x00, 0x00, 0xf8, 0x3f, 0x98, 0x33, 0x88, 0x23, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0xe0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 54
    .{ 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 55
    .{ 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x70, 0x07, 0xe0, 0x03, 0xc0, 0x01, 0x00, 0x00, 0x00, 0x00 }, // 56
    .{ 0x00, 0x00, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x39, 0x38, 0x39, 0x38, 0x39, 0xf0, 0x1f, 0xf0, 0x1f, 0xe0, 0x0e, 0xe0, 0x0e, 0x00, 0x00, 0x00, 0x00 }, // 57
    .{ 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x70, 0x07, 0xe0, 0x03, 0xc0, 0x01, 0xc0, 0x01, 0xe0, 0x03, 0x70, 0x07, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x00, 0x00, 0x00, 0x00 }, // 58
    .{ 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x70, 0x07, 0xe0, 0x03, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 59
    .{ 0x00, 0x00, 0xf8, 0x1f, 0x38, 0x1c, 0x18, 0x1c, 0x08, 0x0e, 0x00, 0x07, 0x80, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x10, 0x38, 0x18, 0x38, 0x1c, 0xf8, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 5a
    .{ 0x00, 0x00, 0xe0, 0x0f, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 5b
    .{ 0x00, 0x00, 0x08, 0x00, 0x18, 0x00, 0x38, 0x00, 0x70, 0x00, 0xe0, 0x00, 0xc0, 0x01, 0x80, 0x03, 0x00, 0x07, 0x00, 0x0e, 0x00, 0x1c, 0x00, 0x38, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00 }, // 5c
    .{ 0x00, 0x00, 0xe0, 0x0f, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0xe0, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 5d
    .{ 0x80, 0x01, 0xc0, 0x03, 0xe0, 0x07, 0x70, 0x0e, 0x38, 0x1c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 5e
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0xfe, 0xff }, // 5f
    .{ 0x00, 0x00, 0x38, 0x00, 0x38, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 60
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x07, 0x00, 0x0e, 0x00, 0x0e, 0xf0, 0x0f, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x1b, 0x00, 0x00, 0x00, 0x00 }, // 61
    .{ 0x00, 0x00, 0x78, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0xf0, 0x0f, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xd8, 0x0f, 0x00, 0x00, 0x00, 0x00 }, // 62
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x07, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x00, 0x38, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 63
    .{ 0x00, 0x00, 0x00, 0x1f, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0xf0, 0x0f, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x1b, 0x00, 0x00, 0x00, 0x00 }, // 64
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x07, 0x38, 0x0e, 0x38, 0x0e, 0xf8, 0x0f, 0x38, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 65
    .{ 0x00, 0x00, 0xc0, 0x07, 0xe0, 0x0e, 0xe0, 0x0e, 0xe0, 0x00, 0xe0, 0x00, 0xf8, 0x07, 0xf8, 0x07, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xf8, 0x03, 0x00, 0x00, 0x00, 0x00 }, // 66
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x1b, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x0f, 0xe0, 0x0f, 0x00, 0x0e, 0x38, 0x0e, 0xf0, 0x07 }, // 67
    .{ 0x00, 0x00, 0x78, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x0f, 0xf0, 0x1c, 0xf0, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x78, 0x1c, 0x00, 0x00, 0x00, 0x00 }, // 68
    .{ 0x00, 0x00, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x00, 0x00, 0xf0, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0xf0, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 69
    .{ 0x00, 0x00, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x00, 0xc0, 0x0f, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x00, 0x0e, 0x38, 0x0e, 0x30, 0x0f, 0xe0, 0x07 }, // 6a
    .{ 0x00, 0x00, 0x78, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x1c, 0x70, 0x0e, 0x70, 0x07, 0xf0, 0x03, 0x70, 0x07, 0x70, 0x0e, 0x70, 0x1c, 0x78, 0x1c, 0x00, 0x00, 0x00, 0x00 }, // 6b
    .{ 0x00, 0x00, 0xf0, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0xf0, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 6c
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x1f, 0x38, 0x39, 0x38, 0x39, 0x38, 0x39, 0x38, 0x39, 0x38, 0x39, 0x38, 0x39, 0x38, 0x39, 0x00, 0x00, 0x00, 0x00 }, // 6d
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x07, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x00, 0x00, 0x00, 0x00 }, // 6e
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x07, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 6f
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd8, 0x0f, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xf0, 0x0f, 0x70, 0x00, 0x70, 0x00, 0xf8, 0x00 }, // 70
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x0d, 0x1c, 0x07, 0x1c, 0x07, 0x1c, 0x07, 0x1c, 0x07, 0x1c, 0x07, 0xf8, 0x07, 0x00, 0x07, 0x00, 0x07, 0x80, 0x0f }, // 71
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x78, 0x0f, 0xf0, 0x1f, 0xf0, 0x1c, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0x70, 0x00, 0xf8, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 72
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x07, 0x38, 0x0c, 0x38, 0x0c, 0xf0, 0x01, 0xc0, 0x07, 0x18, 0x0e, 0x18, 0x0e, 0xf0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 73
    .{ 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0xc0, 0x00, 0xe0, 0x00, 0xf8, 0x0f, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x00, 0xe0, 0x0e, 0xe0, 0x0e, 0xc0, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 74
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0xf0, 0x1b, 0x00, 0x00, 0x00, 0x00 }, // 75
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x38, 0x0e, 0x70, 0x07, 0xe0, 0x03, 0xc0, 0x01, 0x00, 0x00, 0x00, 0x00 }, // 76
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x38, 0x39, 0x38, 0x39, 0xf0, 0x1f, 0xe0, 0x0e, 0xe0, 0x0e, 0x00, 0x00, 0x00, 0x00 }, // 77
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x07, 0x38, 0x07, 0xf0, 0x03, 0xe0, 0x01, 0xe0, 0x01, 0xf0, 0x03, 0x38, 0x07, 0x38, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 78
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0x70, 0x1c, 0xe0, 0x0f, 0xc0, 0x07, 0x00, 0x07, 0x80, 0x03, 0xf8, 0x01 }, // 79
    .{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf8, 0x07, 0x18, 0x07, 0x88, 0x03, 0xc0, 0x01, 0xe0, 0x00, 0x70, 0x04, 0x38, 0x06, 0xf8, 0x07, 0x00, 0x00, 0x00, 0x00 }, // 7a
    .{ 0x00, 0x00, 0x80, 0x1f, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0xe0, 0x00, 0x38, 0x00, 0x38, 0x00, 0xe0, 0x00, 0xc0, 0x01, 0xc0, 0x01, 0xc0, 0x01, 0x80, 0x1f, 0x00, 0x00, 0x00, 0x00 }, // 7b
    .{ 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x00, 0x00 }, // 7c
    .{ 0x00, 0x00, 0xf8, 0x01, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0x00, 0x07, 0x00, 0x1c, 0x00, 0x1c, 0x00, 0x07, 0x80, 0x03, 0x80, 0x03, 0x80, 0x03, 0xf8, 0x01, 0x00, 0x00, 0x00, 0x00 }, // 7d
    .{ 0x00, 0x00, 0xf8, 0x38, 0xdc, 0x39, 0x9c, 0x3b, 0x1c, 0x1f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, // 7e
};
