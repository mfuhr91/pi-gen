#!/bin/bash
set -e

on_chroot << EOF
# Cambiar puerto SSH a 5222
sed -i 's/^#Port 22/Port 5222/' /etc/ssh/sshd_config
EOF
