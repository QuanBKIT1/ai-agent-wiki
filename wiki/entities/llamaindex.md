---
title: "LlamaIndex"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [entity, framework, llamaindex, rag, workflows]
---

# LlamaIndex

Framework với **LlamaIndex Workflows**, xuất sắc cho ứng dụng **document-heavy, RAG-centric**. Được mô tả là "chuyên gia tài liệu".

- **Phù hợp nhất**: workflow RAG nặng, xử lý và trích xuất dữ liệu từ tài liệu.
- **Điểm mạnh**: xử lý tài liệu & information retrieval xuất sắc; abstraction sạch cho workflow step; **event-driven architecture** giúp thêm logging/retry tự nhiên; tích hợp chặt với RAG infrastructure.
- **Điểm yếu**: tài liệu cho use case nâng cao thưa thớt; debug workflow phức tạp cần custom tooling; error handling cần work nhiều; không phải lựa chọn cho orchestration thuần túy.
- **Chi phí**: $0.20–$1.00/task, 1,000–5,000 token — hiệu quả chi phí tốt.

Được thêm ở Phase 2 trong [[agent-deployment-roadmap]]. So sánh tại [[agent-frameworks-comparison]].
