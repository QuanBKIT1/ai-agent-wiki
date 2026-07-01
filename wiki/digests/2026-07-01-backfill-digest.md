---
title: "Backfill Digest — 2026-07-01"
type: digest
created: 2026-07-01
updated: 2026-07-01
tags: [digest, backfill, ai-agents, production, observability, crewai]
---

# Backfill Digest — 2026-07-01

> **Đây KHÔNG phải digest crawl tuần** (xem [[digests/2026-07-01-digest|digest tuần 2026-07-01]] cho kết quả crawl chính). Đây là đợt **backfill có chủ đích**: 2 bài chất lượng cao **đăng ngoài cửa sổ 7 ngày** (nên bị crawl tự động loại), được ingest lại theo yêu cầu vì lấp khoảng trống thực sự trong wiki. Nhãn "backfill" được giữ để không nhầm với bài "mới trong tuần".

## Bài backfill (2 bài)

### ⭐⭐⭐⭐⭐ Agent Observability: The Complete Guide for 2026
- **Tác giả**: Braintrust Team
- **Ngày đăng**: 2026-06-21 (10 ngày trước — ngoài cửa sổ 7 ngày)
- **Thời gian đọc**: ~18 phút
- **Nguồn**: Braintrust — https://www.braintrust.dev/articles/agent-observability-complete-guide-2026
- **Wiki**: 📖 [[articles/agent-observability-guide-braintrust]] · tóm tắt [[summaries/agent-observability-guide-braintrust]] · entity [[entities/braintrust]]

**Tóm tắt 5 điểm chính:**
1. **4 loại span tối thiểu** — Tool-Call, Reasoning, State Transition, Memory Operation; mỗi loại bắt một failure mode (hallucinated args, plan drift, context loss, stale read).
2. **APM truyền thống thất bại** — xác nhận "service up" nhưng không xác nhận agent chọn đúng tool/args/memory/plan; HTTP 200 vẫn bọc câu trả lời sai.
3. **Multi-agent handoff** — xem mỗi agent boundary như RPC, nest sub-agent dưới handoff span, cùng trace ID; không thế thì handoff failure vô hình.
4. **Vòng trace → eval → CI gate** — trace fail online scoring thành eval case; GitHub Action block merge khi quality tụt (hiện thực hoá [[concepts/evaluation-pipeline]]).
5. **Landscape** — Braintrust (trace-to-eval), Galileo (guardrails), Arize Phoenix (OSS/OTEL), Datadog (APM). Có code LangGraph (Python) + Mastra (TS).

### ⭐⭐⭐⭐ CrewAI in Production 2026: Real Lessons
- **Tác giả**: Emachalan (AgileSoftLabs)
- **Ngày đăng**: 2026-06-15 (đã bị crawl 2026-07-01 loại vì >7 ngày)
- **Thời gian đọc**: ~16 phút
- **Nguồn**: AgileSoftLabs — https://www.agilesoftlabs.com/blog/2026/06/crewai-in-production-2026-real-lessons
- **Wiki**: 📖 [[articles/crewai-production-lessons]] · tóm tắt [[summaries/crewai-production-lessons]] · entity [[entities/crewai]]

**Tóm tắt 5 điểm chính:**
1. **Narrow > generalist** — agent 2 tool + backstory cụ thể thắng agent 6 tool.
2. **`max_iter=25` mặc định là cost leak lớn nhất** — hạ về 5–8; một run tồi đốt 5–10× budget.
3. **Số liệu**: 3-agent pipeline ~$0.30/run (~29K token) → $900/tháng ở 100 run/ngày; model tiering (gpt-4o-mini, Claude Haiku) giảm ~30%.
4. **Sequential > hierarchical** cho production (hierarchical khó debug); `output_pydantic` là "top reliability fix".
5. **Không raise trong tool `_run`** — trả error string để agent retry; deploy async FastAPI + polling, observability qua LangSmith.

## Bài bổ sung/mở rộng ý cũ (cross-link 2 chiều)

- [[concepts/agent-observability]] — thêm bảng 4 loại span, vòng trace→eval, landscape platform.
- [[concepts/agent-cost-management]] — thêm số liệu max_iter + model tiering; đúc kết "3 đòn bẩy chi phí" (hard limit · prompt caching · model tiering).
- [[entities/crewai]] — thêm mục "Bài học production (2026)".
- [[concepts/evaluation-pipeline]] · [[concepts/silent-tool-call-failures]] — được củng cố bằng ví dụ thực hành.
- Entity mới: [[entities/braintrust]].

## Xu hướng nổi bật

- **Observability = trace có cấu trúc + eval loop, không phải dashboard uptime.** Điệp khúc "APM không đủ cho agent" khớp với luận điểm sẵn có của [[concepts/agent-observability]].
- **Cost engineering trưởng thành**: từ nguyên tắc ("chi phí cấp số nhân") sang số liệu vận hành cụ thể (max_iter, $/run, model tiering).
- **Sequential/pipeline thắng trong thực chiến**: đơn giản, deterministic, dễ debug — lặp lại thông điệp "narrow rail" từ Stripe và Harness Engineering.

## Recommendation đọc theo thứ tự

1. [[articles/agent-observability-guide-braintrust]] — nền tảng để "nhìn thấy" agent làm gì.
2. [[articles/crewai-production-lessons]] — áp dụng cost control + orchestration khi đã có observability.
3. Đối chiếu [[concepts/agent-cost-management]] (3 đòn bẩy chi phí) và [[concepts/evaluation-pipeline]] (trace nuôi eval).

## Ghi chú

- Đây là **lần chạy /crawl-next thứ 2 trong ngày** (loop local). Crawl chính đã chạy lúc 16:50 và ingest AWS/Stripe.
- Cửa sổ 7 ngày (2026-06-24 → 07-01) không còn bài mới chưa ingest → 2 bài này được đưa vào diện **backfill** theo quyết định của người dùng, không tính là "bài tuần".
