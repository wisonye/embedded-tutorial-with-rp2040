#include <stdio.h>

#include "bits.h"
#include "pico/stdlib.h"
#include "register/reset.h"

#define LED_PIN 2

//
// Purpose that base metal boot in 48MHz (48,000,000 tick in one second) without
// clock configuration
//
#define CLK_SPEED 48000000
#define HALF_SECOND_DELAY (u32)(CLK_SPEED / 2)
#define ONE_QUARTER_SECOND_DELAY (u32)(CLK_SPEED / 4)
#define ONE_EIGHTH_SECOND_DELAY (u32)(CLK_SPEED / 8)

//
// Page 243 -> 2.19.6.1 IO - User Bank
//
// GPIO Registers
//
#define GPIO_BASE_ADDR 0x40014000
#define GPIO_0_CONTROL_ADDR (GPIO_BASE_ADDR + 0x004)
#define GPIO_2_CONTROL_ADDR (GPIO_BASE_ADDR + 0x014)

//
// Page 42 -> 2.3.17
//
// SIO GPIO Registers
//
#define SIO_BASE_ADDR 0xd0000000
#define SIO_GPIO_OUT_ENABLE_ADDR (SIO_BASE_ADDR + 0x20)
#define SIO_GPIO_OUT_SET_ADDR (SIO_BASE_ADDR + 0x14)
#define SIO_GPIO_OUT_CLEAR_ADDR (SIO_BASE_ADDR + 0x18)

//
// Simulate `delay` function
//
void simulate_delay(void) {
    volatile uint32_t _ = 0;
    for (uint32_t i = 0; i < ONE_EIGHTH_SECOND_DELAY; i++) {
        _ = i;
    }
}

///
///
///
void enable_gpio_and_wait_for_it_stable(void) {
    printf("\n>>> Reset control register value:");
    PRINT_BITS(reset_control_get_value());

    printf("\n>>> Reset done register value:");
    PRINT_BITS(reset_done_get_value());
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
    reset_control_disable_peripherals(
        RESET_CTL_ADC_BIT | RESET_CTL_I2C1_BIT | RESET_CTL_I2C0_BIT | RESET_CTL_PWM_BIT |
        RESET_CTL_SPI1_BIT | RESET_CTL_SPI0_BIT | RESET_CTL_UART1_BIT |
        RESET_CTL_UART0_BIT | RESET_CTL_DMA_BIT | RESET_CTL_PIO1_BIT |
        RESET_CTL_PIO0_BIT | RESET_CTL_TBMAN_BIT);

    // Enable peripherals
    //
    // For the `GPIO` peripheral, you HAVE TO enable these 2 bits:
    //
    // - RESET_CTL_PADS_BANK0_BIT: bit 8 (PADS_BANK0)
    // - RESET_CTL_IO_BANK0_BIT: bit 5 (IO_BANK0)
    //
    u32 enabled_peripheral_bits =
        RESET_CTL_IO_QSPI_BIT | RESET_CTL_TIMER_BIT | RESET_CTL_USBCTRL_BIT |
        RESET_CTL_SYSINFO_BIT | RESET_CTL_SYSCFG_BIT | RESET_CTL_RTC_BIT |
        RESET_CTL_PLL_USB_BIT | RESET_CTL_PLL_SYS_BIT | RESET_CTL_PADS_QSPI_BIT |
        RESET_CTL_PADS_BANK0_BIT | RESET_CTL_JTAG_BIT | RESET_CTL_IO_BANK0_BIT |
        RESET_CTL_BUSCTRL_BIT;
    reset_control_enable_peripherals(enabled_peripheral_bits);

    printf(
        "\n\n>>> Reset control register value after only enable necessary peripherals:");
    PRINT_BITS(reset_control_get_value());

    //
    // Reset done register:
    //
    // After reset option has been done, then the related bits in this register will
    // become `1`
    //
    printf("\n>>> Rest done register value:");
    PRINT_BITS(reset_done_get_value());

    printf("\n\n>>> Waiting for reset to be done......");
    reg_u32 *reset_done_reg = (reg_u32 *)RESET_DONE_ADDR;
    while (!(*reset_done_reg & ((u32)1 << 5))) {
    }
    printf("\n\n>>> Rest is done.");

    printf("\n>>> Reset control register value after GPIO reset is done:");
    PRINT_BITS(reset_control_get_value());
    printf("\n\n>>> Reset done register value after GPIO reset is done:");
    PRINT_BITS(reset_done_get_value());

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
    // reg_u32 *gpio_0_control_reg = (reg_u32*)GPIO_0_CONTROL_ADDR;
    // *gpio_0_control_reg = 0x05;

    // For example: select SIO function for the GPIO_2
    reg_u32 *gpio_2_control_reg = (reg_u32 *)GPIO_2_CONTROL_ADDR;
    *gpio_2_control_reg = 0x05;

    //
    // Page 46 -> 2.3.17, SIO: GPIO_OE Register
    //
    // SIO GPIO out enable register: Set the bit{LED_PIN} to 1 to enable
    // GPIO_{LED_PIN} output mode
    //
    reg_u32 *gpio_out_enable_reg = (reg_u32 *)SIO_GPIO_OUT_ENABLE_ADDR;
    *gpio_out_enable_reg |= ((u32)1 << LED_PIN);
}

//
//
//
void blinking_led_loop(void) {
    reg_u32 *gpio_out_set_reg = (reg_u32 *)SIO_GPIO_OUT_SET_ADDR;
    reg_u32 *gpio_out_clear_reg = (reg_u32 *)SIO_GPIO_OUT_CLEAR_ADDR;

    while (1) {
        //
        // Page 46 -> SIO: GPIO_OUT_SET Register
        //
        // SIO GPIO out set register: set bit{LED_PIN} to 1 for setting
        // GPIO_{LED_PIN} to high
        //
        *gpio_out_set_reg |= ((u32)1 << LED_PIN);
        simulate_delay();

        //
        // Page 46 -> SIO: GPIO_OUT_CLR Register
        //
        // SIO GPIO clear set register: set bit{LED_PIN} to 1 for setting
        // GPIO_{LED_PIN} to low
        //
        *gpio_out_clear_reg |= ((u32)1 << LED_PIN);
        simulate_delay();
    }
}

//
//
//
int main(void) {
    stdio_init_all();
    printf("\n>>> [ blinking-led-register ]\n");

    enable_gpio_and_wait_for_it_stable();
    blinking_led_loop();

    return 0;
}
