# Blinking WIFI LED (`CYW43_WL_GPIO_LED_PIN`)

## 1. Configure cmake

- You need to provide the `PICO_SDK_PATH` env var and set to your `pico-sdk` git
clone folder!!!

    For example, I use `PICO_SDK_PATH=~/pico/pico-sdk`.

    </br>

- You need provide the `PICO_TOOLCHAIN_PATH` env var if `arm-none-eabi-gcc` is
not in ypur `$PATH`

    For example, I use `PICO_TOOLCHAIN_PATH=~/Downloads/arm-gnu-toolchain/bin`

    </br>

Run the following command:

```bash
# For example
PICO_SDK_PATH=~/pico/pico-sdk \
PICO_TOOLCHAIN_PATH=~/Downloads/arm-gnu-toolchain/bin \
./configure.sh
```

</br>

## 2. How to build and flash pico

- Build the entire project

    ```bash
    ./build.sh
    ```

    </br>

- Replugin the Pico boards into flash mode

    Unplug your pico board and keep holding down the `BOOTSEL` button and plug
    the pico board in, only release the `BOOTSEL` after you see a new volume
    shows up as an external USB drive.

    Then copy the `uf2` binary to the external USB drive, when it done, the
    external USB drive will disappear and reset to run your program:)

    ```bash
    # For example, flash the `binlinking-led` to pico board on MacOS
    cp -rvf ./build/blinking-led.uf2 /Volumes/RPI-RP2/
    ```

    </br>


## 3. How to see `printf` output via serial port

```bash
./minicom.sh

# Welcome to minicom 2.8
#
# OPTIONS:
# Compiled on Jan  4 2021, 00:04:46.
# Port /dev/tty.usbmodem145201, 10:28:40
#
# Press Meta-Z for help on special keys
#
# [ Blinking LED Demo ]
# WFI LED is on: true
# WFI LED is on: false
# WFI LED is on: true
# WFI LED is on: false
# WFI LED is on: true
# .... (ignore the same output)
```

</br>

If you connect to the wrong serial port, then run `killall minicon` and try
another serial port.

</br>

BTW, the `Meta-Z` doesn't work on `MacOS + Alacritty` at this moment. So,
`kill minicom` is my way to exit the `minicom` program.

</br>

## 4. Use `zig build` to compile project

```bash
clear && PICO_SDK_PATH=~/pico/pico-sdk zig build
```

</br>

