#!/bin/sh
# Botslab C213: GPIO state at every boot (run by S30customizer, before S40network).

# Ethernet PHY reset: GPIO52 (PB20), active low. Without this pulse the PHY
# answers on MDIO but never brings the link up. Same sequence as the stock
# U-Boot "ethphy reset": high, low for 50 ms, high.
gpio set 52 >/dev/null
usleep 10000
gpio clear 52 >/dev/null
usleep 50000
gpio set 52 >/dev/null
usleep 100000

# TMI8152 (motors + IR-cut) power stage enable: GPIO63 (PB31), high.
# Stock audio.ko holds it high as its default spk_gpio; on this board the
# speaker amplifier is GPIO53, and without 63 the TMI reports a fault
# (0x02 reads 0x12 instead of 0x03) and drives nothing.
gpio set 63 >/dev/null

# Status LEDs are active low: high = off. Blue off, green on (power).
gpio set 57 >/dev/null
gpio clear 50 >/dev/null
