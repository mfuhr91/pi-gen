#!/bin/bash
set -e

DISK="$1"

if [[ -z "$DISK" ]]; then
  echo "[$(date "+%H:%M:%S")] Usage: $0 /dev/sdX"
  exit 1
fi

# Ensure gparted is installed
if ! command -v gparted &> /dev/null; then
  echo "[$(date "+%H:%M:%S")] Installing gparted..."
  sudo apt-get update && sudo apt-get install -y gparted
fi

# Calculate total sectors and start of new partition
SECTOR_SIZE=512
SECTORS_TOTAL=$(cat /sys/block/$(basename $DISK)/size)
SECTORS_10G=$((10 * 1024 * 1024 * 1024 / SECTOR_SIZE))
START_SECTOR=$((SECTORS_TOTAL - SECTORS_10G))
ROOT_PART="${DISK}2"

# Resize partition 2 to fill up to START_SECTOR
START2=$(sfdisk -d "$DISK" | grep "${DISK}2" | awk '{print $4}' | sed 's/,//')

echo "[$(date "+%H:%M:%S")] Expanding ${DISK}2 from sector $START2 to sector $((START_SECTOR - 1))..."

# Delete and recreate root partition with expanded size
sfdisk --delete "$DISK" 2
echo "${START2},$((START_SECTOR - START2))" | sfdisk --no-reread --append "$DISK"

partprobe "$DISK"
udevadm settle
sleep 2

ROOT_PART="${DISK}2"

# Resize filesystem
echo "[$(date "+%H:%M:%S")] Checking and resizing filesystem on $ROOT_PART..."
e2fsck -f "$ROOT_PART" || { echo "❌ Previous resize filesystem check failed on $ROOT_PART"; exit 1; }
resize2fs "$ROOT_PART"
e2fsck -f "$ROOT_PART" || { echo "❌ After resize filesystem check failed on $ROOT_PART"; exit 1; }

# Create new /home partition
echo "[$(date "+%H:%M:%S")] Creating new 10GiB partition at sector $START_SECTOR on $DISK..."
echo "$START_SECTOR,,83" | sfdisk --append "$DISK" --no-reread

partprobe "$DISK"
udevadm settle
sleep 2

HOME_PART="${DISK}3"
[ -b "$HOME_PART" ] || { echo "[$(date "+%H:%M:%S")] ❌ Partition $HOME_PART not found"; exit 1; }

echo "[$(date "+%H:%M:%S")] Formatting $HOME_PART as ext4..."
mkfs.ext4 -F "$HOME_PART"

# Mount root and new home
echo "[$(date "+%H:%M:%S")] Mounting $ROOT_PART to /mnt/sdroot..."
mkdir -p /mnt/sdroot
mount "$ROOT_PART" /mnt/sdroot

echo "[$(date "+%H:%M:%S")] Mounting $HOME_PART to /mnt/newhome..."
mkdir -p /mnt/newhome
mount "$HOME_PART" /mnt/newhome

# Copy /home contents
echo "[$(date "+%H:%M:%S")] Copying /home from rootfs to new partition..."
rsync -a /mnt/sdroot/home/ /mnt/newhome/

# Prepare and mount new home
echo "[$(date "+%H:%M:%S")] Cleaning /home in rootfs and setting mount point..."
rm -rf /mnt/sdroot/home/*
umount /mnt/newhome

if mountpoint -q /mnt/sdroot/home; then
  umount /mnt/sdroot/home
fi

# Update fstab
PARTUUID=$(blkid -s PARTUUID -o value "$HOME_PART")
echo "PARTUUID=$PARTUUID /home ext4 defaults,noatime 0 2" >> /mnt/sdroot/etc/fstab

echo "[$(date "+%H:%M:%S")] fstab updated: PARTUUID=$PARTUUID /home ext4 defaults,noatime 0 2"

# ✅ Unmount and done
umount /mnt/sdroot

echo "[$(date "+%H:%M:%S")] ✅ Root expanded and /home moved to new partition."