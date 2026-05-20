#!/usr/bin/env python3
"""Import Stockbee Market Monitor CSVs (2014-2026) into SQLite breadth.db"""
import sqlite3, csv, glob, os

DB_PATH = os.path.expanduser("~/brain/data/breadth.db")
DATA_DIR = os.path.expanduser("~/brain/import")

conn = sqlite3.connect(DB_PATH)
c = conn.cursor()

c.execute("""
CREATE TABLE IF NOT EXISTS breadth (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT UNIQUE NOT NULL,
    stocks_up_4p INTEGER,
    stocks_down_4p INTEGER,
    ratio_5day REAL,
    ratio_10day REAL,
    stocks_up_25p_quarter INTEGER,
    stocks_down_25p_quarter INTEGER,
    stocks_up_25p_month INTEGER,
    stocks_down_25p_month INTEGER,
    stocks_up_50p_month INTEGER,
    stocks_down_50p_month INTEGER,
    stocks_up_13p_34days INTEGER,
    stocks_down_13p_34days INTEGER,
    worden_universe INTEGER,
    t2108 REAL,
    sp500 REAL,
    source TEXT
)
""")

all_files = sorted(glob.glob(os.path.join(DATA_DIR, "Stockbee Market Monitor 2026 - 20*.csv")))
# Filter to 2014-2026 only (schema stable from 2014 onwards)
# Note: filename uses " - " around the dash, e.g. "Stockbee Market Monitor 2026 - 2014.csv"
year_map = {str(y): f" - {y}.csv" for y in range(2014, 2027)}
files = [f for f in all_files if any(year_map[y] in f for y in year_map)]
print(f"Files: {len(files)}")

skipped = []
for fpath in files:
    fname = os.path.basename(fpath)
    year = fname.split("-")[-1].replace(".csv","").strip()
    print(f"  {fname}...", end="", flush=True)

    with open(fpath, newline='', encoding='utf-8') as f:
        reader = csv.reader(f)
        rows = list(reader)

    # Data rows start at index 2 (skip 2 header rows)
    # Dates look like "12/31/2014" or "5/5/2026" - not empty, contain a digit and a /
    data_rows = [r for r in rows[2:] if len(r) > 1 and r[0].strip() and '/' in r[0].strip()]
    inserted = 0

    for row in data_rows:
        if len(row) < 15:
            continue
        try:
            sp5_raw = row[15].replace(',','').replace('"','').strip() if len(row) > 15 else ''
            sp5 = float(sp5_raw) if sp5_raw else None
            t2108_raw = row[14].replace(',','').replace('"','').strip() if len(row) > 14 else ''
            t2108 = float(t2108_raw) if t2108_raw else None
            wu_raw = row[13].replace(',','').strip() if len(row) > 13 else ''
            wu = int(wu_raw) if wu_raw else None

            c.execute("""
                INSERT OR REPLACE INTO breadth (
                    date, stocks_up_4p, stocks_down_4p, ratio_5day, ratio_10day,
                    stocks_up_25p_quarter, stocks_down_25p_quarter,
                    stocks_up_25p_month, stocks_down_25p_month,
                    stocks_up_50p_month, stocks_down_50p_month,
                    stocks_up_13p_34days, stocks_down_13p_34days,
                    worden_universe, t2108, sp500, source
                ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
            """, (
                row[0].strip(),
                int(row[1]) if row[1].strip() else None,
                int(row[2]) if row[2].strip() else None,
                float(row[3]) if row[3].strip() else None,
                float(row[4]) if row[4].strip() else None,
                int(row[5]) if row[5].strip() else None,
                int(row[6]) if row[6].strip() else None,
                int(row[7]) if row[7].strip() else None,
                int(row[8]) if row[8].strip() else None,
                int(row[9]) if row[9].strip() else None,
                int(row[10]) if row[10].strip() else None,
                int(row[11]) if row[11].strip() else None,
                int(row[12]) if row[12].strip() else None,
                wu, t2108, sp5, fname
            ))
            inserted += 1
        except Exception as e:
            skipped.append(f"{row[0]}: {e}")

    print(f" {inserted} rows")
    if skipped:
        for s in skipped[-3:]:
            print(f"    SKIP: {s}")

conn.commit()
c.execute("SELECT COUNT(*), MIN(date), MAX(date) FROM breadth")
count, min_d, max_d = c.fetchone()
print(f"\nDone: {count} rows, {min_d} to {max_d}")
conn.close()
