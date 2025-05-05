#!/bin/bash
set -e

on_chroot << EOF
if grep -q '^overlayroot=' /etc/overlayroot.conf; then
  sed -i 's|^overlayroot=.*|overlayroot="tmpfs:swap=1,recurse=0"|' /etc/overlayroot.conf
else
  echo 'overlayroot="tmpfs:swap=1,recurse=0"' >> /etc/overlayroot.conf
fi
EOF