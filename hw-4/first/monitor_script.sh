#!/bin/bash

keyword=$(grep "KEYWORD" /etc/environment | cut -d= -f2)
access_log_path=$(grep "ACCESS_LOG_PATH" /etc/environment | cut -d= -f2)
error_log_path=$(grep "ERROR_LOG_PATH" /etc/environment | cut -d= -f2)

if grep -q "$keyword" "$access_log_path"; then
    echo "Found KEYWORD in access log: $access_log_path"
else
    echo "Not Found KEYWORD in access log: $access_log_path"
fi

if grep -q "$keyword" "$error_log_path"; then
    echo "Found KEYWORD in error log: $error_log_path"
else
    echo "Not Found KEYWORD in access log: $error_log_path"
fi
