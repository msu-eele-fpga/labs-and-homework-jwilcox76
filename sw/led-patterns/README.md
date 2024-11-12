### Usage ###

    `input arguments: -h, -v, -f <filename>, -p <time-value pairs>`
    `Cannot have both -f and -p values toggled`
    `for help: -h`

### Building ###

To cross compile:

`/usr/bin/arm-linux-gnueabihf-gcc -o led-patterns led-patterns.c`

### Programming w/ FPGA ###

In order for this program to run it must connect with dev/mem which gives it access to the FPGA's registor memrory
