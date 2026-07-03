---
title: "Palana — Secure Platform for Autonomous AI Agents (Grab)"
type: summary
created: 2026-07-03
updated: 2026-07-03
sources:
  - "[[raw/ai-agents-production/grab-palana-secure-agent-platform]]"
  - "https://engineering.grab.com/palana-part-1-secure-platform-for-ai-agents"
tags: [ai-agents, production, security, infrastructure, kubernetes, grab, guardrails]
---

# Palana — Secure Platform for Autonomous AI Agents (Grab)

> 📖 Bản đầy đủ: [[articles/grab-palana-secure-agent-platform]]

Bài của team CyberSecurity Grab (blog engineering, 19/06/2026) về **Palana** — substrate Kubernetes-native để chạy agentic workload **an toàn**. Bổ sung mảng còn thiếu của wiki: **agent security/isolation ở tầng hạ tầng** (bổ trợ [[agent-infrastructure-stack|Security layer]] và [[production-reliability]]). (Bài **backfill**: ngoài cửa sổ 7 ngày.)

## Key takeaways

- **Palana là gì**: "secure execution substrate for autonomous and semi-autonomous agents" — môi trường **chứa (containing)** agent, tách biệt với trí tuệ của agent. Tên tiếng Phạn = protection/care.

- **Vì sao xây**: security research cần test **OpenClaw** + agent framework mà không phơi internal network / nhúng raw credential; developer cần **long-running agent** giữ context, truy cập service đã duyệt, không phải dựng infra bespoke.

- **Quy mô**: đang chạy **hàng trăm agent** — remote dev environment, Slack automation, OpenClaw workers, Hermes agents.

- **Security model** (điểm giá trị nhất):
  - **Kubernetes-native**: agent = custom resource; operator reconcile namespace/RBAC/storage/policy.
  - Mỗi agent có **namespace + service account + storage cô lập**.
  - **Proxy-only secrets**: agent chỉ thấy placeholder token; proxy layer thay bằng secret thật → credential không bao giờ lộ cho agent.
  - **Egress qua Envoy** có policy + structured logging.
  - **Control plane tách ngoài** agent process → agent bị compromise cũng không tắt được safeguard.

Ý nghĩa: khi agent chạy code/tool tự chủ ở scale, **containment ở tầng hạ tầng** (không chỉ prompt guardrail) trở thành yêu cầu — bổ sung cho góc bảo mật của [[production-reliability]] và [[human-in-the-loop]].
