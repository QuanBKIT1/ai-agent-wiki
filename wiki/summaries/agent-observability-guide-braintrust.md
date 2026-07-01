---
title: "Agent Observability: The Complete Guide for 2026 (Braintrust)"
type: summary
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/agent-observability-guide-braintrust]]"
  - "https://www.braintrust.dev/articles/agent-observability-complete-guide-2026"
tags: [ai-agents, production, observability, tracing, spans, evaluation, apm]
---

# Agent Observability: The Complete Guide for 2026 (Braintrust)

> 📖 Bản đầy đủ: [[articles/agent-observability-guide-braintrust]]

Guide kỹ thuật của Braintrust (21/06/2026, ~18 phút) về observability cho AI agent trong production — bổ sung **chi tiết thực hành + code** cho concept [[agent-observability]] vốn mới nói ở mức nguyên tắc. (Đây là bài **backfill**: giá trị cao nhưng đăng ngoài cửa sổ 7 ngày của crawl tuần này.)

## Key takeaways

- **4 loại span tối thiểu**: (1) **Tool-Call** — name, arguments, output, duration, retry, error; (2) **Reasoning** — plan/action/observation/next; (3) **State Transition** — working memory trước/sau + handoff payload; (4) **Memory Operation** — query, entries, relevance score, freshness. Mỗi loại bắt một failure mode riêng (hallucinated args, plan drift, context loss, stale read).

- **Vì sao traditional APM thất bại**: APM xác nhận "service is up" nhưng không xác nhận agent "chọn đúng tool, truyền đúng arguments, lấy đúng memory, giữ đúng plan". HTTP 200 vẫn có thể bọc một câu trả lời sai một cách tự tin. Looping agent trông "healthy" trên dashboard.

- **Multi-agent handoff phải nhìn thấy được**: xem mỗi agent boundary như một RPC — ghi handoff payload làm span trên trace của parent, nest sub-agent dưới đó, cho cùng trace ID chảy qua. Không có parent-child span thì handoff failure vô hình.

- **Vòng trace → eval → CI gate**: online scorer + LLM-as-a-judge chạy trên live trace; trace fail chuyển thành eval case; GitHub Action chạy eval trên mỗi PR, block merge nếu quality tụt dưới ngưỡng. Đây chính là hiện thực hoá [[evaluation-pipeline|continuous evaluation]].

- **Landscape platform**: [[braintrust|Braintrust]] (trace-to-eval, CI gate), Galileo AI (guardrails), Arize Phoenix (OSS, [[opentelemetry|OTEL]]-first), Datadog (APM, nhưng agent-specific hạn chế).

- **Adoption path**: Day 1 trace LLM+tool → Week 1 thêm reasoning + cost/trace → Month 1 online scoring + alert → Quarter 1 CI quality gate.

Liên hệ: củng cố [[silent-tool-call-failures]] (tool-call span bắt silent retry) và [[agent-cost-management]] (per-span cost rollup).
