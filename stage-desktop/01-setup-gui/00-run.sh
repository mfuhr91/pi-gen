#!/bin/bash
set -e

# Crear el directorio de configuración si no existe
mkdir -p /etc/lightdm/lightdm.conf.d

# Configurar LightDM para autologin
cat <<EOF > /etc/lightdm/lightdm.conf.d/12-autologin.conf
[Seat:*]
autologin-user=ulocker
autologin-user-timeout=0
user-session=LXDE
greeter-session=lightdm-gtk-greeter
EOF