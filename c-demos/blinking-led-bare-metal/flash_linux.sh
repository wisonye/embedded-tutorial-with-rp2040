#!/bin/sh

if [ -z "$1" ]; then
    echo ">>>"
    echo ">>> [ Usage ]"
    echo ">>>"
    echo ">>> 1. Unplug your pico board"
    echo ">>> 2. Hold down the BOOTSEL button and re-plug your pico board for a few seconds"
    echo ">>> 3. Run 'lsblk' or 'doas dmesg | tail' to confirm pico attached as USB device"
    echo ">>>"
    echo ">>> doas ./flash_linux.sh DEMO_NAME_HERE"
    echo ">>>"
    echo ">>> [ Example ]"
    echo ">>>"
    echo ">>> doas ./flash_linux.sh blinking-led"
    echo ">>>"

    exit 0
fi

rm -rf /mnt/pico
mkdir /mnt/pico
mount /dev/sdb1 /mnt/pico
cp -rvf "build/${1}.uf2" /mnt/pico
umount /mnt/pico
