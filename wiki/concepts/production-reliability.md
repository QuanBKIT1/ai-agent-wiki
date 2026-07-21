---
title: "Production Reliability & Security"
type: concept
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
  - "[[raw/ai-agents-production/02_Lessons_Learned_Harness_Engineering_VN]]"
  - "[[raw/ai-agents-production/ade-prf-agent-reliability-prediction]]"
  - "[[raw/ai-agents-production/anthropic-2026-state-of-ai-agents]]"
tags: [ai-agents, production, reliability, guardrails, security, compliance, harness, prediction]
---

# Production Reliability & Security

Agent có thực sự tin được cho production không? Câu trả lời trung thực, phân loại theo độ phức tạp (ánh xạ với [[autonomy-spectrum]]):

| Loại hệ thống | Production Ready? | Cần gì |
|---|---|---|
| Simple Workflows | Có | Error handling, input validation, monitoring |
| Tool-Using Agents | Có, với guardrail | Output validation, cost limit, fallback |
| Multi-Agent (có cấu trúc) | Cẩn trọng có | Guardrail mạnh, HITL checkpoint, progressive rollout |
| Multi-Agent (open-ended) | Chưa | Vẫn quá khó đoán cho critical path |

## Reliability playbook

- **Output có cấu trúc với validation** — không bao giờ tin raw LLM output cho thứ đến tay end user.
- **Temperature thấp** cho task deterministic. "Sáng tạo là kẻ thù của reliability."
- **Ràng buộc tool use** — strict whitelist để ngăn agent gọi function ảo (không tồn tại).
- **Progressive rollout** — pilot internal → beta select customer → general availability.
- **Tinh chỉnh lặp** — dự án bảo hiểm bắt đầu ở **85% accuracy** và đạt **95% sau 2 tháng** tuning liên tục.

## 6 bài học khó khăn từ production (case study bảo hiểm)

Hệ thống mô phỏng huấn luyện bán hàng AI cho công ty bảo hiểm toàn cầu: hai agent (một đóng vai khách hàng, một đóng vai coach), build 4 tháng từ đầu đến production.

1. **Agent cần ranh giới rõ ràng tàn nhẫn** — giới hạn tool call tối đa, validate strict tool có sẵn, error message rõ ràng.
2. **Hội thoại dài phá vỡ mọi thứ** — session 30-45 phút cần **smart summarization** (giữ context quan trọng, cắt trao đổi dư thừa).
3. **Input không mong đợi là bình thường** — cần prompt engineering rộng và tinh chỉnh lặp để xử lý câu lạc đề, phản ứng cảm xúc.
4. **Cost monitoring là không thể thương lượng** — xem [[agent-cost-management]].
5. **Độ biến thiên response time quan trọng** — biến thiên (1s rồi 4s) gây khó chịu hơn chậm đều; thêm loading indicator, background processing, timeout.
6. **Tinh chỉnh không bao giờ kết thúc** — thay đổi nhỏ trong system prompt tạo pattern hội thoại rất khác.

## Bảo mật & Compliance

- **Prompt Injection** — input độc hại ghi đè instruction. Giảm thiểu: input sanitization, system prompt hardening, output validation.
- **Data Exposure** — multi-agent truyền context giữa agent, dữ liệu nhạy cảm có thể rò. Giải pháp: phân loại dữ liệu, lọc context giữa agent, audit log.
- **Cost Attacks** — xem [[agent-cost-management]].
- **Compliance** — audit trail cho mọi quyết định/tool call/output; data residency (LLM self-hosted / endpoint theo region); role-based access (RBAC) cho prompt management; reproducibility (version hóa hành vi agent).

## Tích hợp với kiến trúc hiện có

Với team chạy microservices (ví dụ 33 FastAPI service trên AWS EKS), agent không phải để thay thế — chúng là **tầng orchestration** ngồi trên service hiện có:

- Agent gọi API hiện có để làm việc thực; chúng điều phối, không thay thế.
- [[mcp|MCP]] cung cấp cách chuẩn expose microservice cho agent.
- Agent xử lý reasoning và sequencing; service xử lý execution.
- Test suite, monitoring, deployment pipeline hiện có vẫn nguyên vẹn.

Guardrails ([[human-in-the-loop|HITL]], output validation, action constraint, cost limit) là **infrastructure thiết yếu**, không phải nice-to-have. Về mặt kiến trúc, chúng nằm ở **Security layer** và **Observability layer** của [[agent-infrastructure-stack]] (vault cho secret, input validation, output filtering, audit trail).

## Góc nhìn Harness Engineering

Báo cáo 47Billion nói *cần gì* để reliable; [[harness-engineering|Harness Engineering]] nói *reliability được build ở đâu* — tầng harness, không phải model. Hai nguồn đồng thuận và bổ sung nhau:

- "Ranh giới rõ ràng tàn nhẫn" cho tool use ↔ [[silent-tool-call-failures|verification sau mỗi tool call]].
- "Hội thoại dài phá vỡ mọi thứ" + smart summarization ↔ [[context-window-management|context budget + tier]].
- "Cost monitoring không thể thương lượng" ↔ [[agent-cost-management|cost envelope với hard limit]].
- "Tinh chỉnh không bao giờ kết thúc" (85% → 95%) ↔ [[evaluation-pipeline|continuous evaluation]].
- Audit trail cho compliance ↔ [[agent-observability|execution trace + span tracing]].

Xem [[harness-checklist]] cho thứ tự ưu tiên build.

## Predictive reliability (leading indicator)

Reliability playbook ở trên chủ yếu là **reactive** (guardrail chặn, validate, rollback). [[ade-prf-agent-reliability-prediction|ADE-PRF]] thêm lớp **predictive** cho hệ multi-agent chạy dài: gộp 20 tín hiệu thành **Trust Margin (0–100)** và dự đoán health 8 giờ tới (Precision 89,3%, Recall 84,7% trên 380k prediction/15 ngày production), bắt sớm **"false prosperity"** — degradation bị metric bề mặt che. Threshold Trust Margin thấp trở thành alert phòng ngừa trước khi cascade. Bổ trợ cho [[agent-observability]] (từ trace phản ứng sang dự báo).

## Bối cảnh ngành (2026)

Số liệu adoption củng cố việc reliability/guardrail đã là mặc định production: [[anthropic-2026-state-of-ai-agents|khảo sát Anthropic]] (500+ leaders) cho thấy **86%** deploy coding agent cho production code, **42%** để agent *dẫn dắt với human oversight*, **80%** báo cáo ROI đo được — nhưng model production cần **secure với proprietary data + compliant + robust trước jailbreak**, đúng các mối lo ở mục Bảo mật & Compliance. Đối chiếu [[state-of-agent-engineering-langchain|LangChain survey]] (quality là rào cản #1: 32%).

## Xem thêm
- [[ade-prf-agent-reliability-prediction]] — predictive reliability (Trust Margin)
- [[anthropic-2026-state-of-ai-agents]] · [[state-of-agent-engineering-langchain]] — số liệu adoption/ROI/rào cản
- [[human-in-the-loop]] · [[agent-cost-management]] · [[autonomy-spectrum]]
- [[agent-deployment-roadmap]] — progressive rollout theo phase
- [[harness-engineering]] · [[harness-checklist]] — reliability ở tầng harness
