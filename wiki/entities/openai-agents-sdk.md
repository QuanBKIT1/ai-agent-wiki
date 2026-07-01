---
title: "OpenAI Agents SDK"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [entity, framework, openai, agents-sdk]
---

# OpenAI Agents SDK

SDK agent do OpenAI ra mắt 3/2025, với cách tiếp cận **tối giản** dựa trên 4 primitive cốt lõi:

- **Agents**
- **Handoffs** — primitive route đến agent khác hoặc human agent ([[human-in-the-loop|HITL]])
- **Guardrails**
- **Tracing**

Đặc điểm: **provider-agnostic**, hoạt động với 100+ LLM. Triển khai một biến thể của [[react-pattern|ReAct]].

Được đánh giá ở Phase 2 của [[agent-deployment-roadmap]] như một lựa chọn đơn giản hơn cho dự án mới. Nằm trong hệ sinh thái framework rộng hơn (xem [[agent-frameworks-comparison]]).
