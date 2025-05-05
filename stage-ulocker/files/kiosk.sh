#!/bin/bash

# Detectar el valor correcto de DISPLAY
export DISPLAY=$(echo $DISPLAY | grep -Eo ":[0-9]+(\.[0-9]+)?")

# Si DISPLAY no está configurado, establecer uno por defecto
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

# Establecer XAUTHORITY para acceso al servidor gráfico
export XAUTHORITY=/home/ulocker/.Xauthority

# Log para depuración
echo "DISPLAY=$DISPLAY" >> /home/ulocker/kiosk.log
echo "XAUTHORITY=$XAUTHORITY" >> /home/ulocker/kiosk.log
echo "Fecha: $(date)" >> /home/ulocker/kiosk.log

rm -rf .cache/chromium/Default/Cache/*
rm -rf /home/ulocker/.config/chromium/Singleton*

xset s noblank
xset s off
xset -dpms

unclutter -idle 0.5 -root &

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/$USER/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/$USER/.config/chromium/Default/Preferences

# Iniciar Chromium en modo kiosco
web="http://localhost"
/usr/bin/chromium-browser \
    --disable \
    --disable-translate \
    --disable-infobars \
    --disable-suggestions-service \
    --disable-save-password-bubble \
    --start-maximized \
    --noerrdialogs \
    --disable-component-update \
    --kiosk \
    --incognito $web &

while true; do
   xdotool keydown ctrl+Next; xdotool keyup ctrl+Next;
   sleep 10
done