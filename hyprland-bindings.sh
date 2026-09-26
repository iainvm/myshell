#! /usr/bin/env sh

hyprctl eval 'hl.bind("ALT + L", hl.dsp.global("quickshell:toggleBar"))'
hyprctl eval 'hl.bind("ALT + R", hl.dsp.global("quickshell:toggleSettings"))'
hyprctl eval 'hl.bind("ALT + B", hl.dsp.global("quickshell:openBluetoothSettings"))'
hyprctl eval 'hl.bind("ALT + N", hl.dsp.global("quickshell:openNetworkSettings"))'
