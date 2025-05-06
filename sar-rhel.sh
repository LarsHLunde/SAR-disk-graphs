#!/bin/bash

OUTPUT="disk_stats.json"
ARCHIVE="disk_stats.zip"
START_DATE=$(date --date="1 month ago" +%d)
END_DATE=$(date +%d)

> "$OUTPUT"
echo "[" >> "$OUTPUT"

for i in $(seq -w $START_DATE $END_DATE); do
    FILE="/var/log/sa/sa$i"
    if [ -f "$FILE" ]; then
        sadf -j "$FILE" -- -dp | jq '.sysstat.hosts[0].statistics' >> "$OUTPUT"
        echo "," >> "$OUTPUT"
    fi
done

# Remove trailing comma and close array
sed -i '$ s/,$//' "$OUTPUT"
echo "]" >> "$OUTPUT"

zip -9 "$ARCHIVE" "$OUTPUT"
base64 -w 0 "$ARCHIVE"
