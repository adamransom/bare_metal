# Raspberry Pi 3 Bare Metal Examples

This the repository for my corresponding blog over at [adamransom.github.io](https://adamransom.github.io). It will contain examples of things I learn whilst attempting to build an extremely bare-bones kernel for the Raspberry Pi 3.

## Setup

In order to run these examples, you will most notably need a Raspberry Pi 3 Model B. Whilst a lot of the same code can be used on a Raspberry Pi 2, there are some big differences early on (for example when trying to turn on the ACT LED).

Secondly you will need the [arm-none-eabi](https://launchpad.net/gcc-arm-embedded/+download) toolchain to assemble, link and generate a binary image to put on your SD card.

Finally you will need [make](https://www.gnu.org/software/make/) if you want to make building the examples easier.

## Usage

If you have `make` installed, all you need to do is `cd` into an example directory and run:

```Bash
make
```

Then you will need to copy the generated `kernel.img` to your SD card, along with the [Raspberry Pi boot files](https://github.com/raspberrypi/firmware/tree/master/boot) (`bootloader.bin` and `start.elf`), put the card carefully in your Pi and you are good to go!
