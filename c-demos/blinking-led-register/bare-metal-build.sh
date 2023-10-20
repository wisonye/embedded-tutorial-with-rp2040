#!/bin/sh

rm -rf build

#
# ARM toolchain path check
#
ARM_GCC_PATH=$(which arm-none-eabi-gcc)

# echo "ARM_GCC_PATH: ${ARM_GCC_PATH}"
if [ -z "$ARM_GCC_PATH" ]; then
    echo ">>>"
    echo ">>> Can't find 'arm-none-eabi-gcc', plz add to your PATH env var and try again"
    echo ">>>"
fi

mkdir build

# -mcpu=cortex-m0plus         # Specify the name of the target processor,
# -mthumb                     # Use `Thumb` cpu instruction set
# -O3                         # Optimization level 3
# -DNDEBUG                    # No Debug
#
# `-W` prefix means pass the following option to linker `arm-none-eabi-ld`
#
# Print a link map to the file which contains the memory layout of all symbols
#
# -Wl,-Map=blinking-led.elf.map
#
# Specify the MCU linker which contains the correct memory layout
#
# -Wl,--script=compile_files/linker_script.ld

#
# Compile step
#
${ARM_GCC_PATH} -c -mcpu=cortex-m0plus -mthumb -O0 -DNDEBUG -Wall -std=gnu11 \
		-o build/blinking-led.o \
		src/blinking-led.c

${ARM_GCC_PATH} -c -mcpu=cortex-m0plus -mthumb -O0 -DNDEBUG -Wall -std=gnu11 \
		-o build/bs2_default_padded_checksummed.S.o \
		compile_files/bs2_default_padded_checksummed.S

${ARM_GCC_PATH} -c -mcpu=cortex-m0plus -mthumb -O0 -DNDEBUG -Wall -std=gnu11 \
		-o build/vertor_table.S.o \
		compile_files/vertor_table.S

#
# Link step
#
${ARM_GCC_PATH} -nostdlib \
		--entry=main \
		-T compile_files/linker_script.ld \
		-Wl,-Map=build/blinking-led.elf.map \
		-o build/blinking-led.elf \
		build/bs2_default_padded_checksummed.S.o \
		build/vertor_table.S.o \
		build/blinking-led.o 

#
# Convert ELF to UF2
#
ELF_TO_UF2=./compile_files/elfuf2-linux
OS_TYPE=`uname -s`
if [ "${OS_TYPE}" = "Darwin" ]; then
    ELF_TO_UF2=./compile_files/elfuf2-macos
fi

${ELF_TO_UF2} build/blinking-led.elf build/blinking-led.uf2

#
# Done
#
cd ..
echo ""
echo ">>> Built blinking-led bare metal successfully"
echo ""
