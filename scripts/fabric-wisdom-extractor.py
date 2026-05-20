#!/usr/bin/env python3
"""
fabric-wisdom-extractor.py
Extrahiert Wisdom aus YouTube-Videos oder Texten via MiniMax API
"""
import sys
import os
import json
import ssl
import urllib.request
import urllib.error
import subprocess
import tempfile
from datetime import datetime

# Config
BRAIN_DIR = os.path.expanduser("~/brain/concepts")
GBRAIN_BIN = os.path.expanduser("~/.npm/_npx/efe872e7c1765fbf/node_modules/.bin/gbrain")
MINIMAX_KEY = os.environ.get("MINIMAX_API_KEY", "")
MINIMAX_URL = os.environ.get("MINIMAX_BASE_URL", "https://api.minimax.io/v1")

SYSTEM_PROMPT = """You extract surprising, insightful, and interesting information from text content. You are interested in insights related to the purpose and meaning of life, human flourishing, the role of technology in the future of humanity, artificial intelligence and its affect on humans, memes, learning, reading, books, continuous improvement, and similar topics.

Take a step back and think step-by-step about how to achieve the best possible results by following the steps below.

# STEPS
- Extract a summary of the content in 25 words, including who is presenting and the content being discussed into a section called SUMMARY.
- Extract 20 to 50 of the most surprising, insightful, and/or interesting ideas from the input in a section called IDEAS:. If there are less than 50 then collect all of them. Make sure you extract at least 20.
- Extract 10 to 20 of the best insights from the input and from a combination of the raw input and the IDEAS above into a section called INSIGHTS. These INSIGHTS should be fewer, more refined, more insightful, and more abstracted versions of the best ideas in the content.
- Extract 15 to 30 of the most surprising, insightful, and/or interesting quotes from the input into a section called QUOTES:. Use the exact quote text from the input. Include the name of the speaker of the quote at the end.
- Extract 15 to 30 of the most practical and useful personal habits of the speakers, or mentioned by the speakers, in the content into a section called HABITS. Examples include but are not limited to: sleep schedule, reading habits, things they always do, things they always avoid, productivity tips, diet, exercise, etc.
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
- Ensure you follow ALL these instructions when creating your output."""


def get_youtube_metadata(url):
    """Hole Titel, Channel, Datum, Dauer via yt-dlp"""
    try:
        result = subprocess.run(
            ["yt-dlp", "--dump-json", "--no-playlist", url],
            capture_output=True, text=True, timeout=60
        )
        data = json.loads(result.stdout)
        upload_date = data.get("upload_date", "")
        formatted_date = f"{upload_date[0:4]}-{upload_date[4:6]}-{upload_date[6:8]}" if upload_date else ""
        duration = data.get("duration", 0)
        duration_str = f"{int(duration//60)}:{int(duration%60):02d}"
        return {
            "title": data.get("title", "Unknown"),
            "channel": data.get("uploader", "Unknown"),
            "date": formatted_date,
            "duration": duration_str
        }
    except Exception as e:
        print(f"Metadata error: {e}", file=sys.stderr)
        return {"title": "Unknown", "channel": "Unknown", "date": "", "duration": ""}


def get_youtube_transcript(url):
    """Hole YouTube Transkript via yt-dlp"""
    with tempfile.TemporaryDirectory() as tmpdir:
        output_template = os.path.join(tmpdir, "transcript")
        try:
            subprocess.run(
                ["yt-dlp", "--write-auto-sub", "--sub-lang", "en",
                 "--skip-download", "--convert-subs", "vtt",
                 "--output", output_template, url],
                capture_output=True, text=True, timeout=120
            )
        except Exception as e:
            print(f"Download error: {e}", file=sys.stderr)
            return ""

        # Find transcript file
        for suffix in [".en.vtt", ".vtt"]:
            path = output_template + suffix
            if os.path.exists(path):
                return parse_vtt(path)

        return ""


def parse_vtt(path):
    """Extrahiere Text aus VTT Datei"""
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    text_lines = []
    for line in lines:
        line = line.strip()
        # Skip VTT formatting and timestamps
        if line.startswith("<") or line.startswith("WEBVTT") or line.startswith("--"):
            continue
        if line and line[0].isdigit() and ":" in line[:10]:
            continue
        if line == "":
            continue
        text_lines.append(line)

    return " ".join(text_lines)


