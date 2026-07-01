---
title: "Agent Cost Management"
type: concept
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [ai-agents, cost, production, tokens, monitoring]
---

# Agent Cost Management

Câu hỏi chi phí luôn là câu hỏi đầu tiên từ lãnh đạo. Bài học cốt lõi từ production:

> **Chi phí là cấp số nhân, không phải cộng.** Multi-agent không tốn gấp đôi single agent — tốn **5-10 lần**, vì mỗi agent thấy toàn bộ hội thoại.

## Khoảng chi phí mỗi task

| Approach | Cost / Task | Tokens / Task | Khi nào dùng |
|---|---|---|---|
| Simple Workflow | $0.10 – $0.50 | 1,000 – 3,000 | Task tuyến tính, deterministic |
| [[crewai]] Multi-Agent | $0.50 – $2.00 | 3,000 – 10,000 | Task multi-step có cấu trúc |
| [[autogen]] Multi-Agent | $2.00 – $5.00 | 5,000 – 25,000 | Task khám phá, cộng tác |
| [[llamaindex]] RAG | $0.20 – $1.00 | 1,000 – 5,000 | Query xử lý tài liệu |

Chênh lệch cho thấy rõ vì sao [[autonomy-spectrum|Level 4 multi-agent]] "đau đớn cho production": AutoGen có thể tốn tới 10-25x một simple workflow cho cùng một loại nhiệm vụ.

## Vì sao token bùng nổ trong multi-agent

Trong paradigm hội thoại của [[autogen|AutoGen]], **mỗi agent thấy toàn bộ lịch sử hội thoại** ở mỗi lượt. Một task lẽ ra chỉ 1,000 token có thể tốn 5,000+ khi chạy qua workflow multi-agent đơn giản.

## Nguyên tắc kiểm soát chi phí

- **Cost monitoring từ ngày đầu** — không phải tùy chọn. Set tracking real-time với alert ở 80% ngưỡng budget.
- **Giới hạn chi phí per request** và **max iteration count** để ngăn agent vào loop tốn kém.
- **Chống cost attack**: người dùng độc hại có thể tạo input khiến agent lặp vô hạn — cần budget monitor real-time (xem [[production-reliability|bảo mật]]).
- **Tối ưu 2026**: xu hướng dùng model nhỏ hơn, chuyên biệt cho từng task agent cụ thể để giảm chi phí.

Trong roadmap áp dụng ([[agent-deployment-roadmap]]), cost monitoring được đặt **trước mọi thứ khác** ở Phase 1.

## Xem thêm
- [[autonomy-spectrum]] — mức autonomy càng cao chi phí càng lớn
- [[production-reliability]] — cost limit như một guardrail
- [[agent-frameworks-comparison]] — hiệu quả chi phí theo framework
