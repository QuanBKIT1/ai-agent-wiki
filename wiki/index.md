# Index — AI Agent Wiki

> Knowledge base tổng hợp về AI/LLM — song ngữ Việt-Anh. Kiến thức được compile từ các bài báo, blog, papers.

## 🔖 Navigation
- [[#Concepts]] · [[#Entities]] · [[#Summaries]] · [[#Open Questions]]

## Concepts

### AI Agents Fundamentals
- [[concepts/ai-agent-types]] — 5 loại agent học thuật; LLM agent hiện đại là kết hợp goal/utility/learning
- [[concepts/react-pattern]] — vòng lặp Reasoning + Acting, lõi của mọi framework
- [[concepts/autonomy-spectrum]] — 4 level: Prompt Chaining → Multi-Agent; Level 2-3 là điểm ngọt

### Frameworks
- [[concepts/agent-frameworks-comparison]] — AutoGen vs CrewAI vs LlamaIndex và hệ sinh thái rộng hơn

### Protocols
- [[concepts/agent-protocols/index|Agent Protocol Stack]] — MCP, A2A, AG-UI bổ trợ nhau
    - [[concepts/agent-protocols/mcp|MCP]] — Model Context Protocol (agent ↔ tool)
    - [[concepts/agent-protocols/a2a|A2A]] — Agent-to-Agent Protocol (agent ↔ agent)
    - [[concepts/agent-protocols/ag-ui|AG-UI]] — Agent-User Interaction Protocol (agent ↔ UI)

### Production
- [[concepts/human-in-the-loop]] — HITL là yêu cầu cho hệ thống đáng tin cậy; progressive autonomy
- [[concepts/production-reliability]] — reliability playbook, 6 bài học, bảo mật & compliance
- [[concepts/agent-cost-management]] — chi phí là cấp số nhân; cost table per task
- [[concepts/agent-deployment-roadmap]] — roadmap 3 phase áp dụng agent vào production

## Entities

### Frameworks
- [[entities/autogen]] — framework hội thoại, mạnh nhưng đắt token
- [[entities/crewai]] — framework task-based, cân bằng thực tế
- [[entities/llamaindex]] — framework Workflows, chuyên gia document/RAG
- [[entities/openai-agents-sdk]] — SDK tối giản, 4 primitive, provider-agnostic
- [[entities/langgraph]] — workflow engine dạng graph của LangChain

### Organizations
- [[entities/47billion]] — tác giả báo cáo AI Agents in Production 2026
- [[entities/anthropic]] — phát hành MCP
- [[entities/google]] — phát hành A2A
- [[entities/copilotkit]] — phát hành AG-UI

## Summaries (chronological)
- 2026-02-24 — [[summaries/ai-agents-production-47billion]] — báo cáo 47Billion: frameworks, protocols, production lessons

## Open Questions

- So sánh hiệu quả giữa AutoGen, CrewAI, và LlamaIndex cho multi-agent systems?
- Best practices cho cost management trong production AI agents?
- MCP vs A2A: khi nào dùng cái nào?
- Observability stack nào phù hợp nhất cho AI agents?
