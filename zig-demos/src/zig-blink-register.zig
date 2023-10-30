pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");
const reg_u32 = @import("./utils/register/common.zig").reg_u32;
const ResetRegister = @import("./utils/register/reset.zig");
const BitUtil = @import("./utils/bit_utils.zig");

const LED_PIN: u32 = 0;

//
// Purpose that base metal boot in 48MHz (48,000,000 tick in one second) without
// clock configuration
//
const CLK_SPEED: u32 = 48000000;
const HALF_SECOND_DELAY: u32 = CLK_SPEED / 2;
const ONE_QUARTER_SECOND_DELAY: u32 = CLK_SPEED / 4;
const ONE_EIGHTH_SECOND_DELAY: u32 = CLK_SPEED / 8;

//
// Page 243 -> 2.19.6.1 IO - User Bank
//
// GPIO Registers
//
const GPIO_BASE_ADDR: u32 = 0x40014000;
const GPIO_0_CONTROL_ADDR: u32 = GPIO_BASE_ADDR + 0x004;
const GPIO_2_CONTROL_ADDR: u32 = GPIO_BASE_ADDR + 0x014;

//
// Page 42 -> 2.3.17
//
// SIO GPIO Registers
//
const SIO_BASE_ADDR: u32 = 0xd0000000;
const SIO_GPIO_OUT_ENABLE_ADDR: u32 = SIO_BASE_ADDR + 0x20;
const SIO_GPIO_OUT_SET_ADDR: u32 = SIO_BASE_ADDR + 0x14;
const SIO_GPIO_OUT_CLEAR_ADDR: u32 = SIO_BASE_ADDR + 0x18;

//
// Simulate `delay` function
//
fn simulate_delay() void {
    var delay_count: u32 = 0;
    var ptr: *volatile u32 = &delay_count;
    for (0..ONE_EIGHTH_SECOND_DELAY) |value| {
        ptr.* = value;
    }
}

