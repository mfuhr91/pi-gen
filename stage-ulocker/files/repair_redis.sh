#!/bin/bash

systemctl stop redis-server
cd /var/lib/redis
mv dump.rdb dump.rdb.bak
mv appendonly.aof appendonly.aof.bak