---
title: "Bài Học Triển Khai AI Agent Production (Harness Engineering, 2026)"
type: summary
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/02_Lessons_Learned_Harness_Engineering_VN]]"
  - "https://harness-engineering.ai/blog/lessons-learned-from-deploying-ai-agents-in-production/"
tags: [ai-agents, production, harness, observability, cost, evaluation, reliability]
---

# Bài Học Triển Khai AI Agent Trên Production (Harness Engineering, 2026)

> 📖 Bản đầy đủ: [[articles/lessons-learned-harness-engineering]]

Incident retrospective của Dr. [[sarah-chen|Sarah Chen]] ([[harness-engineering-blog|Harness Engineering]], 10/03/2026), đúc kết từ hàng chục lần deploy AI agent. Thông điệp trung tâm: khi agent fail trên production, **thủ phạm gần như không bao giờ là model hay prompt — mà là tầng harness** (orchestration, tool integration, context management, error handling, verification) bao quanh model.

## Key takeaways

- **[[harness-engineering|Harness layer, không phải model layer]]**: Tối ưu prompt có lợi ích giảm dần sau ~85-90% completion rate. Từ 90% lên 97% cần engineering (verification loop, error handling, fallback, observability), không phải prompting.

- **[[silent-tool-call-failures|Silent tool call failures]]** là reliability killer phổ biến và đắt nhất: tool integration nuốt exception, trả về rỗng thay vì báo lỗi, agent chạy tiếp trên tiền đề sai. Fix bằng `verify_tool_output` sau mỗi tool call — một deployment tăng completion rate từ 81% → 94% mà không đổi model/prompt.

- **[[context-window-management|Context window overflow]]** đánh vào chính các task giá trị cao (multi-step, tài liệu lớn, long-horizon). Cần token budget tracking, context tier, và checkpoint-resume.

- **[[agent-observability|Observability]]**: application monitoring chuẩn không đủ — agent cần **execution trace có cấu trúc** với span-level tracing ([[opentelemetry|OpenTelemetry]]), logging I/O mỗi tool call, context snapshot, và cost attribution per task.

- **[[agent-cost-management|Cost envelope]] cần hard limit, không phải soft alert**: câu chuyện agent kẹt retry loop đốt **$800 trong 40 phút**. Class `CostEnvelope` enforce hard limit tại orchestration layer + fail gracefully.

- **[[evaluation-pipeline|Evaluation pipeline]]** là production infrastructure chạy liên tục, không phải bước QA trước deploy: model-graded evaluator, metric aggregate theo thời gian, alert khi degradation, feedback loop về backlog.

- **[[harness-checklist|Harness checklist]]** 7 bước ưu tiên: verification → cost envelope → execution trace → retry/backoff → context budget → checkpoint-resume → continuous eval.

Bài học lớn: production AI agent là **systems engineering problem**. Model chỉ là một component; harness là phần còn lại và là nơi reliability được quyết định.