///
///
///
fn enable_gpio_and_wait_for_it_stable() !void {
    var bit_buffer = [_]u8{0x00} ** 33;
    try BitUtil.print_bit(
        ResetRegister.reset_control_get_value(),
        BitUtil.FormatBitWidth.FBW_32,
        &bit_buffer,
    );
    _ = c.printf(
        "\n>>> Reset control register value: %s",
        @as([*]const u8, @ptrCast(&bit_buffer)),
    );

    try BitUtil.print_bit(
        ResetRegister.reset_done_get_value(),
        BitUtil.FormatBitWidth.FBW_32,
        &bit_buffer,
    );
    _ = c.printf(
        "\n>>> Reset done register value %s:",
        @as([*]const u8, @ptrCast(&bit_buffer)),
    );

    //
    // Page 178:
    //
    // Reset control register: Set the bit5 to `0` to enable GPIO (iobank0)
    // functionality
    //
    // If your project links to `pico_stdlib` (in `CMakeLists.txt`), then somehow SDK
    // enables all functionalities by default. This can be confirmed by the following
    // steps:
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
    // To reduce the power consumption, you should disable all unnecessary peripherals and
    // only enable the one you needed:)
    //

    // Disable peripherals
    ResetRegister.reset_control_disable_peripherals(
        ResetRegister.RESET_CTL_ADC_BIT |
            ResetRegister.RESET_CTL_I2C1_BIT |
            ResetRegister.RESET_CTL_I2C0_BIT |
            ResetRegister.RESET_CTL_PWM_BIT |
            ResetRegister.RESET_CTL_SPI1_BIT |
            ResetRegister.RESET_CTL_SPI0_BIT |
            ResetRegister.RESET_CTL_UART1_BIT |
            ResetRegister.RESET_CTL_UART0_BIT |
            ResetRegister.RESET_CTL_DMA_BIT |
            ResetRegister.RESET_CTL_PIO1_BIT |
            ResetRegister.RESET_CTL_PIO0_BIT |
            ResetRegister.RESET_CTL_TBMAN_BIT,
    );

    // Enable peripherals
    //
    // For the `GPIO` peripheral, you HAVE TO enable these 2 bits:
    //
    // - RESET_CTL_PADS_BANK0_BIT: bit 8 (PADS_BANK0)
    // - RESET_CTL_IO_BANK0_BIT: bit 5 (IO_BANK0)
    //
    const enabled_peripheral_bits: u32 =
        ResetRegister.RESET_CTL_IO_QSPI_BIT | ResetRegister.RESET_CTL_TIMER_BIT | ResetRegister.RESET_CTL_USBCTRL_BIT |
        ResetRegister.RESET_CTL_SYSINFO_BIT | ResetRegister.RESET_CTL_SYSCFG_BIT | ResetRegister.RESET_CTL_RTC_BIT |
        ResetRegister.RESET_CTL_PLL_USB_BIT | ResetRegister.RESET_CTL_PLL_SYS_BIT | ResetRegister.RESET_CTL_PADS_QSPI_BIT |
        ResetRegister.RESET_CTL_PADS_BANK0_BIT | ResetRegister.RESET_CTL_JTAG_BIT | ResetRegister.RESET_CTL_IO_BANK0_BIT |
        ResetRegister.RESET_CTL_BUSCTRL_BIT;
    ResetRegister.reset_control_enable_peripherals(enabled_peripheral_bits);

    try BitUtil.print_bit(
        ResetRegister.reset_control_get_value(),
        BitUtil.FormatBitWidth.FBW_32,
        &bit_buffer,
    );
    _ = c.printf(
        "\n\n>>> Reset control register value after only enable necessary peripherals: %s",
        @as([*]const u8, @ptrCast(&bit_buffer)),
    );

    //
    // Reset done register:
    //
    // After reset option has been done, then the related bits in this register will
    // become `1`
    //
    try BitUtil.print_bit(
        ResetRegister.reset_done_get_value(),
        BitUtil.FormatBitWidth.FBW_32,
        &bit_buffer,
    );
    _ = c.printf(
        "\n>>> Rest done register value: %s",
        @as([*]const u8, @ptrCast(&bit_buffer)),
    );

    _ = c.printf("\n\n>>> Waiting for reset to be done......");
    const reset_done_reg_ptr: reg_u32 = @ptrFromInt(ResetRegister.RESET_DONE_ADDR);
    const expected_bits: u32 = @as(u32, 1) << 5;
    while ((reset_done_reg_ptr.* & expected_bits) != expected_bits) {}
    _ = c.printf("\n\n>>> Rest is done.");

    try BitUtil.print_bit(
        ResetRegister.reset_control_get_value(),
        BitUtil.FormatBitWidth.FBW_32,
        &bit_buffer,
    );
    _ = c.printf(
        "\n>>> Reset control register value after GPIO reset is done: %s",
        @as([*]const u8, @ptrCast(&bit_buffer)),
    );

    try BitUtil.print_bit(
        ResetRegister.reset_done_get_value(),
        BitUtil.FormatBitWidth.FBW_32,
        &bit_buffer,
    );
    _ = c.printf(
        "\n\n>>> Reset done register value after GPIO reset is done: %s",
        @as([*]const u8, @ptrCast(&bit_buffer)),
    );

    //
    // GPIO_X (pin) control register:
    //
    // Page 236 -> 2.19.2 Function Select:
    //
    // Each GPIO has multiple functionalites, you need to select the function you
    // needed before using it.
    //
    // Page 246(bottom)~247(top) -> IO_BANK0: GPIO0_CTRL ... CPIO29_CTRL
    // Registers:
    //
    // Set `0x5` (0000 0101) to bit0~bit4 to select the `SIO` function
    //

    // For example: select SIO function for the GPIO_0
    var gpio_0_control_reg: reg_u32 = @ptrFromInt(GPIO_0_CONTROL_ADDR);
    gpio_0_control_reg.* = 0x05;

    // For example: select SIO function for the GPIO_2
    // reg_u32 *gpio_2_control_reg = (reg_u32 *)GPIO_2_CONTROL_ADDR;
    // *gpio_2_control_reg = 0x05;

    //
    // Page 46 -> 2.3.17, SIO: GPIO_OE Register
    //
    // SIO GPIO out enable register: Set the bit{LED_PIN} to 1 to enable
    // GPIO_{LED_PIN} output mode
    //
    var gpio_out_enable_reg: reg_u32 = @ptrFromInt(SIO_GPIO_OUT_ENABLE_ADDR);
    gpio_out_enable_reg.* |= (@as(u32, 1) << LED_PIN);
}

//
//
//
fn blinking_led_loop() void {
    var gpio_out_set_reg: reg_u32 = @ptrFromInt(SIO_GPIO_OUT_SET_ADDR);
    var gpio_out_clear_reg: reg_u32 = @ptrFromInt(SIO_GPIO_OUT_CLEAR_ADDR);

    while (true) {
        //
        // Page 46 -> SIO: GPIO_OUT_SET Register
        //
        // SIO GPIO out set register: set bit{LED_PIN} to 1 for setting
        // GPIO_{LED_PIN} to high
        //
        gpio_out_set_reg.* |= (@as(u32, 1) << LED_PIN);
        simulate_delay();

        //
        // Page 46 -> SIO: GPIO_OUT_CLR Register
        //
        // SIO GPIO clear set register: set bit{LED_PIN} to 1 for setting
        // GPIO_{LED_PIN} to low
        //
        gpio_out_clear_reg.* |= (@as(u32, 1) << LED_PIN);
        simulate_delay();
    }
}

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();
    _ = c.printf("\n>>> [ Zig blink LED ]\n");

    _ = enable_gpio_and_wait_for_it_stable() catch void;
    blinking_led_loop();

    return 0;
}
