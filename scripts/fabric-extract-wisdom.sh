#!/bin/bash
# fabric-extract-wisdom.sh
# Verarbeitet YouTube-Videos mit Fabric extract_wisdom und speichert in gbrain
# Usage: ./fabric-extract-wisdom.sh <youtube_url> [slug]

set -e

BRAIN_DIR="$HOME/brain/concepts"
FABRIC="$HOME/fabric/fabric"
GBRAIN_BIN="$HOME/.npm/_npx/efe872e7c1765fbf/node_modules/.bin/gbrain"

if [ -z "$1" ]; then
    echo "Usage: $0 <youtube_url> [slug]"
    echo "Example: $0 'https://www.youtube.com/watch?v=udNfV6Rt7Xc' my-video-note"
    exit 1
fi

URL="$1"
SLUG="${2:-}"
VIDEO_ID=$(echo "$URL" | grep -o 'v=[^&]*' | cut -c3-)

if [ -z "$SLUG" ]; then
    SLUG="vid-${VIDEO_ID}"
fi

OUTPUT_FILE="$BRAIN_DIR/${SLUG}.md"

echo "=== Processing: $URL"
echo "=== Video ID: $VIDEO_ID"
echo "=== Output: $OUTPUT_FILE"

# Metadaten holen
echo "Fetching metadata..."
METADATA=$(yt-dlp --dump-json --no-playlist "$URL" 2>/dev/null)
TITLE=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('title',''))" 2>/dev/null || echo "Unknown Title")
CHANNEL=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('uploader',''))" 2>/dev/null || echo "Unknown Channel")
UPLOAD_DATE=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('upload_date',''))" 2>/dev/null || echo "")
DURATION=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); secs=d.get('duration',0); m=int(secs//60); s=int(secs%60); print(f'{m}:{s:02d}')" 2>/dev/null || echo "")

# Format date for frontmatter
if [ -n "$UPLOAD_DATE" ]; then
    FORMATTED_DATE="${UPLOAD_DATE:0:4}-${UPLOAD_DATE:4:2}-${UPLOAD_DATE:6:2}"
else
    FORMATTED_DATE=""
fi

NOW=$(date '+%Y-%m-%d %H:%M:%S')

echo "Title: $TITLE"
echo "Channel: $CHANNEL"
echo "Date: $FORMATTED_DATE"
echo "Duration: $DURATION"

# Fabric extract_wisdom ausführen
echo "Running extract_wisdom..."
TEMP_WISDOM=$(mktemp)
~/fabric/fabric -p extract_wisdom -y "$URL" > "$TEMP_WISDOM" 2>&1

# Markdown zusammenbauen
cat > "$OUTPUT_FILE" << EOF
---
Type: Video
Status: done
Created: $NOW
Modified: $NOW
Source: $URL
Source_Type: youtube
Processing_Date: $(date '+%Y-%m-%d')
Date-Added: [[$(date '+%Y-%m-%d')]]
Pattern_Used: extract_wisdom
Date_of_Source: $FORMATTED_DATE
Channel: $CHANNEL
Platform: YouTube
Duration: $DURATION
tags:
  - content/video
---

# $TITLE

$(cat "$TEMP_WISDOM")

## 3-2-1 Analyse

**3 Key Takeaways:**
1. (Extract from IDEAS section)
2. (Extract from INSIGHTS section)
3. (Extract from ONE-SENTENCE TAKEAWAY)

**2 Questions for Reflection:**
- (Your reflection questions here)
- (Your reflection questions here)

**1 Action Item:**
- (Your action item here)

## Zusätzliche Ressourcen

- **Channel:** $CHANNEL
- **Original Video:** $TITLE
- **Video Link:** $URL

---
*Created: $NOW | Pattern: extract_wisdom | Source: YouTube Video*
EOF

rm "$TEMP_WISDOM"

echo ""
echo "=== Saved to: $OUTPUT_FILE"

# gbrain import
echo "Importing to gbrain..."
$GBRAIN_BIN put "$SLUG" < "$OUTPUT_FILE"

echo "Done: https://gbrain.space/#/$SLUG"
