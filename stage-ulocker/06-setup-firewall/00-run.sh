#!/bin/bash
set -e

on_chroot << EOF
ufw allow 5222/tcp
ufw --force enable
EOF