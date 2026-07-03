---
title: "Grab"
type: entity
created: 2026-07-03
updated: 2026-07-03
sources:
  - "[[raw/ai-agents-production/grab-multi-agent-engineering-support]]"
  - "[[raw/ai-agents-production/grab-palana-secure-agent-platform]]"
tags: [entity, company, grab, case-study, multi-agent, security, langgraph]
---

# Grab

Super-app fintech/mobility Đông Nam Á. Trong wiki, xuất hiện qua **2 case study production AI agent** trên blog engineering của họ — bổ sung góc "engineering nội bộ" bên cạnh case study [[stripe|Stripe]] (compliance).

- **Multi-agent engineering support** ([[grab-multi-agent-engineering-support|From firefighting to building]], 19/03/2026): 5 agent chuyên biệt (Data / Code Search / On-call / Summarizer / Enhancement) + Classifier điều phối "huddle" cho ADW platform (**1.000+ users, 15.000+ tables**). Stack **FastAPI + [[langgraph|LangGraph]] + Redis + PostgreSQL**. Giải phóng vài FTE + hàng trăm giờ/tháng.
- **Palana** ([[grab-palana-secure-agent-platform|Palana Part 1]], 19/06/2026): substrate Kubernetes-native chạy agentic workload an toàn (namespace/RBAC cô lập, **proxy-only secrets**, egress qua Envoy). Đang chạy **hàng trăm agent**.

## Xem thêm
- [[grab-multi-agent-engineering-support]] · 📖 [[articles/grab-multi-agent-engineering-support]]
- [[grab-palana-secure-agent-platform]] · 📖 [[articles/grab-palana-secure-agent-platform]]
- [[agent-service-architecture]] — đối chiếu với kiến trúc agent service của Stripe
- [[deployment-topologies]] — "huddle" ~ multi-agent distributed + hierarchical
- [[stripe]] — case study production còn lại trong wiki
