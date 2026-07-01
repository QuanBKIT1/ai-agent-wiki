---
name: crawl-next
description: >-
  Weekly autonomous crawler for the AI Agent Wiki. Searches the web for the
  latest articles/papers/blogs on deploying AI Agents in production (last 7
  days), deduplicates against the ledger (data/ingested-sources.jsonl),
  compiles selected articles into the wiki via the llm-wiki skill, writes a
  Vietnamese weekly digest, then commits + pushes (GitHub Actions deploys). Use
  when the user wants to discover and ingest new production AI-agent material,
  runs `/crawl-next`, or schedules a weekly crawl. Dedup is O(1) against the
  ledger — never re-read past digests.
---

# crawl-next — weekly AI-Agent-in-production crawler

Repo root: `/Users/quan.ld/workspace/ai-agent-wiki`. All paths below are relative to it.
Tìm kiếm các bài báo, paper, blog **mới nhất** về triển khai AI Agent trên môi trường Production, xuất bản trong **7 ngày gần đây**, rồi ingest vào wiki.

## Phase 0 — Load the dedup ledger (thay cho việc đọc lại toàn bộ digest cũ)

The ledger `data/ingested-sources.jsonl` is the single source of truth for "đã ingest gì". Do NOT read past digests to dedup — that is slow and grows unbounded.

- Get the list of known titles for near-dup comparison:
  ```bash
  python3 scripts/ledger.py titles
  ```
  Keep this short list in mind for Phase 2 step (c).

## Phase 1 — Search (WebSearch, query đa dạng)

Chạy WebSearch với các query sau (thay `<năm>` = năm hiện tại):
- `building AI agents in production <năm>`
- `production AI agent deployment lessons`
- `AI agent architecture best practices`
- `LLM agent observability monitoring`
- `multi-agent system production`
- `MCP A2A protocol production agents`

Gom toàn bộ URL candidate lại.

## Phase 2 — Filter (theo thứ tự)

**(a) Dedup URL trước tiên — deterministic, không đoán bằng mắt.** Đưa toàn bộ URL candidate qua ledger:
```bash
printf '%s\n' "$url1" "$url2" ... | python3 scripts/ledger.py check
```
Chỉ những URL **mới** (chưa có trong ledger, đã chuẩn hóa www/scheme/query/trailing-slash) lọt ra. Bỏ hết phần còn lại.

Với các URL mới:
- **(b)** Chỉ giữ bài xuất bản trong **7 ngày gần nhất**.
- **(c)** Loại bài có tiêu đề tương tự (>80% giống) với `title_key` đã có trong ledger (dùng danh sách ở Phase 0).
- **(d)** Ưu tiên bài chi tiết (>10 phút đọc), có case study thực tế, hoặc kèm code.
- **(e)** Loại bài marketing/quảng cáo thuần túy; loại nội dung trùng lặp giữa các bài vừa tìm.
- **(f)** Ưu tiên nguồn uy tín: Google Cloud, AWS, Anthropic, OpenAI, IBM, MLflow, LangChain, blog engineering của các công ty công nghệ, arxiv.org, Medium engineering publications.

Chọn **tối đa 5 bài**.

## Phase 3 — Với mỗi bài chọn được: fetch → ingest → ledger

1. **Fetch** nội dung đầy đủ bằng WebFetch.
2. **Save raw** vào `raw/<category>/<slug>.md` (mặc định category `ai-agents-production`; kebab-case English slug) kèm frontmatter:
   ```yaml
   ---
   source_url: <url>
   author: <tác giả nếu có>
   published: <ngày đăng>
   read_time: <phút>
   rating: <1-5>
   fetched: <hôm nay>
   category: <category>
   ---
   ```
   (`raw/` gitignored — local only, không publish.)
3. **Ingest vào wiki** bằng skill `llm-wiki` (`ingest raw/<category>/<slug>.md`), tuân thủ `CLAUDE.md`:
   - Thuật ngữ kỹ thuật giữ English, giải thích tiếng Việt; code giữ nguyên English.
   - Tạo `wiki/summaries/<slug>.md` (200–400 từ), concept pages, entity pages.
   - **Cross-link 2 chiều** với page cũ trùng chủ đề; update `wiki/index.md` (mỗi page đúng 1 lần); ghi log.
   - Nếu >70% ý trùng bài cũ → không tạo page trùng, thay vào đó bổ sung/mở rộng page cũ và ghi chú "Bổ sung cho [[page]]".
