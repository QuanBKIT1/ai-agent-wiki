---
title: "Human-in-the-Loop (HITL)"
type: concept
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [ai-agents, hitl, production, reliability, guardrails]
---

# Human-in-the-Loop (HITL)

Mọi demo framework cho thấy hoạt động tự chủ hoàn toàn, nhưng thực tế production đòi hỏi **checkpoint con người**. Đây có lẽ là bài học quan trọng nhất từ triển khai thực tế:

> **HITL không phải hạn chế của hệ thống agent. Nó là yêu cầu để có hệ thống đáng tin cậy.**

## Tại sao HITL quan trọng

- **Xây dựng niềm tin**: Người dùng chưa tin agent hoàn toàn tự chủ — và thực sự, họ không nên tin.
- **Phục hồi lỗi**: Khi agent đi sai, con người bắt được trước khi lỗi cascading.
- **Compliance và audit**: Trong ngành regulated (finance, healthcare, education), cần chứng minh con người duyệt quyết định quan trọng.
- **Kiểm soát chất lượng**: Cho tạo nội dung, review của con người đảm bảo chất lượng.

## 4 pattern HITL

| Pattern | Khi nào dùng | Ví dụ |
|---|---|---|
| **Approval Gates** | Trước hành động không thể đảo ngược | Con người duyệt trước khi tạo báo cáo cuối |
| **Review & Edit** | Cho chất lượng nội dung | Trainer review kịch bản training do AI tạo |
| **Escalation** | Khi agent confidence thấp | Agent route đến con người khi không chắc |
| **Feedback Loop** | Cải thiện liên tục | Người dùng chấm điểm agent; hệ thống học |

## Hỗ trợ HITL trong các framework

- **[[autogen|AutoGen]]**: `human_input_mode` built-in với ba chế độ `ALWAYS`, `TERMINATE`, `NEVER`
- **[[crewai|CrewAI]]**: tham số `human_input=True` trên task
- **[[langgraph|LangGraph]]**: Human node tường minh trong workflow graph
- **[[openai-agents-sdk|OpenAI Agents SDK]]**: Handoff primitive route đến human agent

## Progressive autonomy

Nguyên tắc cốt lõi là **progressive autonomy**: bắt đầu với nhiều can thiệp con người, sau đó **giảm dần** khi hệ thống chứng minh được độ tin cậy. Không phải ngược lại.

```mermaid
flowchart LR
    A[Nhiều HITL<br/>lúc mới ship] --> B[Agent chứng minh<br/>độ tin cậy]
    B --> C[Giảm dần<br/>can thiệp]
    C --> D[Autonomy cao hơn<br/>trong phạm vi hẹp]
```

Cùng với [[production-reliability|guardrails khác]] (output validation, cost limit, action constraint), HITL là infrastructure thiết yếu chứ không phải nice-to-have.

## Ví dụ production: Stripe compliance review

[[stripe-financial-compliance-agents|Stripe]] là minh chứng HITL bắt buộc trong ngành regulated: agent **không tự quyết định** — output chỉ là thông tin bổ trợ, reviewer con người vẫn phải trả lời từng sub-task của review. Pattern này thuộc nhóm **Approval Gates + Review & Edit**, và vẫn tạo ROI rõ rệt (giảm 26% median handling time, >96% helpfulness) đồng thời đạt chuẩn audit cho examination. Bài học: HITL + rail hẹp cho agent không làm mất giá trị, mà là điều kiện để triển khai được ở ngành finance.

## Xem thêm
- [[production-reliability]] — reliability playbook đầy đủ
- [[ag-ui]] — protocol hỗ trợ HITL approval ở tầng UI
- [[stripe-financial-compliance-agents]] · [[agent-service-architecture]] — HITL trong kiến trúc production thực tế
