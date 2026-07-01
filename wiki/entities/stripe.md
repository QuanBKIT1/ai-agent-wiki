---
title: "Stripe"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/04_Stripe_Financial_Compliance_Agents_VN]]"
tags: [organization, fintech, production, case-study, compliance]
---

# Stripe

**Stripe** là công ty hạ tầng thanh toán, xử lý ~**$1.4 nghìn tỷ payment volume/năm** trên **50 quốc gia**. Trong bối cảnh wiki này, Stripe đáng chú ý vì [[stripe-financial-compliance-agents|case study production AI agent cho financial compliance]] (công bố cùng AWS, 26/06/2026).

## Vì sao liên quan

- Là ví dụ **production thực tế ở scale lớn, ngành regulated** — hiếm và giá trị hơn các bài "how-to" chung chung.
- Đóng góp pattern [[agent-service-architecture|Agent Service microservice riêng + LLM Proxy + DAG task decomposition]].
- Chứng minh mô hình **[[human-in-the-loop|human giữ quyết định cuối]]** vẫn tạo ROI: giảm 26% median review handling time, >96% helpfulness.
- Xây trên **[[anthropic|foundation model]] qua Amazon Bedrock**, dùng prompt caching giảm 60% chi phí ([[agent-cost-management]]).

## Hướng phát triển (theo bài)

Stripe đang khám phá fine-tuning riêng cho tác vụ compliance và continued pre-training để bơm kiến thức domain, đồng thời mở rộng từ pre-review questions sang investigation real-time nhiều bước.
