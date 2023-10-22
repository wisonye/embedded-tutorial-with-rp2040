#!/bin/sh

if [ -z "$1" ]; then
    echo ">>>"
    echo ">>> [ Usage ]"
    echo ">>>"
    echo ">>> Linux: doas ./minicom.sh /dev/YOUR_TTY_DEVICE"
    echo ">>> MacOS: ./minicom.sh /dev/YOUR_TTY_DEVICE"
    echo ">>>"
    echo ">>> [ Example ]"
    echo ">>>"
    echo ">>> Linux: doas ./minicom.sh /dev/ttyACM0"
    echo ">>> MacOS: ./minicom.sh /dev/tty.usbmodem14701"
    echo ">>>"

    exit 0
fi

echo "Try to connect to TTY device: ${1}"

minicom --device ${1} --baudrate 115200 --noinit
