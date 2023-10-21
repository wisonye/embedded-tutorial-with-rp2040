#ifndef __UTILS_LOG_H__
#define __UTILS_LOG_H__

#include <stdbool.h>
#include <stdio.h>

#include "data_types.h"

//
// Print integer
//
void print_u8(char *v_name, u8 v);
void print_u16(char *v_name, u16 v);
void print_u32(char *v_name, u32 v);
void print_u64(char *v_name, u64 v);
void print_usize(char *v_name, usize v);
void print_i8(char *v_name, i8 v);
void print_i16(char *v_name, i16 v);
void print_i32(char *v_name, i32 v);
void print_i64(char *v_name, i64 v);
void print_int(char *v_name, i32 v);
void print_long(char *v_name, long v);
void print_char(char *v_name, char v);
void print_bool(char *v_name, bool v);
void print_float(char *v_name, float v);
// void print_double(char *v_name, double v) { printf("\n>>> %s: %f", v_name,
// v); }
void print_long_double(char *v_name, long double v);
void print_string(char *v_name, char *v);
void print_const_string(char *v_name, const char *v);

//
// Print pointer
//
void print_void_ptr(char *v_name, void *v);
void print_bool_ptr(char *v_name, bool *v);
void print_u8_ptr(char *v_name, u8 *v);
void print_u16_ptr(char *v_name, u16 *v);
void print_u32_ptr(char *v_name, u32 *v);
void print_usize_ptr(char *v_name, usize *v);
void print_u64_ptr(char *v_name, u64 *v);
void print_i8_ptr(char *v_name, i8 *v);
void print_i16_ptr(char *v_name, i16 *v);
void print_i32_ptr(char *v_name, i32 *v);
void print_i64_ptr(char *v_name, i64 *v);
void print_float_ptr(char *v_name, float *v);
void print_double_ptr(char *v_name, double *v);
void print_long_double_ptr(char *v_name, long double *v);

/**
 * Internal log buffer size, set to 256 by default. Increase it if
 * you encounter long content in case.
 */
#define LOG_BUFFER_SIZE 256
// #define LOG_BUFFER_LEN 1024

//
typedef enum LogLevel { LL_DEBUG, LL_INFO, LL_WARN, LL_ERROR } LogLevel;

/**
 * Log
 */
void __log__(LogLevel log_level, const char *module_name,
             const char *function_name, const char *format_str, ...);

#ifdef ENABLE_DEBUG_LOG

/**
 * Log the variable value based the primitive type, only available when defined
 * `ENABLE_DEBUG_LOG`
 */
#define LOG_VAR(V) \
    _Generic((V), \
        _Bool: print_bool, \
        unsigned char: print_u8, \
        char: print_char, \
        signed char: print_i8, \
        short int: print_i16, \
        unsigned short int: print_u16, \
        int: print_int, \
        unsigned int: print_u32, \
        long int: print_long, \
        unsigned long int: print_usize, \
        long long int: print_i64, \
        unsigned long long int: print_u64, \
        float: print_float, \
        double: print_long_double, \
        long double: print_long_double, \
        char *: print_string, \
        const char *: print_const_string, \
        void *: print_void_ptr, \
        _Bool *: print_bool_ptr, \
        unsigned char *: print_u8_ptr, \
        unsigned short int *: print_u16_ptr, \
        unsigned int *: print_u32_ptr, \
        unsigned long int *: print_usize_ptr,            \
        unsigned long long int *: print_u64_ptr,  \
        signed char *: print_i8_ptr, \
        short int *: print_i16_ptr, \
        int *: print_i32_ptr, \
        long int *: print_i64_ptr, \
        long long int *: print_i64_ptr, \
        float *: print_float_ptr, \
        double *: print_double_ptr, \
        long double *: print_long_double_ptr, \
        default : print_const_string)(#V, (V))

#else

/** Define as nothing when `ENABLE_DEBUG_LOG` is undefined!!! **/
#define LOG_VAR(V)

#endif

/**
 * Debug log
 */
#define DEBUG_LOG(MODULE_NAME, FUNCTION_NAME, format_str, ...) \
    __log__(LL_DEBUG, #MODULE_NAME, #FUNCTION_NAME, format_str, __VA_ARGS__)

/**
 * Info log
 */
#define INFO_LOG(MODULE_NAME, FUNCTION_NAME, format_str, ...) \
    __log__(LL_INFO, #MODULE_NAME, #FUNCTION_NAME, format_str, __VA_ARGS__)

/**
 * Warn log
 */
#define WARN_LOG(MODULE_NAME, FUNCTION_NAME, format_str, ...) \
    __log__(LL_WARN, #MODULE_NAME, #FUNCTION_NAME, format_str, __VA_ARGS__)

/**
 * Error log
 */
#define ERROR_LOG(MODULE_NAME, FUNCTION_NAME, format_str, ...) \
    __log__(LL_ERROR, #MODULE_NAME, #FUNCTION_NAME, format_str, __VA_ARGS__)

#endif
