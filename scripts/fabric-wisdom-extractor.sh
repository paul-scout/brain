#!/bin/bash
# fabric-wisdom-extractor.sh
# Führt extract_wisdom aus via MiniMax API (nicht über Fabric CLI)
# Usage: ./fabric-wisdom-extractor.sh <youtube_url|@file.txt|text> [slug]

set -e

BRAIN_DIR="$HOME/brain/concepts"
GBRAIN_BIN="$HOME/.npm/_npx/efe872e7c1765fbf/node_modules/.bin/gbrain"
MINIMAX_KEY="${MINIMAX_API_KEY}"
MINIMAX_URL="${MINIMAX_BASE_URL:-https://api.minimax.io/v1}"

if [ -z "$MINIMAX_KEY" ]; then
    echo "ERROR: MINIMAX_API_KEY not set"
    exit 1
fi

INPUT="$1"
SLUG="${2:-}"
NOW=$(date '+%Y-%m-%d %H:%M:%S')
TODAY=$(date '+%Y-%m-%d')

if [ -z "$INPUT" ]; then
    echo "Usage: $0 <youtube_url|@file.txt|text> [slug]"
    exit 1
fi

# Determine input type
if [[ "$INPUT" == http*youtube.com* ]] || [[ "$INPUT" == http*youtu.be* ]]; then
    INPUT_TYPE="youtube"
elif [[ "$INPUT" == @* ]]; then
    INPUT_TYPE="file"
    FILE_PATH="${INPUT:1}"
else
    INPUT_TYPE="text"
fi

echo "=== Input Type: $INPUT_TYPE"

# Get content
if [ "$INPUT_TYPE" == "youtube" ]; then
    echo "Fetching YouTube transcript..."
    
    # Get metadata
    METADATA=$(yt-dlp --dump-json --no-playlist "$INPUT" 2>/dev/null)
    VIDEO_TITLE=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('title',''))" 2>/dev/null || echo "Unknown")
    VIDEO_CHANNEL=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('uploader',''))" 2>/dev/null || echo "Unknown")
    UPLOAD_DATE=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('upload_date',''))" 2>/dev/null || echo "")
    DURATION_SECS=$(echo "$METADATA" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('duration',0))" 2>/dev/null || echo "0")
    
    if [ -n "$UPLOAD_DATE" ]; then
        VIDEO_DATE="${UPLOAD_DATE:0:4}-${UPLOAD_DATE:4:2}-${UPLOAD_DATE:6:2}"
    fi
    VIDEO_DURATION=$(printf '%d:%02d' $((DURATION_SECS/60)) $((DURATION_SECS%60)))
    
    echo "Title: $VIDEO_TITLE"
    echo "Channel: $VIDEO_CHANNEL"
    
    # Try to get transcript
    TEMP_VTT=$(mktemp)
    yt-dlp --write-auto-sub --sub-lang en --skip-download --convert-subs vtt --output "$TEMP_VTT" "$INPUT" 2>&1 | tail -3
    
    if [ -f "${TEMP_VTT}.en.vtt" ]; then
        CONTENT=$(grep -v "^<c\|^[0-9][0-9]:\|^WEBVTT\|^$\|^--" "${TEMP_VTT}.en.vtt" | tr '\n' ' ' | sed 's/  */ /g' | head -c 50000)
    elif [ -f "${TEMP_VTT}.vtt" ]; then
        CONTENT=$(grep -v "^<c\|^[0-9][0-9]:\|^WEBVTT\|^$\|^--" "${TEMP_VTT}.vtt" | tr '\n' ' ' | sed 's/  */ /g' | head -c 50000)
    else
        echo "WARNING: No transcript found"
        CONTENT="Title: $VIDEO_TITLE. Channel: $VIDEO_CHANNEL."
    fi
    rm -f "${TEMP_VTT}"*
    
elif [ "$INPUT_TYPE" == "file" ]; then
    CONTENT=$(cat "$FILE_PATH" | head -c 50000)
    SLUG="${SLUG:-$(basename "$FILE_PATH" .txt)}"
    VIDEO_TITLE=$(basename "$FILE_PATH")
    VIDEO_CHANNEL=""
    VIDEO_DATE=""
    VIDEO_DURATION=""
else
    CONTENT="$INPUT"
    CONTENT=$(echo "$CONTENT" | head -c 50000)
    VIDEO_TITLE="Text Input"
    VIDEO_CHANNEL=""
    VIDEO_DATE=""
    VIDEO_DURATION=""
