---
title: "CrewAI in Production 2026: Real Lessons"
type: summary
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/crewai-production-lessons]]"
  - "https://www.agilesoftlabs.com/blog/2026/06/crewai-in-production-2026-real-lessons"
tags: [ai-agents, production, crewai, multi-agent, cost, pydantic, orchestration]
---

# CrewAI in Production 2026: Real Lessons

> 📖 Bản đầy đủ: [[articles/crewai-production-lessons]]

Bài kinh nghiệm thực chiến (AgileSoftLabs, 15/06/2026, ~16 phút) khi đưa [[crewai|CrewAI]] vào production — có code và **số liệu chi phí cụ thể**. Bổ sung góc "production reality" cho entity [[crewai]] và số liệu cho [[agent-cost-management]]. (Bài **backfill**: ngoài cửa sổ 7 ngày, đã bị crawl 2026-07-01 loại vì quá cũ, được ingest lại theo yêu cầu vì giá trị thực hành.)

## Key takeaways

- **Narrow > generalist**: agent hẹp với **2 tools** + backstory cụ thể thắng agent tổng quát 6 tools (agent rộng gây wrong-tool, loop, output không nhất quán phá downstream). Cấu hình production: `max_iter=10`, `max_execution_time=300`, `allow_delegation=False`.

- **`max_iter` là "cost leak" lớn nhất**: mặc định **25** → một run tồi đốt **5–10× budget**. Nên set **5–8**/agent.

- **Số liệu chi phí thật**: 3-agent pipeline ~**$0.30/run** (~29K token) → **$900/tháng** ở 100 run/ngày. Giảm bằng **model tiering** (gpt-4o-mini cho editing, rẻ ~10×; Claude Haiku cho task đơn giản), `@lru_cache` cho tool result. Củng cố nguyên tắc "chi phí là cấp số nhân" của [[agent-cost-management]].

- **Sequential > hierarchical cho production**: hierarchical thêm non-determinism (manager tự quyết thứ tự + delegation) → debug thành black-box. Chỉ dùng hierarchical khi task set thực sự không thể định trước.

- **`output_pydantic` là "top reliability fix"**: ép format hợp lệ, cho phép xử lý programmatic, tránh string-parsing dễ vỡ; `context=[task]` truyền output đã validate xuống agent kế.

- **Không bao giờ raise trong tool `_run`**: trả về error string để agent retry thông minh thay vì fail toàn bộ (đồng điệu với [[silent-tool-call-failures]]).

- **Deploy**: async FastAPI (`asyncio.to_thread()` + job-status polling), retry exponential backoff (tenacity), observability qua LangSmith.

Liên hệ: đối chiếu [[agent-frameworks-comparison]] và [[deployment-topologies]] (sequential ~ pipeline pattern).
