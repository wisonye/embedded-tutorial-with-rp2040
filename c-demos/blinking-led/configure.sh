#!/bin/sh

#
# Remove everything exists
#
rm -rf build

#
#
#
ARM_GCC_PATH=$(which arm-none-eabi-gcc)

# echo "ARM_GCC_PATH: ${ARM_GCC_PATH}"
if [ -z "$ARM_GCC_PATH" ]; then
    PICO_TOOLCHAIN_PATH=$(echo $PICO_TOOLCHAIN_PATH)
    # echo "PICO_TOOLCHAIN_PATH: ${PICO_TOOLCHAIN_PATH}"

    if [ -z "$PICO_TOOLCHAIN_PATH" ]; then
        echo ">>>"
        echo ">>> Can't find 'arm-none-eabi-gcc', if it doesn't in your PATH, plz set it via 'PICO_TOOLCHAIN_PATH' env var and try again"
        echo ">>>"

        exit 0
    else
        echo ">>> PICO_TOOLCHAIN_PATH: ${PICO_TOOLCHAIN_PATH}"
    fi
fi

#
# Run cmake to generate all files
#
cmake -DPICO_BOARD=pico_w -S ./ -B ./build
