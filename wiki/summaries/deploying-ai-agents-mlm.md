---
title: "Triển Khai AI Agent Lên Production — Kiến Trúc, Hạ Tầng, Roadmap (MachineLearningMastery, 2026)"
type: summary
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/03_Deploying_AI_Agents_MLM_VN]]"
  - "https://machinelearningmastery.com/deploying-ai-agents-to-production-architecture-infrastructure-and-implementation-roadmap/"
tags: [ai-agents, production, deployment, architecture, infrastructure, topology]
---

# Triển Khai AI Agent Lên Production (MachineLearningMastery, 2026)

Bài hướng dẫn hệ thống của Vinod Chugani ([[machinelearningmastery|MachineLearningMastery]], 03/03/2026): cách đưa một AI agent từ prototype thành hệ thống production đáng tin cậy, scale được — bằng cách **chọn kiến trúc đúng, build hạ tầng phù hợp, và thực thi rollout plan thực tế**. Đây là góc nhìn *infrastructure/architecture* bổ sung cho góc nhìn *harness/reliability* của [[lessons-learned-harness-engineering|Harness Engineering]] và góc nhìn *adoption* của [[ai-agents-production-47billion|47Billion]].

## Key takeaways

- **[[agent-execution-models|3 execution model]]** cần chọn trước tiên: **Stateless** (mỗi request độc lập, scale ngang dễ), **Stateful** (nhớ session, cần state management + session affinity), **Event-driven** (phản ứng với event qua message queue, xử lý workflow chạy dài). Hầu hết hệ thống production **trộn cả ba**.

- **[[agent-infrastructure-stack|5-layer infrastructure stack]]**: Compute → Storage → Communication → Observability → Security. Mỗi layer có lựa chọn công nghệ và đánh đổi riêng (serverless vs container vs VM; Redis vs vector DB; REST vs WebSocket vs queue...).

- **[[deployment-topologies|4 deployment topology]]**: Single Agent, Multi-Agent Distributed, Agent Pools (load-balanced), Hierarchical (supervisor-worker). Cộng **Human Oversight pattern** cho quyết định rủi ro cao ([[human-in-the-loop|HITL]]). Topology chọn ảnh hưởng trực tiếp nhu cầu hạ tầng.

- **Roadmap 4 giai đoạn** (bổ sung cho [[agent-deployment-roadmap|roadmap 3 phase của 47Billion]]): Containerization (Docker multi-stage build, health check, registry) → Cloud Deployment (serverless cho stateless, orchestration cho stateful) → **CI/CD Pipeline** (eval-gated deploy, blue-green, shadow deployment, version hóa cả prompt/tool) → Monitoring & [[agent-observability|Observability]] (structured logging, custom metric, **Cost Per Task**, distributed tracing).

- **[[deployment-decision-framework|Decision framework]]**: map yêu cầu (scaling, state, complexity tolerance, budget, team expertise) vào pattern kiến trúc. Kubernetes nếu có DevOps mạnh; managed service (Cloud Run, Fargate) cho team nhỏ.

Thông điệp trung tâm: **"Agent ship được đánh bại kiến trúc hoàn hảo không bao giờ deploy."** Bắt đầu với kiến trúc đơn giản nhất chạy được, instrument kỹ, và để dữ liệu production hướng dẫn evolution.
