#!/bin/bash

LOGS_PATH=/var/log/custom_daemon.log
MEMORY=`free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'`
DISK=`df -h | awk '$NF=="/"||$NF=="/home"{printf "Disk: %s usage: %d/%dGB (%s)\n", $1,$3,$2,$5}'`
CPU=`top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'`
UPTIME=`uptime | awk '{printf "Load average: 1 min: %s 5 min: %s 15 min: %s\n", $8,$9,$10 }'`
DATE=`date +"%S:%M:%H %d-%m-%Y"`
LOG="$DATE: $MEMORY, $DISK, $CPU, $UPTIME"
echo "$LOG" >> $LOGS_PATH
