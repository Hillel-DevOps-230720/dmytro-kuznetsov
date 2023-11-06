#!/bin/bash

threshold=$(grep "THRESHOLD" /etc/environment | cut -d= -f2)

free_space=$(df -h / | awk 'NR==2{print $4}')

if [ "$free_space" \< "$threshold" ]; then
    echo "Low disk space on /! Free space: $free_space" >> /path/to/telegram_notification.log
fi
