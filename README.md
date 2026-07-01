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

## Crawl hàng loạt từ danh sách URL (`/loop`)

Crawl có giám sát nhiều bài từ URL, mỗi lần một bài:

1. Mở `scripts/crawl-queue.txt`, dán các URL (mỗi dòng: `<url> [category]`).
2. Trong Claude Code, chạy: `/loop /crawl-next`
3. Mỗi vòng lặp xử lý **một** URL: fetch → lưu `raw/` → ingest → lint → commit → push. Khi hết queue nó báo `QUEUE EMPTY` → nhấn Esc để dừng.

> `crawl-next` là một **skill** trong `.claude/skills/crawl-next/` (project-scoped — tự nhận khi mở Claude Code trong repo này).

> `/loop` chỉ chạy khi phiên Claude Code đang mở (đóng máy là dừng) — phù hợp crawl có giám sát. Muốn chạy định kỳ không cần máy bật, dùng GitHub Actions cron hoặc `/schedule`.

**Lưu ý bản quyền:** thư mục `raw/` (full-text bài gốc) được **gitignore** — chỉ giữ local. Repo public chỉ chứa wiki đã compile (tóm tắt/biên dịch).

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
