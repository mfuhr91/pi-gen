#!/bin/bash
set -e

install -m 755 "${STAGE_DIR}/files/set_touchscreen.sh" "${ROOTFS_DIR}/home/ulocker/set_touchscreen.sh"

on_chroot << 'EOF'
XSESSION_FILE="/home/ulocker/.xsessionrc"
SCRIPT_LINE="~/set_touchscreen.sh"
XRANDR_LINE="xrandr --output HDMI-1 --rotate left"

if [ ! -f "$XSESSION_FILE" ]; then
  echo "$SCRIPT_LINE" > "$XSESSION_FILE"
  echo "$XRANDR_LINE" >> "$XSESSION_FILE"
else
  grep -Fxq "$SCRIPT_LINE" "$XSESSION_FILE" || echo "$SCRIPT_LINE" >> "$XSESSION_FILE"
  grep -Fxq "$XRANDR_LINE" "$XSESSION_FILE" || echo "$XRANDR_LINE" >> "$XSESSION_FILE"
fi

EOF