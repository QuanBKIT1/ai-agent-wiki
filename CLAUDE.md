# AI Agent Wiki — Knowledge Base

> Schema document — read at the start of every session together with `wiki/index.md`.
> Update after every major compile, ingest batch, or structural change.

## Scope

What this wiki covers:
- AI Agents: architecture, deployment, production operations, frameworks
- LLM applications: RAG, fine-tuning, prompt engineering, evaluation
- Protocols & standards: MCP, A2A, AG-UI
- Production lessons: cost management, observability, debugging, scaling

What this wiki deliberately excludes:
- General machine learning theory (classical ML, non-LLM deep learning)
- Hardware/chip design
- AI ethics/policy (unless directly related to production guardrails)

## Operations

This wiki follows the llm-wiki skill's five operations: `compile`, `ingest`, `query`, `lint`, `audit`.
Every operation appends an entry to `log/YYYYMMDD.md`.

## Naming conventions

- **Concept pages** (`wiki/concepts/`): Title Case noun phrases, kebab-case filenames.
- **Folder-split concepts** (`wiki/concepts/<topic>/`): used when a topic exceeds ~1200 words. Contains `index.md` + one file per aspect.
- **Entity pages** (`wiki/entities/`): Proper names, kebab-case filenames.
- **Summary pages** (`wiki/summaries/`): kebab-case source slug.
- **File names**: always English, kebab-case (`deployment-topologies.md`)
- **Wikilinks**: English names (`[[deployment-topologies]]`)

All pages require YAML frontmatter: `title`, `type`, `created`, `updated`, `sources`, `tags`.

### Language rules
- Technical terms: keep English (ReAct pattern, Multi-Agent, Deployment Topology, MCP, A2A, Observability...)
- Explanations and descriptions: Vietnamese
- Example: "## ReAct Pattern\n\nReAct (Reasoning + Acting) là pattern phổ biến nhất..."

### Diagrams and formulas
- All diagrams are **mermaid**. No ASCII art.
- All formulas are **KaTeX** (inline `$...$` or block `$$...$$`).

### Raw file policy
- Small text sources → copy into `raw/<category>/`.
- Raw files organized by category: `raw/ai-agents-production/`, `raw/rag/`, etc.
- Large binaries → create a pointer file at `raw/refs/<slug>.md`.

## Current articles

- 47Billion — AI Agents in Production (2026-02-24) → [[summaries/ai-agents-production-47billion]]
- MachineLearningMastery — Deploying AI Agents to Production (2026-03-03) → [[summaries/deploying-ai-agents-mlm]]
- Harness Engineering — Lessons Learned Deploying AI Agents (2026-03-10) → [[summaries/lessons-learned-harness-engineering]]
- AWS/Stripe — Production-Grade AI Agents for Financial Compliance (2026-06-26) → [[summaries/stripe-financial-compliance-agents]]
- Braintrust — Agent Observability: The Complete Guide for 2026 (2026-06-21, *backfill*) → [[summaries/agent-observability-guide-braintrust]]
- AgileSoftLabs — CrewAI in Production 2026: Real Lessons (2026-06-15, *backfill*) → [[summaries/crewai-production-lessons]]

### Concepts
- [[concepts/ai-agent-types]]
- [[concepts/react-pattern]]
- [[concepts/autonomy-spectrum]]
- [[concepts/agent-frameworks-comparison]]
- [[concepts/human-in-the-loop]]
- [[concepts/production-reliability]]
- [[concepts/agent-cost-management]]
- [[concepts/agent-deployment-roadmap]]
- [[concepts/agent-protocols/index]] (folder-split: mcp, a2a, ag-ui)
- [[concepts/harness-engineering]]
- [[concepts/silent-tool-call-failures]]
- [[concepts/context-window-management]]
- [[concepts/agent-observability]]
- [[concepts/evaluation-pipeline]]
- [[concepts/harness-checklist]]
- [[concepts/agent-execution-models]]
- [[concepts/agent-infrastructure-stack]]
- [[concepts/deployment-topologies]]
- [[concepts/deployment-decision-framework]]
- [[concepts/agent-service-architecture]]

### Entities
- [[entities/autogen]], [[entities/crewai]], [[entities/llamaindex]], [[entities/openai-agents-sdk]], [[entities/langgraph]]
- [[entities/47billion]], [[entities/anthropic]], [[entities/google]], [[entities/copilotkit]]
- [[entities/harness-engineering-blog]], [[entities/sarah-chen]], [[entities/opentelemetry]]
- [[entities/machinelearningmastery]], [[entities/stripe]], [[entities/braintrust]]

### Summaries
- [[summaries/ai-agents-production-47billion]]
- [[summaries/deploying-ai-agents-mlm]]
- [[summaries/lessons-learned-harness-engineering]]
- [[summaries/stripe-financial-compliance-agents]]
- [[summaries/agent-observability-guide-braintrust]] (backfill)
- [[summaries/crewai-production-lessons]] (backfill)

## Open research questions

- So sánh hiệu quả giữa AutoGen, CrewAI, và LlamaIndex cho multi-agent systems?
- Best practices cho cost management trong production AI agents?
- MCP vs A2A: khi nào dùng cái nào?

## Research gaps

Sources to ingest:
- [x] 47Billion AI Agents Production report (2026-02-24)
- [x] Harness Engineering lessons learned (2026-03-10)
- [x] MachineLearningMastery deploying AI agents (2026-03-03)
- [x] AWS/Stripe production-grade AI agents for financial compliance (2026-06-26)

## Audit backlog

*(none — run `python3 scripts/audit_review.py ~/workspace/ai-agent-wiki --open` to refresh)*

## Notes for the LLM

- Language: bilingual (technical terms EN, explanations VN)
- Tone: technical but accessible
- Depth: deep technical with practical examples
- Handling contradictions: state both, cite each, add to Open Research Questions.