fi

if [ -z "$SLUG" ]; then
    SLUG="wisdom-$(date '+%Y%m%d-%H%M%S')"
fi

OUTPUT_FILE="$BRAIN_DIR/${SLUG}.md"

echo "=== Processing wisdom extraction..."
echo "=== Output: $OUTPUT_FILE"

# Build the prompt
SYSTEM_PROMPT='You extract surprising, insightful, and interesting information from text content. You are interested in insights related to the purpose and meaning of life, human flourishing, the role of technology in the future of humanity, artificial intelligence and its affect on humans, memes, learning, reading, books, continuous improvement, and similar topics.

Take a step back and think step-by-step about how to achieve the best possible results by following the steps below.

# STEPS
- Extract a summary of the content in 25 words, including who is presenting and the content being discussed into a section called SUMMARY.

- Extract 20 to 50 of the most surprising, insightful, and/or interesting ideas from the input in a section called IDEAS:. If there are less than 50 then collect all of them. Make sure you extract at least 20.

- Extract 10 to 20 of the best insights from the input and from a combination of the raw input and the IDEAS above into a section called INSIGHTS. These INSIGHTS should be fewer, more refined, more insightful, and more abstracted versions of the best ideas in the content. 

- Extract 15 to 30 of the most surprising, insightful, and/or interesting quotes from the input into a section called QUOTES:. Use the exact quote text from the input. Include the name of the speaker of the quote at the end.

- Extract 15 to 30 of the most practical and useful personal habits of the speakers, or mentioned by the speakers, in the content into a section called HABITS. Examples include but aren't limited to: sleep schedule, reading habits, things they always do, things they always avoid, productivity tips, diet, exercise, etc.

- Extract 15 to 30 of the most surprising, insightful, and/or interesting valid facts about the greater world that were mentioned in the content into a section called FACTS:.

- Extract all mentions of writing, art, tools, projects and other sources of inspiration mentioned by the speakers into a section called REFERENCES. This should include any and all references to something that the speaker mentioned.

- Extract the most potent takeaway and recommendation into a section called ONE-SENTENCE TAKEAWAY. This should be a 15-word sentence that captures the most important essence of the content.

- Extract the 15 to 30 of the most surprising, insightful, and/or interesting recommendations that can be collected from the content into a section called RECOMMENDATIONS.

# OUTPUT INSTRUCTIONS

- Only output Markdown.

- Write the IDEAS bullets as exactly 16 words.

- Write the RECOMMENDATIONS bullets as exactly 16 words.

- Write the HABITS bullets as exactly 16 words.

- Write the FACTS bullets as exactly 16 words.

- Write the INSIGHTS bullets as exactly 16 words.

- Extract at least 25 IDEAS from the content.

- Extract at least 10 INSIGHTS from the content.

- Extract at least 20 items for the other output sections.

- Do not give warnings or notes; only output the requested sections.

- You use bulleted lists for output, not numbered lists.

- Do not repeat ideas, insights, quotes, habits, facts, or references.

- Do not start items with the same opening words.

- Ensure you follow ALL these instructions when creating your output.'

USER_PROMPT="Extract wisdom from this content:

$CONTENT"

