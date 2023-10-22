#include "reset.h"

///
///
///
__attribute__((always_inline)) inline void atomic_reg_set_bits(reg_u32 reg_address,
                                                               u32 bitmask_to_set_1) {
    *(reg_u32 *)(reg_address | ATOMIC_SET_ON_WRITE_OFFSET) = bitmask_to_set_1;
}

///
///
///
__attribute__((always_inline)) inline void atomic_reg_clear_bits(reg_u32 reg_address,
                                                                 u32 bitmask_to_set_0) {
    *(reg_u32 *)(reg_address | ATOMIC_CLEAR_ON_WRITE_OFFSET) = bitmask_to_set_0;
}

///
///
///
__attribute__((always_inline)) inline void atomic_reg_toggle_bits(reg_u32 reg_address,
                                                                  u32 bitmask_to_toggle) {
    *(reg_u32 *)(reg_address | ATOMIC_XOR_ON_WRITE_OFFSET) = bitmask_to_toggle;
}

///
///
///
void reset_control_disable_peripherals(u32 disable_peripheral_bits) {
    atomic_reg_set_bits(RESET_CONTROL_ADDR, disable_peripheral_bits);
}

///
///
///
void reset_control_enable_peripherals(u32 enable_peripheral_bits) {
    atomic_reg_clear_bits(RESET_CONTROL_ADDR, enable_peripheral_bits);
}

///
///
///
void reset_done_wait_for_enabled_peripherals_ready(u32 enabled_peripheral_bits) {}
