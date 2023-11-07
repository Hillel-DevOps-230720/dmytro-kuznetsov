#!/bin/bash

report_file=$1
threshold=${2:-0}

# смотрим что файл есть которий хотим проверить
if [ ! -e "$report_file" ]; then
    echo "Error: File '$report_file' not found"
    exit 1
fi

# ищем ошибки по регулярке
failures=$(grep -oP 'failures="\K\d+' "$report_file")

# дальше скармливаем переменную и проверяем
if [ "$failures" -gt "$threshold" ]; then
    echo "Failures found: $failures"
    grep -oP '<testcase.*?<failure.*?message="\K[^"]+' "$report_file" | while read -r failure_message; do
        echo "Test case failed: $failure_message"
    done
    exit 1
elif [ "$failures" -gt 0 ]; then
    echo "Failures found: $failures"
    grep -oP '<testcase.*?<failure.*?message="\K[^"]+' "$report_file" | while read -r failure_message; do
        echo "Test case failed: $failure_message"
    done
    exit 128
else
    echo "OK - No failures found"
    exit 0
fi
