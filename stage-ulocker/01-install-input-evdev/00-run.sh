#!/bin/bash
set -e

on_chroot << EOF
apt-get update
apt-get install -y xserver-xorg-input-evdev
apt-get remove -y xserver-xorg-input-libinput
EOF