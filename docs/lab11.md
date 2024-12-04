
# Lab 11 #

## Overview ##

Created the device driver

## Deliverables ##

Just the demonstration

## Questions ##

Q: What is the purpose of the platform bus?

A: It connects devices to the cpu

Q: What is the probe function's purpose?

A: To bind a device to a driver

Q: How does your driver know what memory addresses are associated with your device?

A: via the reg section of the device tree

Q: What are the two ways we can write to our device regsiters?

A: Via the sys/devices/platform/<address>.led_patterns directory and shell scripts

Q: What is the purpose of our struct led_patterns_dev state container?

A: It contians the pointers for the registers used in I/O memory
