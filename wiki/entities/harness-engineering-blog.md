---
title: "Harness Engineering"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/02_Lessons_Learned_Harness_Engineering_VN]]"
  - "https://harness-engineering.ai/blog/lessons-learned-from-deploying-ai-agents-in-production/"
tags: [entity, organization, blog, production, harness]
---

# Harness Engineering

Nguồn (blog/tổ chức) xuất bản bài "Lessons Learned from Deploying AI Agents in Production" (10/03/2026, cập nhật 02/04/2026), tác giả Dr. [[sarah-chen|Sarah Chen]].

Nội dung mang tính **incident retrospective**: đúc kết failure mode xuất hiện *sau* launch từ hàng chục lần deploy agent, với code Python thực tế (`verify_tool_output`, `CostEnvelope`). Luận điểm trung tâm cho tên gọi: reliability của AI agent được quyết định ở tầng **harness** ([[harness-engineering|harness engineering]]) chứ không phải tầng model.

## Đóng góp vào wiki
- [[summaries/lessons-learned-harness-engineering|Summary]] của bài viết
- Concepts: [[harness-engineering]], [[silent-tool-call-failures]], [[context-window-management]], [[agent-observability]], [[evaluation-pipeline]], [[harness-checklist]]
