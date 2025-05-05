#!/bin/bash

unzip -o ui.zip
sudo mkdir -p /home/ulocker/ui
sudo cp -r dist/* /home/ulocker/ui/
sudo chown -R www-data:www-data /home/ulocker/ui

sudo systemctl restart kiosk