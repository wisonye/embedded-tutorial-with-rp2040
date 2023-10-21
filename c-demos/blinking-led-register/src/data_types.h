#ifndef __DATA_TYPES_H__
#define __DATA_TYPES_H__

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

//
// Rust integer types
//
typedef uint8_t u8;
typedef uint8_t uint8;
typedef uint16_t u16;
typedef uint16_t uint16;
typedef uint32_t u32;
typedef uint32_t uint32;
typedef uint64_t u64;
typedef uint64_t uint64;
typedef size_t usize;
typedef int8_t i8;
typedef int8_t int8;
typedef int16_t i16;
typedef int16_t int16;
typedef int32_t i32;
typedef int32_t int32;
typedef int64_t i64;
typedef int64_t int64;
typedef int64_t isize;

//
// Rust string literal
//
typedef char *_str;

//
// Type name from a given variable
//
// https://learn.microsoft.com/en-us/cpp/c-language/generic-selection?view=msvc-170
//
#define TYPE_NAME(v) \
    _Generic((v),                                                   \
    bool: "bool",                                                   \
    unsigned char: "unsigned char",                                 \
    char: "char",                                                   \
    signed char: "signed char",                                     \
    short int: "short int",                                         \
    unsigned short int: "unsigned short int",                       \
    int: "int",                                                     \
    unsigned int: "unsigned int",                                   \
    long int: "long int",                                           \
    unsigned long int: "unsigned long int",                         \
    long long int: "long long int",                                 \
    unsigned long long int: "unsigned long long int",               \
    float: "float",                                                 \
    double: "double",                                               \
    long double: "long double",                                     \
    char *: "pointer to char",                                      \
    void *: "pointer to void",                                      \
    bool *: "pointer to bool",                                      \
    unsigned char *: "pointer to unsigned char",                    \
    signed char *: "pointer to signed char",                        \
    short int *: "pointer to short int",                            \
    unsigned short int *: "pointer to unsigned short int",          \
    int *: "pointer to int",                                        \
    unsigned int *: "pointer to unsigned int",                      \
    long int *: "pointer to long int",                              \
    unsigned long int *: "pointer to unsigned long int",            \
    long long int *: "pointer to long long int",                    \
    unsigned long long int *: "pointer to unsigned long long int",  \
    float *: "pointer to float",                                    \
    double *: "pointer to double",                                  \
    long double *: "pointer to long double",                        \
    default: "Unknown")

//
//
//
#define IS_THE_SAME_TYPE(v_a, v_b, v_result)                               \
    {                                                                      \
        char _a_type[50] = TYPE_NAME((v_a));                               \
        char _b_type[50] = TYPE_NAME((v_b));                               \
        int is_same_str_non_case_sensitive = strcasecmp(_a_type, _b_type); \
        v_result = (is_same_str_non_case_sensitive == 0);                  \
    }

//
// Type name from type
//
#define TYPE_NAME_TO_STRING(T) (char *)(#T)

//
// Type size from variable
//
#define TYPE_SIZE(V) \
    _Generic((V),                                               \
    bool: sizeof(bool),                                         \
    unsigned char: sizeof(unsigned char),                       \
    char: sizeof(char),                                         \
    signed char: sizeof(signed char),                           \
    short int: sizeof(short int),                               \
    unsigned short int: sizeof(unsigned short int),             \
    int: sizeof(int),                                           \
    unsigned int: sizeof(unsigned int),                         \
    long int: sizeof(long int),                                 \
    unsigned long int: sizeof(unsigned long int),               \
    long long int: sizeof(long long int),                       \
    unsigned long long int: sizeof(unsigned long long int),     \
    float: sizeof(float),                                       \
    double: sizeof(double),                                     \
    long double: sizeof(long double),                           \
    char *: sizeof(char*),                                      \
    void *: sizeof(void*),                                      \
    bool *: sizeof(bool*),                                      \
    unsigned char *: sizeof(unsigned char*),                    \
    signed char *: sizeof(signed char*),                        \
    short int *: sizeof(short int*),                            \
    unsigned short int *: sizeof(unsigned short int*),          \
    int *: sizeof(int*),                                        \
    unsigned int *: sizeof(unsigned int*),                      \
    long int *: sizeof(long int*),                              \
    unsigned long int *: sizeof(unsigned long int*),            \
    long long int *: sizeof(long long int*),                    \
    unsigned long long int *: sizeof(unsigned long long int*),  \
    float *: sizeof(float*),                                    \
    double *: sizeof(double*),                                  \
    long double *: sizeof(long double*),                        \
    default : 0)

//
// Type size from type name
//
#define TYPE_SIZE_FROM_TYPE(T) sizeof(T)

#endif
