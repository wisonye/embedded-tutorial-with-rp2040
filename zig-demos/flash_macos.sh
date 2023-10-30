#!/bin/sh

if [ -z "$1" ]; then
    echo ">>>"
    echo ">>> [ Usage ]"
    echo ">>>"
    echo ">>> 1. Unplug your pico board"
    echo ">>> 2. Hold down the BOOTSEL button and re-plug your pico board for a few seconds"
    echo ">>>"
    echo ">>> ./flash_macos.sh DEMO_NAME_HERE"
    echo ">>>"
    echo ">>> [ Example ]"
    echo ">>>"
    echo ">>> ./flash_macos.sh zig-blink-builtin-led"
    echo ">>> ./flash_macos.sh zig-blink-register"
    echo ">>>"

    exit 0
fi

cp -rvf "build/${1}.uf2" /Volumes/RPI-RP2/