def call_minimax(content):
    """Rufe MiniMax API auf"""
    if not MINIMAX_KEY:
        print("ERROR: MINIMAX_API_KEY not set", file=sys.stderr)
        sys.exit(1)

    url = f"{MINIMAX_URL}/chat/completions"
    payload = {
        "model": "MiniMax-M2.7",
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"Extract wisdom from this content:\n\n{content[:40000]}"}
        ],
        "max_tokens": 16000,
        "temperature": 0.7
    }

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Authorization", f"Bearer {MINIMAX_KEY}")
    req.add_header("Content-Type", "application/json")

    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    try:
        with urllib.request.urlopen(req, timeout=180, context=ctx) as response:
            result = json.loads(response.read().decode("utf-8"))
            return result.get("choices", [{}])[0].get("message", {}).get("content", "")
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8")
        print(f"API Error {e.code}: {error_body}", file=sys.stderr)
        sys.exit(1)


def save_and_import(slug, content, meta, input_url):
    """Speichere Markdown + importiere zu gbrain"""
    os.makedirs(BRAIN_DIR, exist_ok=True)
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    today = datetime.now().strftime("%Y-%m-%d")

    output_path = os.path.join(BRAIN_DIR, f"{slug}.md")

    markdown = f"""---
Type: Video
Status: done
Created: {now}
Modified: {now}
Source: {input_url}
Source_Type: youtube
Processing_Date: {today}
Date-Added: [[{today}]]
Pattern_Used: extract_wisdom
Date_of_Source: {meta.get('date', '')}
Channel: {meta.get('channel', '')}
Platform: YouTube
Duration: {meta.get('duration', '')}
tags:
  - content/video
---

# {meta.get('title', 'Unknown')}

{content}

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

- **Channel:** {meta.get('channel', '')}
- **Original Video:** {meta.get('title', '')}
- **Video Link:** {input_url}

---
*Created: {now} | Pattern: extract_wisdom | Source: YouTube Video*
"""

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(markdown)

    print(f"Saved: {output_path}")

    # gbrain import
    try:
        result = subprocess.run(
            [GBRAIN_BIN, "put", slug],
            input=markdown.encode("utf-8"),
            capture_output=True, timeout=30
        )
        if result.returncode == 0:
            print("gbrain: OK")
        else:
            print(f"gbrain warning: {result.stderr.decode()}")
    except Exception as e:
        print(f"gbrain skipped: {e}")

    return output_path


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 fabric-wisdom-extractor.py <youtube_url|text> [slug]")
        sys.exit(1)

    input_arg = sys.argv[1]
    slug = sys.argv[2] if len(sys.argv) > 2 else ""

    print(f"=== Input: {input_arg}")

    if input_arg.startswith("http"):
        # YouTube URL
        print("Fetching metadata...")
        meta = get_youtube_metadata(input_arg)
        print(f"Title: {meta['title']}")
        print(f"Channel: {meta['channel']}")
        print(f"Date: {meta['date']}")

        print("Fetching transcript...")
        content = get_youtube_transcript(input_arg)
        if not content:
            print("WARNING: No transcript found, using title only")
            content = f"Title: {meta['title']}. Channel: {meta['channel']}."

        if not slug:
            video_id = input_arg.split("v=")[-1].split("&")[0]
            slug = f"vid-{video_id}"

    else:
        # Plain text
        content = input_arg
        meta = {"title": "Text Input", "channel": "", "date": "", "duration": ""}
        if not slug:
            slug = f"wisdom-{datetime.now().strftime('%Y%m%d-%H%M%S')}"

    print(f"Extracting wisdom (chars: {len(content)})...")
    wisdom = call_minimax(content)

    if not wisdom:
        print("ERROR: No wisdom returned", file=sys.stderr)
        sys.exit(1)

    print(f"First 200 chars: {wisdom[:200]}")

    output_path = save_and_import(slug, wisdom, meta, input_arg)
    print(f"\n=== DONE: {slug}")
    print(f"File: {output_path}")


if __name__ == "__main__":
    main()
