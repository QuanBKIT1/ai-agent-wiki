---
description: Crawl and ingest the next URL from scripts/crawl-queue.txt into the wiki, then commit + push
---

You are the crawl worker for the AI Agent Wiki. Process **exactly ONE** URL per invocation so this command can be driven by `/loop /crawl-next`.

## Step 1 — Pick the next URL

Read `scripts/crawl-queue.txt` (relative to the repo root `/Users/quan.ld/workspace/ai-agent-wiki`).

Queue line format (one per line):
```
<url> [category]
```
- Lines that are blank, start with `#`, or start with `done:` are already handled → skip them.
- `category` is optional; if omitted use `ai-agents-production`. It must be kebab-case.

Find the FIRST line that is not blank/comment/done.

- If there is **no** such line → print `✅ QUEUE EMPTY — nothing left to crawl. Stop the loop (press Esc).` and STOP. Do nothing else, do not commit.
- Otherwise continue with that URL + category.

## Step 2 — Fetch and save to raw/

- Use WebFetch to retrieve the URL. Extract the **main article content** (title, body). Discard nav/ads/footers.
- Derive a kebab-case English `<slug>` from the article title.
- Save cleaned Markdown to `raw/<category>/<slug>.md` (create the folder if needed). Prepend YAML frontmatter:
  ```yaml
  ---
  source_url: <the url>
  fetched: 2026-07-01   # use today's date
  category: <category>
  ---
  ```
- Note: `raw/` is gitignored (kept local only) — this file will NOT be published, only the compiled wiki pages are.

## Step 3 — Ingest with the llm-wiki skill

Invoke the `llm-wiki` skill and perform an `ingest` on `raw/<category>/<slug>.md`, following `CLAUDE.md` strictly:
- Language: technical terms in English, explanations in Vietnamese.
- Create `wiki/summaries/<slug>.md` (200–400 words).
- Create/update concept pages in `wiki/concepts/` (folder-split with `index.md` if a page would exceed ~1200 words).
- Create/update entity pages in `wiki/entities/`.
- **Cross-link bidirectionally** with existing pages on overlapping topics.
- Update `wiki/index.md` so every new page appears exactly once.
- Append an ingest entry to today's `log/` file.
- Mermaid for diagrams, KaTeX for formulas. Fix any `[[x\|y]]` escaped-pipe links in table cells to plain `[[x]]`.

## Step 4 — Lint (informational)

Run: `python3 ~/workspace/llm-wiki-skill/llm-wiki/scripts/lint_wiki.py /Users/quan.ld/workspace/ai-agent-wiki`
Ignore `[[raw/...]]` dead-link warnings (known limitation). Fix any REAL dead links or orphan pages.

## Step 5 — Commit + push

```bash
cd /Users/quan.ld/workspace/ai-agent-wiki
git add wiki/ log/ CLAUDE.md
git commit -m "feat: crawl+ingest <slug> (<category>)"
git push origin main
```
If `git diff --cached --quiet` (ingest produced no changes), do NOT commit — report why and still mark the URL done.

GitHub Actions will build + deploy automatically (~1 min).

## Step 6 — Mark the URL done

Edit `scripts/crawl-queue.txt`: prefix the line you just processed with `done: ` so the next `/crawl-next` skips it.

## Step 7 — Report

Print a short summary:
- ✅ Processed: `<url>` → `<slug>` (N wiki pages touched)
- Remaining in queue: `<count>`
- Commit: `<short-sha>` (or "no changes")
