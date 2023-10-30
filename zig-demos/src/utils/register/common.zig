//
// RP2040 memory-mapped IO always use 32bit for reading and writing. That's why you will see
// the following type defined in:
//
// ./src/rp2_common/hardware_base/include/hardware/address_mapped.h
//
// typedef volatile uint32_t io_rw_32; // IO read-write 32bit
//
pub const reg_u32 = *volatile u32;
