#!/bin/bash
# Batch: Alle 17 Videos mit extract_wisdom + gbrain

SCRIPT_DIR="$(dirname "$0")"
FABRIC_EXTRACT="$SCRIPT_DIR/fabric-extract-wisdom.sh"

urls=(
  "https://www.youtube.com/watch?v=FKliYFtPHjI"
  "https://www.youtube.com/watch?v=k8kF0bADoww"
  "https://www.youtube.com/watch?v=uOuFauQ6MJY"
  "https://www.youtube.com/watch?v=ynnCwnIQ5Pg"
  "https://www.youtube.com/watch?v=X4UrqrZmwq8"
  "https://www.youtube.com/watch?v=b8EW_SdaMwQ"
  "https://www.youtube.com/watch?v=YtfUYtajbrw"
  "https://www.youtube.com/watch?v=udNfV6Rt7Xc"
  "https://www.youtube.com/watch?v=dTJueSUqdh4"
  "https://www.youtube.com/watch?v=WVzkaofrqQQ"
  "https://www.youtube.com/watch?v=i-FvQ9bD9S8"
  "https://www.youtube.com/watch?v=jLXXUdYYYnM"
  "https://www.youtube.com/watch?v=9hpxrScUia4"
  "https://www.youtube.com/watch?v=LruZ9P30yXM"
  "https://www.youtube.com/watch?v=8hudPhNk480"
  "https://www.youtube.com/watch?v=xoxsJrn7UPM"
  "https://www.youtube.com/watch?v=7kxZUobYxpg"
)

count=1
for url in "${urls[@]}"; do
  VIDEO_ID=$(echo "$url" | grep -o 'v=[^&]*' | cut -c3-)
  SLUG="vid-${VIDEO_ID}"
  echo "[$count/17] Processing: $VIDEO_ID"
  bash "$FABRIC_EXTRACT" "$url" "$SLUG"
  count=$((count + 1))
  echo ""
done

echo "=== ALL DONE ==="
