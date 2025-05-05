#!/bin/bash
set -e

on_chroot << EOF
systemctl daemon-reload
systemctl enable kiosk.service
systemctl start kiosk.service

systemctl enable ulocker.service
systemctl start ulocker.service

EOF
