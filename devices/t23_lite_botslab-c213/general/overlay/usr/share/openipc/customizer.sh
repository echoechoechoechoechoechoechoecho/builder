#!/bin/sh
#
# Botslab C213: one-time settings on first boot (run by S30customizer).
#

# Sensor is not auto-detected by sinfo (no sc3332 entry): pin it.
fw_setenv sensor sc3332

# SD card detect is PB19 (51). The loader default 59 (PB27) is an SSI0 pin
# used by the TMI8152 motor driver and must not be claimed by jzmmc.
fw_setenv gpio_mmc 51

# Wi-Fi: ATBM6012B combo over USB, atbm603x driver (stock: atbm603x_wifi_usb wifi_bt_comb=1)
fw_setenv wlandev atbm603x-generic-usb
#fw_setenv wlanssid Router
#fw_setenv wlanpass 12345678

# Memory split for the OpenIPC U-Boot (the stock U-Boot takes it from bootargs).
# Stock used 19.5M rmem with ISP direct_mode; majestic needs 24M for 2304x1296.
fw_setenv osmem 40M@0x0
fw_setenv rmem 24M@0x2800000

# Majestic
cli -s .video0.codec h264
# Image comes out upside down with the stock sensor driver (shvflip=1);
# the stock app turned it in the ISP. Checked on the camera: both flags.
cli -s .image.flip true
cli -s .image.mirror true
# Sensor gives 2304x1296, but the T23 H.264 encoder rejects a 1296-line NV12
# buffer ("invalidate input nal buffer align"): height must be a multiple of 32.
cli -s .video0.size 2304x1280
cli -s .nightMode.lightMonitor true
cli -s .nightMode.backlightPin 49
cli -s .nightMode.monitorDelay 5
cli -s .osd.enabled true
cli -s .audio.enabled true
cli -s .audio.codec aac
cli -s .audio.srate 48000
cli -s .audio.volume 90
cli -s .audio.gain 26
cli -s .audio.outputEnabled true
cli -s .audio.outputVolume 80
cli -s .audio.speakerPin 53

(sleep 3; reboot -f) &

exit 0
