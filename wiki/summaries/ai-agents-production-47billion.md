---
title: "AI Agents trên Production (47Billion, 2026)"
type: summary
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
  - "https://47billion.com/blog/ai-agents-in-production-frameworks-protocols-and-what-actually-works-in-2026/"
tags: [ai-agents, production, frameworks, protocols, react-pattern, multi-agent]
---

# AI Agents trên Production — Frameworks, Protocols và Những Gì Thực Sự Hoạt Động (47Billion, 2026)

Báo cáo thực chiến của [[47billion]] (tác giả KamalPreet Singh & Samyak Jain, 24/02/2026), đúc kết từ 4 tháng xây dựng nhiều PoC và một hệ thống production cho công ty bảo hiểm toàn cầu. Thông điệp trung tâm: bối cảnh AI agent năm 2025-2026 **đồng thời mạnh mẽ hơn và mong manh hơn** so với những gì marketing ngụ ý — khoảng cách giữa demo và production rộng hơn nhiều so với thừa nhận thông thường.

## Key takeaways

- **Định nghĩa & phân loại**: AI agent khác chatbot ở **tính tự chủ** (agent hoàn thành nhiệm vụ, chatbot chỉ trả lời). Học thuật có [[ai-agent-types|5 loại agent]]; LLM agent hiện đại là kết hợp của goal-based, utility-based và learning.

- **[[react-pattern|ReAct pattern]]** (Reasoning + Acting) là lõi của mọi framework đã test. Chất lượng agent phụ thuộc vào tích hợp tooling nhiều hơn độ thông minh của LLM.

- **[[autonomy-spectrum|Phổ autonomy]]** có 4 level: Prompt Chaining → Workflows with Branching → Tool-Using Agents → Multi-Agent. **Level 2-3 là điểm ngọt cho production**; Level 4 hấp dẫn cho demo nhưng đau đớn thực tế.

- **[[agent-frameworks-comparison|So sánh 3 framework]]**: [[autogen|AutoGen]] (hội thoại, mạnh nhưng đắt token), [[crewai|CrewAI]] (task-based, cân bằng thực tế — build hệ thống đặt bàn trong 1 tuần so với 3 tuần của AutoGen), [[llamaindex|LlamaIndex]] (chuyên gia document/RAG).

- **[[human-in-the-loop|Human-in-the-Loop]]** không phải hạn chế mà là **yêu cầu** cho hệ thống đáng tin cậy. Nguyên tắc: progressive autonomy — bắt đầu nhiều can thiệp, giảm dần khi hệ thống chứng minh được.

- **[[agent-protocols/index|Stack protocol]]**: [[mcp|MCP]] (agent ↔ tool), [[a2a|A2A]] (agent ↔ agent), [[ag-ui|AG-UI]] (agent ↔ UI) — bổ trợ nhau và đang hội tụ thành infrastructure chuẩn.

- **[[agent-cost-management|Chi phí]]** là cấp số nhân, không cộng: multi-agent tốn 5-10 lần single agent. Cost monitoring không thể thương lượng.

- **[[production-reliability|Reliability]]**: simple workflow & tool-using agent production-ready (với guardrail); multi-agent open-ended thì chưa. Bảo hiểm bắt đầu 85% accuracy, đạt 95% sau 2 tháng tuning.

- **[[agent-deployment-roadmap|Roadmap 3 phase]]**: Quick Wins (CrewAI + cost monitoring) → Production Hardening (LlamaIndex, HITL, eval) → Advanced (multi-agent, MCP/A2A/AG-UI).

Bài học lớn: build agent ban đầu chiếm 20% effort, đưa lên production chiếm 80%; **narrow agent đánh bại general agent**.
