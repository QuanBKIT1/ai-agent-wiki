---
title: "Braintrust"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/agent-observability-guide-braintrust]]"
  - "https://www.braintrust.dev/articles/agent-observability-complete-guide-2026"
tags: [entity, tool, observability, tracing, evaluation, platform]
---

# Braintrust

Platform **agent observability + evaluation** thương mại, định vị quanh workflow **trace → eval**: biến production trace thất bại thành eval case, rồi chặn regression bằng CI gate. Là nguồn của bài guide observability 2026 được ingest vào [[agent-observability]].

- **Điểm mạnh**: native integration với 7+ framework (LangGraph, Mastra…), nested spans giữ quan hệ parent-child qua multi-agent handoff, online eval (inline scorer + LLM-as-a-judge) chạy trên live trace, CI/CD quality gate, tùy chọn self-hosting.
- **Best for**: đội muốn khép vòng "production failure → eval case → block merge".
- **Free tier**: 1 GB processed data + 10k evaluation scores/tháng.
- **Topics feature**: phân loại mọi trace theo intent/sentiment/issue ngay khi landing.

Các platform khác được so sánh trong bài: **Galileo AI** (guardrails out-of-the-box), **Arize Phoenix** (open-source, [[opentelemetry|OpenTelemetry]]-first), **Datadog LLM Observability** (APM integration, SOC2/HIPAA, nhưng hỗ trợ agent-specific hạn chế).

## Xem thêm
- [[agent-observability]] — 4 loại span, vì sao APM chuẩn không đủ, vòng trace→eval
- [[evaluation-pipeline]] — continuous eval như production infrastructure
- [[opentelemetry]] — chuẩn tracing mở (Arize Phoenix dựa trên)
- [[langgraph]] — một trong các framework Braintrust tích hợp
- [[agent-observability-guide-braintrust]] · 📖 [[articles/agent-observability-guide-braintrust]]