4. **Viết bản đầy đủ tiếng Việt** → `wiki/articles/<slug>.md` (mục "📖 Bài viết" — được publish):
   - **Viết lại/biên soạn** cho người Việt dễ đọc, KHÔNG dịch nguyên văn (transformative + an toàn bản quyền). Giữ đầy đủ ý chính, cấu trúc, ví dụ, số liệu; code giữ nguyên English.
   - Frontmatter: `title`, `type: article`, `created`, `updated`, `sources` (gồm URL gốc), `tags`.
   - Ngay dưới H1, chèn khối attribution:
     ```
     > **Nguồn gốc**: [<tên nguồn>](<url>)
     > **Tác giả**: <tác giả> | **Ngày đăng**: <ngày> | **Thời gian đọc**: ~<n> phút | ⭐ <rating>/5
     ```
   - Link 2 chiều: bài này link tới `[[summaries/<slug>]]` và các concept liên quan; summary trỏ lại `[[articles/<slug>]]`.
   - Thêm dòng vào `wiki/articles/index.md` (tạo nếu chưa có), sắp xếp mới nhất lên đầu.
5. **Ghi ledger** (bắt buộc, ngay sau khi ingest thành công):
   ```bash
   python3 scripts/ledger.py add "<url>" "<title>" "<source-domain>"
   ```

## Phase 4 — Viết digest tuần (tiếng Việt) → published wiki

Tạo `wiki/digests/<YYYY-MM-DD>-digest.md` (nằm trong wiki nên **được publish**; thay cho vị trí raw/ cũ vì raw/ gitignored). Nội dung tiếng Việt, code giữ English:
- **Danh sách bài mới** — mỗi bài: tiêu đề, tác giả, ngày đăng, thời gian đọc, URL gốc, ⭐ (1-5), tóm tắt 3-5 điểm chính.
- **Bài bổ sung/mở rộng ý cũ** (nếu có).
- **Xu hướng mới nổi tuần này.**
- **Recommendation đọc theo thứ tự nào.**

Cập nhật `wiki/digests/index.md` (tạo nếu chưa có): thêm link đến digest mới nhất, sắp xếp thời gian **giảm dần**. Thêm digest vào `wiki/index.md` dưới category phù hợp.

> "Đã indexed URLs" = chính ledger `data/ingested-sources.jsonl` (greppable). Không duy trì danh sách URL thủ công trong prose — tránh 2 nguồn lệch nhau.

## Phase 5 — Trường hợp không có bài mới

Nếu sau khi lọc không còn bài nào đáng chú ý, **vẫn tạo** `wiki/digests/<YYYY-MM-DD>-digest.md` ghi rõ:
- "Không có bài mới đáng chú ý tuần này."
- Số bài tìm được nhưng bị lọc + lý do (trùng URL, trùng nội dung, không đủ chất lượng, quá cũ).
- Danh sách query đã thử.

## Phase 6 — Lint, commit, push

```bash
python3 ~/workspace/llm-wiki-skill/llm-wiki/scripts/lint_wiki.py /Users/quan.ld/workspace/ai-agent-wiki   # bỏ qua cảnh báo [[raw/...]]
cd /Users/quan.ld/workspace/ai-agent-wiki
git add wiki/ log/ CLAUDE.md data/ingested-sources.jsonl
git commit -m "feat: weekly crawl <YYYY-MM-DD> (N bài mới)"
git push origin main
```
Nếu `git diff --cached --quiet` (không có gì mới) → vẫn commit digest "không có bài mới" nếu đã tạo; nếu thật sự không có thay đổi thì báo và bỏ qua commit.

## Phase 7 — Báo cáo (tiếng Việt, ngắn gọn)

- ✅ Số bài mới đã ingest + tiêu đề.
- Số bài bị lọc (kèm lý do gom nhóm).
- Digest: `wiki/digests/<YYYY-MM-DD>-digest.md`.
- Commit `<short-sha>` — site cập nhật sau ~1 phút.

---

**Manual seed (tùy chọn):** nếu muốn ép crawl URL cụ thể thay vì tìm tự động, dán URL vào `scripts/crawl-queue.txt` và xử lý chúng ở Phase 3 (vẫn qua `ledger.py check` để tránh trùng).
