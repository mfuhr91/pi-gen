#!/bin/bash
# Script to configure touchscreen devices at session startup

# xinput -h
# xinput or xinput list -> list input devices
# xinput list-props 9 -> list device props

# Wait a few seconds to ensure devices are available
sleep 5

# List of device names to search for
devices=("Atmel Atmel maXTouch Digitizer" "Elo TouchSystems, Inc. Elo TouchSystems 2700 IntelliTouch(r) USB")

# Iterate over each device name in the list
for device_name in "${devices[@]}"; do
    # Search for the device IDs by name in a precise manner
    device_ids=$(xinput list | awk -v name="$device_name" -F'id=' '$0 ~ name {print $2}' | awk '{print $1}')

    # Check if any IDs were found and apply the configuration to each found ID
    if [ -n "$device_ids" ]; then
        echo "Configuring '$device_name' with IDs: $device_ids"
        for id in $device_ids; do
            xinput set-int-prop "$id" "Evdev Axes Swap" 8 1
            xinput set-int-prop "$id" "Evdev Axis Inversion" 8 1 0
        done
    else
        echo "Device '$device_name' not found."
    fi
done