# Call MiniMax API via Python
echo "Calling MiniMax API..."
WISDOM=$(python3 - "$CONTENT" << 'PYEOF'
import urllib.request
import urllib.error
import json
import os
import sys

url = "https://api.minimax.io/v1/chat/completions"
api_key = os.environ.get("MINIMAX_API_KEY", "")
user_content = sys.argv[1]

system_prompt = '''You extract surprising, insightful, and interesting information from text content. You are interested in insights related to the purpose and meaning of life, human flourishing, the role of technology in the future of humanity, artificial intelligence and its affect on humans, memes, learning, reading, books, continuous improvement, and similar topics.

Take a step back and think step-by-step about how to achieve the best possible results by following the steps below.

# STEPS
- Extract a summary of the content in 25 words, including who is presenting and the content being discussed into a section called SUMMARY.
- Extract 20 to 50 of the most surprising, insightful, and/or interesting ideas from the input in a section called IDEAS:. If there are less than 50 then collect all of them. Make sure you extract at least 20.
- Extract 10 to 20 of the best insights from the input and from a combination of the raw input and the IDEAS above into a section called INSIGHTS. These INSIGHTS should be fewer, more refined, more insightful, and more abstracted versions of the best ideas in the content. 
- Extract 15 to 30 of the most surprising, insightful, and/or interesting quotes from the input into a section called QUOTES:. Use the exact quote text from the input. Include the name of the speaker of the quote at the end.
- Extract 15 to 30 of the most practical and useful personal habits of the speakers, or mentioned by the speakers, in the content into a section called HABITS. Examples include but aren't limited to: sleep schedule, reading habits, things they always do, things they always avoid, productivity tips, diet, exercise, etc.
- Extract 15 to 30 of the most surprising, insightful, and/or interesting valid facts about the greater world that were mentioned in the content into a section called FACTS:.
- Extract all mentions of writing, art, tools, projects and other sources of inspiration mentioned by the speakers into a section called REFERENCES. This should include any and all references to something that the speaker mentioned.
- Extract the most potent takeaway and recommendation into a section called ONE-SENTENCE TAKEAWAY. This should be a 15-word sentence that captures the most important essence of the content.
- Extract the 15 to 30 of the most surprising, insightful, and/or interesting recommendations that can be collected from the content into a section called RECOMMENDATIONS.

# OUTPUT INSTRUCTIONS
- Only output Markdown.
- Write the IDEAS bullets as exactly 16 words.
- Write the RECOMMENDATIONS bullets as exactly 16 words.
- Write the HABITS bullets as exactly 16 words.
- Write the FACTS bullets as exactly 16 words.
- Write the INSIGHTS bullets as exactly 16 words.
- Extract at least 25 IDEAS from the content.
- Extract at least 10 INSIGHTS from the content.
- Extract at least 20 items for the other output sections.
- Do not give warnings or notes; only output the requested sections.
- You use bulleted lists for output, not numbered lists.
- Do not repeat ideas, insights, quotes, habits, facts, or references.
- Do not start items with the same opening words.
- Ensure you follow ALL these instructions when creating your output.'''

payload = {
    "model": "MiniMax-M2.7",
    "messages": [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_content[:40000]}
    ],
    "max_tokens": 16000,
    "temperature": 0.7
}

data = json.dumps(payload).encode('utf-8')
req = urllib.request.Request(url, data=data, method='POST')
req.add_header('Authorization', f'Bearer {api_key}')
req.add_header('Content-Type', 'application/json')

try:
    with urllib.request.urlopen(req, timeout=120) as response:
        result = json.loads(response.read().decode('utf-8'))
        print(result.get('choices', [{}])[0].get('message', {}).get('content', ''))
except urllib.error.HTTPError as e:
    print(f"ERROR: {e.code} - {e.read().decode('utf-8')}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"ERROR: {str(e)}", file=sys.stderr)
    sys.exit(1)
PYEOF
)

if [ -z "$WISDOM" ]; then
    echo "ERROR: No response from MiniMax"
    exit 1
fi

# Build final markdown
cat > "$OUTPUT_FILE" << EOF
---
Type: Video
Status: done
Created: $NOW
Modified: $NOW
Source: $INPUT
Source_Type: $INPUT_TYPE
Processing_Date: $TODAY
Date-Added: [[$TODAY]]
Pattern_Used: extract_wisdom
Date_of_Source: ${VIDEO_DATE:-}
Channel: ${VIDEO_CHANNEL:-}
Platform: YouTube
Duration: ${VIDEO_DURATION:-}
tags:
  - content/video
---

# $VIDEO_TITLE

$WISDOM

## 3-2-1 Analyse

**3 Key Takeaways:**
1. (Aus IDEAS)
2. (Aus INSIGHTS)
3. (Aus ONE-SENTENCE TAKEAWAY)

**2 Questions for Reflection:**
- (Reflexionsfrage 1)
- (Reflexionsfrage 2)

**1 Action Item:**
- (Konkrete nächste Aktion)

## Zusätzliche Ressourcen

- **Channel:** ${VIDEO_CHANNEL:-}
- **Original Video:** $VIDEO_TITLE
- **Video Link:** $INPUT

---
*Created: $NOW | Pattern: extract_wisdom | Source: YouTube Video*
EOF

echo "=== Saved to: $OUTPUT_FILE"
echo ""
echo "=== First 300 chars of wisdom:"
echo "$WISDOM" | head -c 300
echo ""

# Import to gbrain
echo "=== Importing to gbrain..."
$GBRAIN_BIN put "$SLUG" < "$OUTPUT_FILE" 2>/dev/null && echo "gbrain: OK" || echo "gbrain: (skipped)"

echo ""
echo "=== DONE: $SLUG"
