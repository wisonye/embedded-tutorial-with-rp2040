#ifndef __RP2040_REG_RESET_H__
#define __RP2040_REG_RESET_H__

// #include <stdint.h>

typedef __UINT32_TYPE__ u32;

//
// RP2040 memory-mapped IO always use 32bit for reading and writing. That's why you will see
// the following type defined in:
//
// ./src/rp2_common/hardware_base/include/hardware/address_mapped.h
//
// typedef volatile uint32_t io_rw_32; // IO read-write 32bit
//
typedef volatile u32 reg_u32;

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
#define ATOMIC_NORMAL_READ_WRITE_OFFSET 0x0000
#define ATOMIC_XOR_ON_WRITE_OFFSET 0x1000
#define ATOMIC_SET_ON_WRITE_OFFSET 0x2000
#define ATOMIC_CLEAR_ON_WRITE_OFFSET 0x3000



// ---------------------------------------------------------------------------------------
// Subssytem reset registers
// ---------------------------------------------------------------------------------------
//
// Page 177 -> 2.14.3
//
// Reset Registers
//
#define RESET_BASE_ADDR					0x4000c000
#define RESET_CONTROL_ADDR				(RESET_BASE_ADDR + 0x00)
#define RESET_WATCH_DOG_SELCECT_ADDR	(RESET_BASE_ADDR + 0x04)
#define RESET_DONE_ADDR					(RESET_BASE_ADDR + 0x08)

__attribute__((always_inline)) inline u32 reset_control_get_value() {
	return *(reg_u32 *)(RESET_CONTROL_ADDR);
}

__attribute__((always_inline)) inline u32 reset_watch_dog_select_get_value() {
    return *(reg_u32 *)(RESET_WATCH_DOG_SELCECT_ADDR);
}

__attribute__((always_inline)) inline u32 reset_done_get_value() {
    return *(reg_u32 *)(RESET_DONE_ADDR);
}

// ---------------------------------------------------------------------------------------
// Reset Control Register
// ---------------------------------------------------------------------------------------

//
// `RESET_CONTROL_ADDR` is a read-write register to control which peripheral is enable or
// disable, and its rule look like this:
// 
// - Write ~1~ to the particular bit to disable the given peripheral
// - Write ~0~ to the particular bit to enable  the given peripheral
// 
// And here is the bit table:
// Reset Control Register bit table:
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

#define RESET_CTL_USBCTRL_BIT       ((u32)1 << 24)
#define RESET_CTL_UART1_BIT         ((u32)1 << 23)
#define RESET_CTL_UART0_BIT         ((u32)1 << 22)
#define RESET_CTL_TIMER_BIT         ((u32)1 << 21)
#define RESET_CTL_TBMAN_BIT         ((u32)1 << 20)
#define RESET_CTL_SYSINFO_BIT       ((u32)1 << 19)
#define RESET_CTL_SYSCFG_BIT        ((u32)1 << 18)
#define RESET_CTL_SPI1_BIT          ((u32)1 << 17)
#define RESET_CTL_SPI0_BIT          ((u32)1 << 16)
#define RESET_CTL_RTC_BIT           ((u32)1 << 15)
#define RESET_CTL_PWM_BIT           ((u32)1 << 14)
#define RESET_CTL_PLL_USB_BIT       ((u32)1 << 13)
#define RESET_CTL_PLL_SYS_BIT       ((u32)1 << 12)
#define RESET_CTL_PIO1_BIT          ((u32)1 << 11)
#define RESET_CTL_PIO0_BIT          ((u32)1 << 10)
#define RESET_CTL_PADS_QSPI_BIT     ((u32)1 << 9)
#define RESET_CTL_PADS_BANK0_BIT    ((u32)1 << 8)
#define RESET_CTL_JTAG_BIT          ((u32)1 << 7)
#define RESET_CTL_IO_QSPI_BIT       ((u32)1 << 6)
#define RESET_CTL_IO_BANK0_BIT      ((u32)1 << 5)
#define RESET_CTL_I2C1_BIT          ((u32)1 << 4)
#define RESET_CTL_I2C0_BIT          ((u32)1 << 3)
#define RESET_CTL_DMA_BIT           ((u32)1 << 2)
#define RESET_CTL_BUSCTRL_BIT       ((u32)1 << 1)
#define RESET_CTL_ADC_BIT           ((u32)1 << 0)

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
void reset_control_disable_peripherals(u32 disable_peripheral_bits);

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
void reset_control_enable_peripherals(u32 enable_peripheral_bits);

///
///
///
void reset_done_wait_for_enabled_peripherals_ready(u32 enabled_peripheral_bits);
#endif
