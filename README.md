# AI Agent Wiki

Knowledge base về AI/LLM — song ngữ Việt-Anh.

Được xây dựng theo [Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): LLM compile raw sources thành wiki cross-linked, kiến thức tích lũy theo thời gian.

## Categories

- **AI Agents Production** — Deploy, vận hành, kiến trúc AI agents trong production
- *(thêm categories mới theo thời gian)*

## Thêm tài liệu (tự động)

Một lệnh duy nhất lo trọn luồng: copy → ingest (AI) → lint → commit → push → deploy.

```bash
./scripts/add-doc.sh <file> <category>

# ví dụ
./scripts/add-doc.sh ~/Downloads/rag-guide.md rag
./scripts/add-doc.sh ./notes/eval-methods.md ai-agents-production
```

Sau khi chạy, GitHub Actions tự build và deploy — site cập nhật sau ~1 phút.

**Tùy chọn (biến môi trường):**
- `WIKI_MODEL=opus` — đổi model cho bước ingest (mặc định `sonnet`)
- `NO_PUSH=1` — làm mọi thứ trừ push (commit vẫn tạo, để bạn review rồi tự `git push`)
- `DRY_RUN=1` — in các bước mà không thực thi

> Bước ingest chạy `claude` headless với `--dangerously-skip-permissions` để không bị treo ở prompt. Script chỉ đụng thư mục wiki này, chạy local trên máy bạn.

### Làm thủ công (nếu muốn kiểm soát từng bước)

1. Copy bài vào `raw/<category>/`
2. Mở Claude Code trong repo, gõ: `ingest raw/<category>/<file>`
3. Review pages trong `wiki/` (hoặc `mkdocs serve`)
4. `git add -A && git commit && git push`

## Crawl tự động hàng tuần (`/crawl-next`)

Skill `crawl-next` tự tìm bài mới về triển khai AI Agent trên Production (7 ngày gần nhất), dedup, compile vào wiki, viết digest tiếng Việt, rồi commit + push.

```
# trong Claude Code (mở tại repo này)
/crawl-next            # chạy một lần cho tuần này
```

Luồng: dedup ledger → WebSearch nhiều query → lọc (7 ngày, dedup, chất lượng, nguồn uy tín, tối đa 5 bài) → fetch → ingest vào wiki → ghi ledger → digest `wiki/digests/` → push.

**Chạy định kỳ không cần máy bật:** dùng GitHub Actions cron hoặc `/schedule` để gọi workflow này mỗi tuần.

**Ép URL cụ thể (tùy chọn):** dán URL vào `scripts/crawl-queue.txt` để crawl-next xử lý thay vì tìm tự động.

### Dedup ledger

`data/ingested-sources.jsonl` (tracked) là nguồn sự thật duy nhất về "đã ingest gì" — mỗi bài một dòng (URL chuẩn hóa + title + ngày). Dedup là tra cứu O(1), không đọc lại digest cũ:

```bash
printf '%s\n' "$url1" "$url2" | python3 scripts/ledger.py check   # in ra URL mới
python3 scripts/ledger.py add "<url>" "<title>" "<source>"        # ghi sau khi ingest
python3 scripts/ledger.py titles                                  # liệt kê title đã có
```

> `crawl-next` là một **skill** trong `.claude/skills/crawl-next/` (project-scoped — tự nhận khi mở Claude Code trong repo này).

**Lưu ý bản quyền:** thư mục `raw/` (full-text bài gốc) được **gitignore** — chỉ giữ local. Repo public chỉ chứa wiki đã compile (tóm tắt/biên dịch) + digest tiếng Việt.

## Local preview

```bash
# Web viewer (từ llm-wiki-skill)
cd ~/workspace/llm-wiki-skill/web
npm start -- --wiki ~/workspace/ai-agent-wiki --port 4175

# MkDocs
cd ~/workspace/ai-agent-wiki
pip install -r requirements.txt
mkdocs serve
```

## Tech stack

- [llm-wiki-skill](https://github.com/LewisLiu819/llm-wiki-skill) — Karpathy-style wiki skill
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) — GitHub Pages
- GitHub Actions — auto deploy on push
