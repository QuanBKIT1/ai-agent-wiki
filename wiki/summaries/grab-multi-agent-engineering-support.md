---
title: "From Firefighting to Building — Multi-Agent Engineering Support (Grab)"
type: summary
created: 2026-07-03
updated: 2026-07-03
sources:
  - "[[raw/ai-agents-production/grab-multi-agent-engineering-support]]"
  - "https://engineering.grab.com/from-firefighting-to-building"
tags: [ai-agents, production, case-study, grab, multi-agent, orchestration, langgraph, human-in-the-loop]
---

# From Firefighting to Building — Multi-Agent Engineering Support (Grab)

> 📖 Bản đầy đủ: [[articles/grab-multi-agent-engineering-support]]

Case study production của Grab (blog engineering, 19/03/2026) về hệ **multi-agent** tự động hóa support cho nền tảng dữ liệu nội bộ (ADW). Đây là **case study orchestration production thứ 2** trong wiki (sau [[stripe-financial-compliance-agents|Stripe]]), và là ví dụ cụ thể cho nhiều pattern trong [[deployment-topologies]] + [[agent-service-architecture]]. (Bài **backfill**: nguồn primary hợp lệ của bài InfoQ bị chặn CAPTCHA; ngoài cửa sổ 7 ngày.)

## Key takeaways

- **Bối cảnh**: ADW phục vụ **1.000+ users/tháng**, **15.000+ tables**, ~**50%** query của data lake; team tốn **~40% thời gian (≈2 ngày/tuần)** cho support lặp lại.

- **5 agent chuyên biệt** + **Classifier** định tuyến "huddle": **Data Agent** (Trino/Hive/Delta Lake, detect PII), **Code Search Agent** (GitLab lineage), **On-call Agent** (Slack/Confluence/Airflow), **Summarizer**, **Enhancement Agent** (sinh code → MR → staging). Agent chạy **tuần tự**, orchestrator quản state + context handoff — minh họa "orchestrator + isolated specialists" của [[deployment-topologies]].

- **Stack**: FastAPI + **[[langgraph|LangGraph]]** (multi-agent state) + Redis + PostgreSQL + tiktoken + RAG; tích hợp Hubble/Genchi/Lighthouse.

- **2 workflow**: Investigation (Classifier → specialists → Summarizer) và Enhancement (sinh code → MR → test → **human duyệt cuối**, minh họa [[human-in-the-loop]]).

- **Kết quả**: response từ "hours" xuống **"within minutes"**; reclaim **vài FTE** + **hàng trăm giờ/tháng**; chuyển từ reactive support sang proactive roadmap.

- **Nguyên tắc**: "**specialists over generalists**" (khớp [[crewai-production-lessons|CrewAI]] narrow-agent), strategic human oversight, safety layers (SQL validation, timeout, mandatory review, HITL feedback).

Đối chiếu Stripe (compliance, DAG) vs Grab (engineering support, huddle tuần tự): cùng thông điệp **infrastructure-first + specialists + HITL**.
