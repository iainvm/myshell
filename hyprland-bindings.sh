#! /usr/bin/env sh
hyprctl reload
hyprctl eval 'hl.bind("ALT + L", hl.dsp.global("quickshell:toggleBar"))'
hyprctl eval 'hl.bind("ALT + R", hl.dsp.global("quickshell:toggleSideMenu"))'
hyprctl eval 'hl.bind("ALT + B", hl.dsp.global("quickshell:openBluetoothSettings"))'
hyprctl eval 'hl.bind("ALT + N", hl.dsp.global("quickshell:openNetworkSettings"))'
hyprctl eval 'hl.bind("ALT + A", hl.dsp.global("quickshell:openApplicationLauncher"))'
hyprctl eval 'hl.bind("ALT + M", hl.dsp.global("quickshell:openNotifications"))'
hyprctl eval 'hl.bind("ALT + V", hl.dsp.global("quickshell:openVolumeSettings"))'
hyprctl eval 'hl.bind("ALT + C", hl.dsp.global("quickshell:openClipboardHistory"))'
