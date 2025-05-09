#!/bin/bash
set -e

install -m 755 "${STAGE_DIR}/files/ulocker_service" "${ROOTFS_DIR}/home/ulocker/ulocker_service"
install -m 644 "${STAGE_DIR}/files/conf.toml" "${ROOTFS_DIR}/home/ulocker/conf.toml"

install -m 644 "${STAGE_DIR}/files/ui.zip" "${ROOTFS_DIR}/home/ulocker/ui.zip"

install -m 755 "${STAGE_DIR}/files/repair_redis.sh" "${ROOTFS_DIR}/home/ulocker/repair_redis.sh"
install -m 755 "${STAGE_DIR}/files/redis_flushall.sh" "${ROOTFS_DIR}/home/ulocker/redis_flushall.sh"
install -m 755 "${STAGE_DIR}/files/serve_ui.sh" "${ROOTFS_DIR}/home/ulocker/serve_ui.sh"
install -m 755 "${STAGE_DIR}/files/kiosk.sh" "${ROOTFS_DIR}/home/ulocker/kiosk.sh"

install -m 644 "${STAGE_DIR}/files/kiosk.service" "${ROOTFS_DIR}/etc/systemd/system/kiosk.service"
install -m 644 "${STAGE_DIR}/files/ulocker.service" "${ROOTFS_DIR}/etc/systemd/system/ulocker.service"

install -m 644 "${STAGE_DIR}/files/ulocker.conf" "${ROOTFS_DIR}/etc/nginx/conf.d/"
