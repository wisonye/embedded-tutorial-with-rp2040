#ifndef __UTILS_BITS_H__
#define __UTILS_BITS_H__

#include <stdbool.h>
#include <stdint.h>

/* typedef struct U8Bits { */
/*     char bits[8 + 1]; */
/* } U8Bits; */

/* typedef struct U16Bits { */
/*     char bits[16 + 1]; */
/* } U16Bits; */

/* typedef struct U32Bits { */
/*     char bits[32 + 1]; */
/* } U32Bits; */

/* typedef struct U64Bits { */
/*     char bits[64]; */
/* } U64Bits; */

//
// Get back `U8Bits` by u8
//
/* U8Bits get_bits_u8(uint8_t v) { */
/*     U8Bits result = {.bits = "00000000"}; */
/*     result.bits[7] = v & 0x01 ? '1' : '0'; */
/*     result.bits[6] = v & 0x02 ? '1' : '0'; */
/*     result.bits[5] = v & 0x04 ? '1' : '0'; */
/*     result.bits[4] = v & 0x08 ? '1' : '0'; */
/*     result.bits[3] = v & 0x10 ? '1' : '0'; */
/*     result.bits[2] = v & 0x20 ? '1' : '0'; */
/*     result.bits[1] = v & 0x40 ? '1' : '0'; */
/*     result.bits[0] = v & 0x80 ? '1' : '0'; */
/*     result.bits[8] = '\0'; */

/*     return result; */
/* } */

#ifdef ENABLE_DEBUG_LOG

//
//
//
#define _FILL_BITS(_BUFFER, TYPE, VALUE, LOG_PREFIX)                       \
    size_t total_bits = (sizeof(TYPE) * 8);                                \
    TYPE temp_value = VALUE;                                               \
    for (size_t bit = 0; bit < total_bits; bit++) {                           \
        _BUFFER[total_bits - bit - 1] = temp_value & 0x01 ? '1' : '0';     \
        temp_value = temp_value >> 1;                                      \
    }                                                                      \
    _BUFFER[total_bits] = '\0';                                            \
    DEBUG_LOG(Bits, PRINT_BITS #LOG_PREFIX, ">>> 0x%02lX bits: %s", VALUE, \
              _BUFFER);

//
// Get back data type name as static `char *`
//
#define PRINT_BITS(V)                                                          \
    {                                                                          \
        size_t type_size =                                                     \
            _Generic((V), unsigned char                                        \
                     : sizeof(unsigned char), char                             \
                     : sizeof(char), signed char                               \
                     : sizeof(signed char), short int                          \
                     : sizeof(short int), unsigned short int                   \
                     : sizeof(unsigned short int), int                         \
                     : sizeof(int), unsigned int                               \
                     : sizeof(unsigned int), long int                          \
                     : sizeof(long int), unsigned long int                     \
                     : sizeof(unsigned long int), long long int                \
                     : sizeof(long long int), unsigned long long int           \
                     : sizeof(unsigned long long int), default                 \
                     : sizeof(uint8_t));                                       \
                                                                               \
        if (type_size == 1) {                                                  \
            char buffer[9] = {"00000000"};                                     \
            _FILL_BITS(buffer, uint8_t, V, u08);                               \
        } else if (type_size == 2) {                                           \
            char buffer[17] = {"0000000000000000"};                            \
            _FILL_BITS(buffer, uint16_t, V, u16);                              \
        } else if (type_size == 4) {                                           \
            char buffer[33] = {"00000000000000000000000000000000"};            \
            _FILL_BITS(buffer, uint32_t, V, u32);                              \
        } else if (type_size == 8) {                                           \
            char buffer[65] = {                                                \
                "000000000000000000000000000000000000000000000000000000000000" \
                "0000"};                                                       \
            _FILL_BITS(buffer, uint64_t, V, u64);                              \
        } else {                                                               \
            char buffer[9] = {"00000000"};                                     \
            _FILL_BITS(buffer, uint8_t, V, u8);                                \
        }                                                                      \
    }

//
//
//
#define BIT_IS_1(V, WHICH_BIT) (v >> (which_bit - 1) & 0x01)

#else

/** Define as nothing when `ENABLE_DEBUG_LOG` is undefined!!! **/
#define _FILL_BITS(V)
#define PRINT_BITS(V)
#define BIT_IS_1(V, WHICH_BIT)

#endif

#endif
