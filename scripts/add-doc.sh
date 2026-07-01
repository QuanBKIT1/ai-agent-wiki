#!/usr/bin/env bash
#
# add-doc.sh — Automated pipeline: add a raw document → ingest → lint → commit → push.
# GitHub Actions then deploys the updated wiki to GitHub Pages automatically.
#
# Usage:
#   scripts/add-doc.sh <file> <category>
#
# Examples:
#   scripts/add-doc.sh ~/Downloads/rag-guide.md rag
#   scripts/add-doc.sh ./notes/eval.md ai-agents-production
#
# Environment overrides:
#   WIKI_MODEL   Model for the ingest agent (default: sonnet). e.g. opus, sonnet
#   NO_PUSH=1    Do everything except git push (commit still happens locally)
#   DRY_RUN=1    Print each step without copying, ingesting, committing, or pushing
#
set -euo pipefail

# ---- pretty output -------------------------------------------------------
bold=$(tput bold 2>/dev/null || true); reset=$(tput sgr0 2>/dev/null || true)
step() { echo "${bold}==> $*${reset}"; }
die()  { echo "❌ $*" >&2; exit 1; }

# ---- args ----------------------------------------------------------------
[ $# -ge 2 ] || die "Usage: $(basename "$0") <file> <category>
  e.g. $(basename "$0") ~/Downloads/rag-guide.md rag"

SRC="$1"
CATEGORY="$2"
WIKI_MODEL="${WIKI_MODEL:-sonnet}"

[ -f "$SRC" ] || die "File not found: $SRC"
[[ "$CATEGORY" =~ ^[a-z0-9][a-z0-9-]*$ ]] || \
  die "Category must be kebab-case (lowercase, digits, hyphens): got '$CATEGORY'"

# ---- locate wiki root (script lives in <root>/scripts/) ------------------
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
[ -f "$ROOT/CLAUDE.md" ] || die "Not a wiki root (no CLAUDE.md at $ROOT)"

LINT="$HOME/workspace/llm-wiki-skill/llm-wiki/scripts/lint_wiki.py"
BASENAME="$(basename "$SRC")"
REL="raw/$CATEGORY/$BASENAME"

echo "${bold}AI Agent Wiki — add-doc${reset}"
echo "  source   : $SRC"
echo "  category : $CATEGORY"
echo "  target   : $REL"
echo "  model    : $WIKI_MODEL"
echo

if [ "${DRY_RUN:-0}" = "1" ]; then
  step "[dry-run] would copy   → $REL"
  step "[dry-run] would ingest → claude -p (model: $WIKI_MODEL)"
  step "[dry-run] would lint   → $LINT"
  step "[dry-run] would commit → 'feat: ingest $BASENAME'"
  [ "${NO_PUSH:-0}" = "1" ] && step "[dry-run] push skipped (NO_PUSH=1)" || step "[dry-run] would push → origin main"
  exit 0
fi

# ---- 1. copy into raw/ ---------------------------------------------------
step "1/5 Copy document into $REL"
mkdir -p "raw/$CATEGORY"
cp "$SRC" "$REL"

# ---- 2. ingest via Claude Code (headless) --------------------------------
step "2/5 Ingest with llm-wiki skill (this calls the AI, may take a minute)"
INGEST_PROMPT="Use the llm-wiki skill to perform an 'ingest' operation on $REL into this wiki.

Follow CLAUDE.md strictly:
- Language: technical terms in English, explanations in Vietnamese.
- Create wiki/summaries/<slug>.md (200-400 words).
- Create/update concept pages in wiki/concepts/ (split into a subfolder with index.md if a page would exceed ~1200 words).
- Create/update entity pages in wiki/entities/ for people, tools, papers, organizations.
- CROSS-LINK bidirectionally with existing pages on overlapping topics (add wikilinks in both directions).
- Update wiki/index.md so every new page appears exactly once, under the right category.
- Append an ingest entry to today's log/ file.
- Use mermaid for diagrams and KaTeX for formulas.
- Fix any escaped-pipe wikilinks [[x\\|y]] inside table cells to plain [[x]] form.

The raw file is ALREADY in place at $REL — do NOT copy it again. Do NOT run git commit or git push — the wrapper script handles that."

claude -p "$INGEST_PROMPT" \
  --model "$WIKI_MODEL" \
  --dangerously-skip-permissions \
  || die "Ingest failed (claude exited non-zero). Nothing committed."

# ---- 3. lint (informational) --------------------------------------------
step "3/5 Lint (raw-source citations always show as 'dead' — that's expected)"
if [ -f "$LINT" ]; then
  python3 "$LINT" "$ROOT" || true
else
  echo "  (lint script not found at $LINT — skipping)"
fi

# ---- 4. commit -----------------------------------------------------------
step "4/5 Commit generated pages (raw/ is gitignored — kept local only)"
git add wiki/ log/ CLAUDE.md
if git diff --cached --quiet; then
  die "Ingest produced no changes — nothing to commit. Check the document and try again."
fi
git commit -m "feat: ingest $BASENAME ($CATEGORY)" >/dev/null
echo "  committed: $(git rev-parse --short HEAD)"

# ---- 5. push -------------------------------------------------------------
if [ "${NO_PUSH:-0}" = "1" ]; then
  step "5/5 Push skipped (NO_PUSH=1) — run 'git push' when ready"
else
  step "5/5 Push → GitHub Actions will build & deploy"
  git push origin main
  echo
  echo "✅ Done. Site updates in ~1 min: https://quanbkit1.github.io/ai-agent-wiki/"
fi
