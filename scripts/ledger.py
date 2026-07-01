#!/usr/bin/env python3
"""
ledger.py — dedup ledger for crawled sources (single source of truth).

The ledger is an append-only JSONL file at data/ingested-sources.jsonl, one
record per ingested article. Deduplication is an O(1) membership check against
normalized URLs — no need to re-read past digests.

Usage:
    # Filter candidate URLs: read from stdin, print only the NEW ones (one/line)
    echo -e "url1\\nurl2" | python3 scripts/ledger.py check

    # Record a newly ingested source
    python3 scripts/ledger.py add <url> <title> [source]

    # Print all known title-keys (small list for LLM near-dup comparison)
    python3 scripts/ledger.py titles

Record shape:
    {"url_norm": "...", "url": "...", "title": "...", "title_key": "...",
     "date": "YYYY-MM-DD", "source": "..."}
"""
import sys
import json
import re
from pathlib import Path
from urllib.parse import urlparse

LEDGER = Path(__file__).resolve().parent.parent / "data" / "ingested-sources.jsonl"


def norm_url(u: str) -> str:
    """Canonicalize a URL for dedup: drop scheme, www., query, fragment, trailing slash."""
    u = u.strip()
    if "://" not in u:
        u = "https://" + u
    p = urlparse(u.lower())
    host = p.netloc.removeprefix("www.")
    path = p.path.rstrip("/")
    return f"{host}{path}"


def title_key(t: str) -> str:
    """Slugify a title for exact/normalized title matching."""
    t = t.strip().lower()
    t = re.sub(r"[^a-z0-9]+", "-", t)
    return t.strip("-")


def _load():
    records = []
    if LEDGER.exists():
        for line in LEDGER.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if line:
                records.append(json.loads(line))
    return records


def cmd_check():
    seen = {r["url_norm"] for r in _load()}
    for line in sys.stdin:
        u = line.strip()
        if u and norm_url(u) not in seen:
            print(u)


def cmd_add(url: str, title: str, source: str = ""):
    from datetime import date  # local import; scaffolds may forbid module-level Date
    rec = {
        "url_norm": norm_url(url),
        "url": url.strip(),
        "title": title.strip(),
        "title_key": title_key(title),
        "date": date.today().isoformat(),
        "source": source.strip(),
    }
    LEDGER.parent.mkdir(parents=True, exist_ok=True)
    with LEDGER.open("a", encoding="utf-8") as f:
        f.write(json.dumps(rec, ensure_ascii=False) + "\n")
    print(f"✓ ledger += {rec['url_norm']}")


def cmd_titles():
    for r in _load():
        print(f"{r['title_key']}\t{r.get('title','')}")


def main(argv):
    if not argv:
        print(__doc__)
        sys.exit(1)
    cmd = argv[0]
    if cmd == "check":
        cmd_check()
    elif cmd == "add":
        if len(argv) < 3:
            sys.exit("usage: ledger.py add <url> <title> [source]")
        cmd_add(argv[1], argv[2], argv[3] if len(argv) > 3 else "")
    elif cmd == "titles":
        cmd_titles()
    else:
        sys.exit(f"unknown command: {cmd}")


if __name__ == "__main__":
    main(sys.argv[1:])
