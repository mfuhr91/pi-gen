#!/bin/bash
set -e

on_chroot << EOF
mkdir -p /home/redis-data
chown redis:redis /home/redis-data

mkdir -p /etc/systemd/system/redis.service.d
cat <<EOT > /etc/systemd/system/redis.service.d/override.conf
[Service]
ProtectHome=false
ReadWritePaths=-/home/redis-data
EOT
EOF

# 🛠 Only modify redis.conf if it exists
if [ -f "${ROOTFS_DIR}/etc/redis/redis.conf" ]; then
  # Set dir to /home/redis-data
  sed -i 's|^dir .*|dir /home/redis-data|' "${ROOTFS_DIR}/etc/redis/redis.conf"

  # Comment out default save line and add new one
  sed -i 's/^save 60 10000/# save 60 10000/' "${ROOTFS_DIR}/etc/redis/redis.conf"
  grep -q "^save 60 1" "${ROOTFS_DIR}/etc/redis/redis.conf" || echo "save 60 1" >> "${ROOTFS_DIR}/etc/redis/redis.conf"

  # Comment out default appendonly line and enable it
  sed -i 's/^appendonly no/# appendonly no/' "${ROOTFS_DIR}/etc/redis/redis.conf"
  grep -q "^appendonly yes" "${ROOTFS_DIR}/etc/redis/redis.conf" || echo "appendonly yes" >> "${ROOTFS_DIR}/etc/redis/redis.conf"
fi