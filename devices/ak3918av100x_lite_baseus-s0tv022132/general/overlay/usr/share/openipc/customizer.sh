#!/bin/sh
#
# Perform basic settings on a known IP camera
#
# Baseus P1 Pro (S0TV022132): AK3918AV100X, SmartSens SC5336 on 2-lane MIPI,
# 8 MB NOR, AIC8800D80 USB Wi-Fi, pan/tilt steppers on GPIO, IR-cut, IR LEDs,
# red and blue LEDs, reset button. Its stock firmware is a GIEC/Tuya build.
#
#
# Set custom upgrade url
#
fw_setenv upgrade 'https://github.com/OpenIPC/builder/releases/download/latest/ak3918av100x_lite_baseus-s0tv022132-nor.tgz'
#
#
# Set wlan device and credentials if need
#
fw_setenv wlandev aic8800-ak3918av100x-baseus-s0tv022132
#fw_setenv wlanssid Router
#fw_setenv wlanpass 12345678
#
# The sensor, so load_anyka loads its driver without probing the others
fw_setenv sensor sc5336
#
#
# Set custom majestic settings
#
# IR-cut on 4 and 8 (IRCUT- and IRCUT+ in the stock giec_sys_init.sh), IR
# LEDs on 70 (the stock device tree's irled).
cli -s .nightMode.irCutPin1 4
cli -s .nightMode.irCutPin2 8
cli -s .nightMode.backlightPin 70
# No light sensor on the board: the stock app switches on the ISP's
# brightness. Night above 16x gain, day again under 4x; covering the lens
# switches to night.
cli -s .nightMode.autoNightGain 16
cli -s .nightMode.autoDayGain 4
cli -s .nightMode.backlight auto
# The WebUI's pan/tilt pad reads mirror, flip and rotate, and refuses every
# move while one of them is missing.
cli -s .image.mirror false
cli -s .image.flip false
cli -s .image.rotate 0
# Pan/tilt through majestic-af's gpiostep actuator (/ptz, ONVIF, WebUI).
cli -s .ptz.enabled true
cli -s .ptz.actuator gpiostep
fw_setenv ptz_control gpiostep
fw_setenv ptz_caps 'pan tilt'
# Microphone and speaker on the SoC codec, 8 kHz as stock. ak_pcm never
# drives the speaker amplifier (GPIO 37, the device tree's speak-gpios), so
# majestic has to. The SDK hands over 256-sample frames, which Opus cannot
# frame at 8 kHz, so the stream carries G.711.
cli -s .audio.enabled true
cli -s .audio.srate 8000
cli -s .audio.codec ulaw
cli -s .audio.outputEnabled true
cli -s .audio.speakerPin 37

exit 0
