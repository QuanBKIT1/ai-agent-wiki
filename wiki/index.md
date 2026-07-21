# Index — AI Agent Wiki

> Knowledge base tổng hợp về AI/LLM — song ngữ Việt-Anh. Kiến thức được compile từ các bài báo, blog, papers.

## 🔖 Navigation
- [[#📖 Bài viết đầy đủ|Bài viết]] · [[#Concepts]] · [[#Entities]] · [[#Summaries]] · [[#Open Questions]]

## 📖 Bài viết đầy đủ

Bản viết lại **đầy đủ, dễ đọc** bằng tiếng Việt của các bài crawl (khác với tóm tắt ngắn ở Summaries). Xem tất cả: [[articles/index|📖 Bài viết (Tiếng Việt)]].

- [[articles/stripe-financial-compliance-agents]] — Case study Stripe (AWS, 26/06/2026)
- [[articles/agent-observability-guide-braintrust]] — Agent observability guide (Braintrust, 21/06/2026, *backfill*)
- [[articles/state-of-agent-engineering-langchain]] — State of Agent Engineering, khảo sát 1.340 người (LangChain, 12/06/2026, *backfill*)
- [[articles/crewai-production-lessons]] — CrewAI production lessons (AgileSoftLabs, 15/06/2026, *backfill*)
- [[articles/lessons-learned-harness-engineering]] — Bài học harness engineering (10/03/2026)
- [[articles/deploying-ai-agents-mlm]] — Kiến trúc & hạ tầng deploy (03/03/2026)
- [[articles/ai-agents-production-47billion]] — Tổng quan frameworks & protocols (24/02/2026)

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
- [[concepts/agent-cost-management]] — chi phí là cấp số nhân; cost table + CostEnvelope hard limit
- [[concepts/agent-deployment-roadmap]] — roadmap 3 phase áp dụng agent vào production

### Deployment & Infrastructure
- [[concepts/agent-execution-models]] — 3 model: Stateless, Stateful, Event-driven; production trộn cả ba
- [[concepts/agent-infrastructure-stack]] — 5 layer: Compute → Storage → Communication → Observability → Security
- [[concepts/deployment-topologies]] — 4 topology: Single, Multi-Agent, Pools, Hierarchical + Human Oversight
- [[concepts/deployment-decision-framework]] — map yêu cầu (scaling/state/complexity/budget/team) vào pattern kiến trúc
- [[concepts/agent-service-architecture]] — Agent Service microservice riêng + LLM Proxy + DAG decomposition (case study Stripe)

### Harness Engineering (Production Lessons)
- [[concepts/harness-engineering]] — failure ở tầng harness, không phải model; prompt có lợi ích giảm dần
- [[concepts/silent-tool-call-failures]] — reliability killer #1; verify_tool_output → 81% lên 94%
- [[concepts/context-window-management]] — overflow đánh vào task giá trị cao; budget + tier + checkpoint
- [[concepts/agent-observability]] — execution trace, span-level (OpenTelemetry), cost attribution
- [[concepts/evaluation-pipeline]] — continuous eval là production infrastructure, không phải QA
- [[concepts/harness-checklist]] — 7 bước ưu tiên build harness

## Entities

### Frameworks
- [[entities/autogen]] — framework hội thoại, mạnh nhưng đắt token
- [[entities/crewai]] — framework task-based, cân bằng thực tế
- [[entities/llamaindex]] — framework Workflows, chuyên gia document/RAG
- [[entities/openai-agents-sdk]] — SDK tối giản, 4 primitive, provider-agnostic
- [[entities/langgraph]] — workflow engine dạng graph của LangChain

### Organizations
- [[entities/47billion]] — tác giả báo cáo AI Agents in Production 2026
- [[entities/harness-engineering-blog|Harness Engineering]] — blog production lessons (harness layer)
- [[entities/anthropic]] — phát hành MCP
- [[entities/google]] — phát hành A2A
- [[entities/copilotkit]] — phát hành AG-UI
- [[entities/machinelearningmastery]] — blog giáo dục ML/AI; publisher bài Deploying AI Agents (2026)
- [[entities/stripe]] — fintech; case study production AI agent cho financial compliance (2026)

### People
- [[entities/sarah-chen]] — tác giả bài Harness Engineering lessons learned

### Tools & Standards
- [[entities/opentelemetry]] — chuẩn observability cho span-level agent tracing
- [[entities/braintrust]] — platform agent observability + evaluation (trace → eval → CI gate)
- [[entities/langchain]] — hệ sinh thái LangChain/LangGraph; publisher báo cáo State of Agent Engineering

## Summaries (chronological)
- 2026-02-24 — [[summaries/ai-agents-production-47billion]] — báo cáo 47Billion: frameworks, protocols, production lessons
- 2026-03-03 — [[summaries/deploying-ai-agents-mlm]] — MachineLearningMastery: execution models, 5-layer infra stack, deployment topologies, roadmap
- 2026-03-10 — [[summaries/lessons-learned-harness-engineering]] — Harness Engineering: failure ở tầng harness, verify/cost/observability/eval
- 2026-06-12 — [[summaries/state-of-agent-engineering-langchain]] — LangChain: khảo sát 1.340 người; 57,3% production, 89% observability, 75%+ multi-model *(backfill)*
- 2026-06-15 — [[summaries/crewai-production-lessons]] — CrewAI production: narrow agents, max_iter, $/run, sequential>hierarchical, Pydantic *(backfill)*
- 2026-06-21 — [[summaries/agent-observability-guide-braintrust]] — Braintrust: 4 loại span, APM vs agent-obs, trace→eval→CI gate *(backfill)*
- 2026-06-26 — [[summaries/stripe-financial-compliance-agents]] — Stripe/AWS: Agent Service microservice, LLM Proxy, DAG, prompt caching 60%, HITL compliance

## Digests
- [[digests/index|Weekly Crawl Digests]] — tổng hợp crawl hằng tuần các bài AI-agent-in-production mới nhất
    - [[digests/2026-07-01-digest|2026-07-01]] — 1 bài mới: AWS/Stripe production AI agents cho financial compliance
    - [[digests/2026-07-01-backfill-digest|2026-07-01 (backfill)]] — 2 bài backfill: Braintrust observability + CrewAI production lessons
    - [[digests/2026-07-02-digest|2026-07-02]] — không có bài mới trong cửa sổ 7 ngày
    - [[digests/2026-07-02-backfill-digest|2026-07-02 (backfill)]] — 1 bài backfill: LangChain State of Agent Engineering (survey)
    - [[digests/2026-07-03-digest|2026-07-03]] — không có bài mới trong cửa sổ 7 ngày

## Open Questions

- So sánh hiệu quả giữa AutoGen, CrewAI, và LlamaIndex cho multi-agent systems?
- Best practices cho cost management trong production AI agents?
- MCP vs A2A: khi nào dùng cái nào?
- Observability stack nào phù hợp nhất cho AI agents? (một phần trả lời bởi [[concepts/agent-observability]] — OpenTelemetry span-level)
