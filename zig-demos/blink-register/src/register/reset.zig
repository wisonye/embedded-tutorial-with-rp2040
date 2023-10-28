const reg_u32 = @import("./common.zig").reg_u32;

const ResetRegister = @This();

//
// Page 18 -> Atomic Register Access
//
// =Atomic Register Access= helps you to avoid data race when accessing peripheral registers in
// RP2040 (multiple cores).
//
// Summaries, you should ALWAYS use atomic register methods to do the following operations to
// the given peripheral register except the =GPIO= (as it uses =SIO=, and =SIO= doesn't support
// atomic accesses)!!!
//
// - Set a bit (assign 1)
// - Clear a bit (assign 0)
// - Flip a bit (xor ~)
//
// Here are the rules about how to use =Atomic Register Access=:
//
// | Address Offset           | Purposes                      |
// |------------------------  +-------------------------------|
// | Register Addr + 0x0000   | normal read write access      |
// | Register Addr + ~0x1000~ | atomic XOR on write           |
// | Register Addr + ~0x2000~ | atomic bitmask set on write   |
// | Register Addr + ~0x3000~ | atomic bitmask clear on write |
//
pub const ATOMIC_NORMAL_READ_WRITE_OFFSET: u32 = 0x0000;
pub const ATOMIC_XOR_ON_WRITE_OFFSET: u32 = 0x1000;
pub const ATOMIC_SET_ON_WRITE_OFFSET: u32 = 0x2000;
pub const ATOMIC_CLEAR_ON_WRITE_OFFSET: u32 = 0x3000;

// ---------------------------------------------------------------------------------------
// Subssytem reset registers
// ---------------------------------------------------------------------------------------
//
// Page 177 -> 2.14.3
//
// Reset Registers
//
pub const RESET_BASE_ADDR: u32 = 0x4000c000;
pub const RESET_CONTROL_ADDR: u32 = (RESET_BASE_ADDR + 0x00);
pub const RESET_WATCH_DOG_SELCECT_ADDR: u32 = (RESET_BASE_ADDR + 0x04);
pub const RESET_DONE_ADDR: u32 = (RESET_BASE_ADDR + 0x08);

pub fn reset_control_get_value() u32 {
    const ptr: reg_u32 = @ptrFromInt(RESET_CONTROL_ADDR);
    return ptr.*;
}

pub fn reset_watch_dog_select_get_value() u32 {
    const ptr: reg_u32 = @ptrFromInt(RESET_WATCH_DOG_SELCECT_ADDR);
    return ptr.*;
}

pub fn reset_done_get_value() u32 {
    const ptr: reg_u32 = @ptrFromInt(RESET_DONE_ADDR);
    return ptr.*;
}

// ---------------------------------------------------------------------------------------
// Reset Control Register
// ---------------------------------------------------------------------------------------

//
// `Reset Control Register` is a read-write register to control which peripheral is enabled
// or disabled, and the rule looks like this:
//
// - Write a `1` to the particular bit to disable the given peripheral
// - Write a `0` to the particular bit to enable  the given peripheral
//
// And here is the Reset Control Register bit table, `0x1` means that bit is disabled by
// default.
//
// |  Bits | Name       | Reset (disable) |
// |-------+------------+-----------------|
// | 31:25 | Reserved   |                 |
// |    24 | USBCTRL    |             0x1 |
// |    23 | UART1      |             0x1 |
// |    22 | UART0      |             0x1 |
// |    21 | TIMER      |             0x1 |
// |    20 | TBMAN      |             0x1 |
// |    19 | SYSINFO    |             0x1 |
// |    18 | SYSCFG     |             0x1 |
// |    17 | SPI1       |             0x1 |
// |    16 | SPI0       |             0x1 |
// |    15 | RTC        |             0x1 |
// |    14 | PWM        |             0x1 |
// |    13 | PLL_USB    |             0x1 |
// |    12 | PLL_SYS    |             0x1 |
// |    11 | PIO1       |             0x1 |
// |    10 | PIO0       |             0x1 |
// |     9 | PADS_QSPI  |             0x1 |
// |     8 | PADS_BANK0 |             0x1 |
// |     7 | JTAG       |             0x1 |
// |     6 | IO_QSPI    |             0x1 |
// |     5 | IO_BANK0   |             0x1 |
// |     4 | I2C1       |             0x1 |
// |     3 | I2C0       |             0x1 |
// |     2 | DMA        |             0x1 |
// |     1 | BUSCTRL    |             0x1 |
// |     0 | ADC        |             0x1 |

