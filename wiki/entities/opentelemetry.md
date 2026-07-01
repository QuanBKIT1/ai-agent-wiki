---
title: "OpenTelemetry"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/02_Lessons_Learned_Harness_Engineering_VN]]"
tags: [entity, tool, observability, tracing, standard]
---

# OpenTelemetry

Chuẩn (standard) mở cho observability — collection của trace, metric và log. Trong bối cảnh production AI agent, được khuyến nghị làm nền tảng cho **span-level tracing**.

Trong [[agent-observability]], mỗi agent step được biểu diễn là một **span** với quan hệ parent-child để tái tạo execution tree. Khuyến nghị dùng span **OpenTelemetry-compatible**, để execution trace của agent tích hợp được với hạ tầng observability chuẩn (tracing backend, dashboard) thay vì phát minh lại format riêng.

## Xem thêm
- [[agent-observability]] — vì sao agent cần span-level trace
- [[braintrust]] — platform observability; Arize Phoenix (đối thủ) là OpenTelemetry-first
- [[harness-engineering]] · [[harness-checklist]]
