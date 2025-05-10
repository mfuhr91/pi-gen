#!/bin/bash

systemctl stop redis
cd /home/redis-data
rm -rf appendonlydir.bak
mv dump.rdb dump.rdb.bak
mv appendonlydir appendonlydir.bak
systemctl start redis
systemctl restart ulocker