pub const RESET_CTL_USBCTRL_BIT: u32 = (@as(u32, 1) << 24);
pub const RESET_CTL_UART1_BIT: u32 = (@as(u32, 1) << 23);
pub const RESET_CTL_UART0_BIT: u32 = (@as(u32, 1) << 22);
pub const RESET_CTL_TIMER_BIT: u32 = (@as(u32, 1) << 21);
pub const RESET_CTL_TBMAN_BIT: u32 = (@as(u32, 1) << 20);
pub const RESET_CTL_SYSINFO_BIT: u32 = (@as(u32, 1) << 19);
pub const RESET_CTL_SYSCFG_BIT: u32 = (@as(u32, 1) << 18);
pub const RESET_CTL_SPI1_BIT: u32 = (@as(u32, 1) << 17);
pub const RESET_CTL_SPI0_BIT: u32 = (@as(u32, 1) << 16);
pub const RESET_CTL_RTC_BIT: u32 = (@as(u32, 1) << 15);
pub const RESET_CTL_PWM_BIT: u32 = (@as(u32, 1) << 14);
pub const RESET_CTL_PLL_USB_BIT: u32 = (@as(u32, 1) << 13);
pub const RESET_CTL_PLL_SYS_BIT: u32 = (@as(u32, 1) << 12);
pub const RESET_CTL_PIO1_BIT: u32 = (@as(u32, 1) << 11);
pub const RESET_CTL_PIO0_BIT: u32 = (@as(u32, 1) << 10);
pub const RESET_CTL_PADS_QSPI_BIT: u32 = (@as(u32, 1) << 9);
pub const RESET_CTL_PADS_BANK0_BIT: u32 = (@as(u32, 1) << 8);
pub const RESET_CTL_JTAG_BIT: u32 = (@as(u32, 1) << 7);
pub const RESET_CTL_IO_QSPI_BIT: u32 = (@as(u32, 1) << 6);
pub const RESET_CTL_IO_BANK0_BIT: u32 = (@as(u32, 1) << 5);
pub const RESET_CTL_I2C1_BIT: u32 = (@as(u32, 1) << 4);
pub const RESET_CTL_I2C0_BIT: u32 = (@as(u32, 1) << 3);
pub const RESET_CTL_DMA_BIT: u32 = (@as(u32, 1) << 2);
pub const RESET_CTL_BUSCTRL_BIT: u32 = (@as(u32, 1) << 1);
pub const RESET_CTL_ADC_BIT: u32 = (@as(u32, 1) << 0);

// Pay attention when using SDK and link to `pico_stdlib` (in `CMakeLists.txt`). In that
// case, somehow SDK enables all functionalities by default. This can be confirmed by the
// following steps:
//
// - If you print `Reset Control Register` value, it will be
//   0x00	    bits: 00000000000000000000000000000000
//   Which should be (by default):
//   0x01FFFFFF bits: 00000001111111111111111111111111
//
// - If you read the `Reset Done Resgiter` value, it will be:
//   0x01FFFFFF bits: 00000001111111111111111111111111
//   Which should be (by default):
//   0x00       bits: 00000000000000000000000000000000
//
//   It means all peripherals are ready to be used!!!
//
// To reduce the power consumption, you should disable all unnecessary peripherals and only
// enable the one you needed:)
//

///
///
///
fn atomic_reg_set_bits(reg_address: u32, bitmask_to_set_1: u32) void {
    var ptr: reg_u32 = @ptrFromInt(reg_address | ATOMIC_SET_ON_WRITE_OFFSET);
    ptr.* = bitmask_to_set_1;
}

///
///
///
fn atomic_reg_clear_bits(reg_address: u32, bitmask_to_set_0: u32) void {
    var ptr: reg_u32 = @ptrFromInt(reg_address | ATOMIC_CLEAR_ON_WRITE_OFFSET);
    ptr.* = bitmask_to_set_0;
}

///
///
///
fn atomic_reg_toggle_bits(reg_address: u32, bitmask_to_toggle: u32) void {
    var ptr: reg_u32 = @ptrFromInt(reg_address | ATOMIC_XOR_ON_WRITE_OFFSET);
    ptr.* = bitmask_to_toggle;
}

///
/// Use atomic set bit operation to set the give bit combination to disable the particular
/// peripherals.
///
/// Example:
///
/// ```c
/// reset_control_disable_peripherals(
///     RESET_CTL_ADC_BIT |
///     RESET_CTL_I2C1_BIT | RESET_CTL_I2C0_BIT |
///     RESET_CTL_PWM_BIT |
///     RESET_CTL_SPI1_BIT | RESET_CTL_SPI0_BIT |
///     RESET_CTL_UART1_BIT | RESET_CTL_UART0_BIT |
///     RESET_CTL_DMA_BIT |
///     RESET_CTL_PIO1_BIT | RESET_CTL_PIO0_BIT |
///     RESET_CTL_TBMAN_BIT
/// );
/// ```
///
pub fn reset_control_disable_peripherals(disable_peripheral_bits: u32) void {
    atomic_reg_set_bits(RESET_CONTROL_ADDR, disable_peripheral_bits);
}

///
/// Use atomic clear bit operation to set the give bit combination to enable the particular
/// peripherals.
///
/// Example:
///
/// ```c
/// reset_control_enable_peripherals(
///     RESET_CTL_USBCTRL_BIT |
///     RESET_CTL_TIMER_BIT |
///     RESET_CTL_SYSINFO_BIT | RESET_CTL_SYSCFG_BIT |
///     RESET_CTL_RTC_BIT |
///     RESET_CTL_PLL_USB_BIT | RESET_CTL_PLL_SYS_BIT |
///     RESET_CTL_PADS_QSPI_BIT | RESET_CTL_PADS_BANK0_BIT |
///     RESET_CTL_JTAG_BIT |
///     RESET_CTL_IO_QSPI_BIT |
///     RESET_CTL_IO_BANK0_BIT |
///     RESET_CTL_BUSCTRL_BIT);
/// ```
///
pub fn reset_control_enable_peripherals(enable_peripheral_bits: u32) void {
    atomic_reg_clear_bits(RESET_CONTROL_ADDR, enable_peripheral_bits);
}

///
/// After reset option has been done, then the related bits in this register will become `1`,
/// this function will wait until all those bits are `1`.
///
/// Pay attention: The bit31~bit25 is reserved (should be always 0)!!!
///
pub fn reset_done_wait_for_enabled_peripherals_ready(enabled_peripheral_bits: u32) void {
    _ = enabled_peripheral_bits;
}
