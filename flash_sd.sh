#!/bin/bash
set -e

# Check if the SD device was passed as argument
if [ -z "$1" ]; then
  echo "❗ Usage: $0 /dev/sdX"
  echo "Example: $0 /dev/sdb"
  exit 1
fi

DEVICE=$1

# Find the latest .img.xz file in the deploy/ folder
IMG=$(ls -t deploy/*.img.xz | head -n 1)

if [ -z "$IMG" ]; then
  echo "❗ No .img.xz file found in deploy/"
  exit 1
fi

echo "📂 Image found: $IMG"
echo "💾 Target device: $DEVICE"
echo ""
read -p "⚡ Are you sure you want to flash this image? It will erase EVERYTHING on $DEVICE [y/N]: " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Aborted."
  exit 1
fi

echo "🚀 [$(date "+%H:%M:%S")] Flashing image to $DEVICE..."
xzcat "$IMG" | sudo dd of="$DEVICE" bs=4M status=progress oflag=sync


sync

echo "📦 [$(date "+%H:%M:%S")] Resizing partitions..."

./resize_sd.sh $1

echo "✅ [$(date "+%H:%M:%S")] Image successfully flashed to $DEVICE."
