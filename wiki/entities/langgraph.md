---
title: "LangGraph"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [entity, framework, langgraph, langchain, workflows]
---

# LangGraph

Workflow engine dạng **graph** của LangChain. Xuất sắc cho ứng dụng **stateful có cycle** (vòng lặp).

- Hỗ trợ [[human-in-the-loop|HITL]] qua **Human node tường minh** trong workflow graph.
- Đã tích hợp [[ag-ui|AG-UI]] protocol.

Triển khai một biến thể của [[react-pattern|ReAct]]. Nằm trong hệ sinh thái framework rộng hơn (xem [[agent-frameworks-comparison]]). Được phát triển bởi [[langchain|LangChain]] — nhiều tổ chức build custom agent trên LangChain/LangGraph (theo [[state-of-agent-engineering-langchain|khảo sát LangChain 2026]]).

**Dùng trong production**: [[grab-multi-agent-engineering-support|Grab]] dùng LangGraph (cùng FastAPI + Redis + PostgreSQL) để quản state multi-agent + context handoff cho hệ 5-agent "huddle".
