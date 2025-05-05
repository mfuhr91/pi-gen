#!/bin/bash
set -e

on_chroot << EOF
mkdir -p /home/ulocker/old_logs
chown ulocker:ulocker /home/ulocker/old_logs
chmod 755 /home/ulocker/old_logs
EOF

install -m 644 "${STAGE_DIR}/files/ulocker" "${ROOTFS_DIR}/etc/logrotate.d/ulocker"