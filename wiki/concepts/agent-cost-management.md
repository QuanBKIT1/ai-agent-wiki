---
title: "Agent Cost Management"
type: concept
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
  - "[[raw/ai-agents-production/02_Lessons_Learned_Harness_Engineering_VN]]"
  - "[[raw/ai-agents-production/crewai-production-lessons]]"
tags: [ai-agents, cost, production, tokens, monitoring, cost-envelope, model-tiering]
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

## Cost envelope cần hard limit, không phải soft alert

Bài học từ [[harness-engineering|Harness Engineering]]: một agent kẹt trong retry loop — tool trả về response malformed, retry policy không có backoff, cost control chỉ là alert threshold chứ không phải hard limit — tiêu **$800 trong 40 phút** trước khi có người can thiệp.

Ba nguyên nhân, fix độc lập:

1. Retry policy thiếu exponential backoff và max retry count
2. Response malformed lẽ ra phải là non-retryable failure, không phải retryable (xem [[silent-tool-call-failures]])
3. Cost limit là Slack alert, không phải circuit breaker

> **Hard limit terminate execution — và fail gracefully thay vì crash — mới là standard production-grade.** Soft threshold sinh alert là cần nhưng không đủ.

```python
# Hard cost limit enforced at the orchestration layer.
# Soft limits trigger alerts; hard limits stop execution with graceful degradation.
class CostEnvelope:
    def __init__(self, soft_limit_usd: float, hard_limit_usd: float):
        self.soft_limit = soft_limit_usd
        self.hard_limit = hard_limit_usd
        self.spent = 0.0

    def record_spend(self, tokens: int, model: str) -> CostCheckResult:
        cost = calculate_cost(tokens, model)
        self.spent += cost

        if self.spent >= self.hard_limit:
            return CostCheckResult(
                status=CostStatus.HARD_LIMIT_REACHED,
                message=f"Task terminated: cost envelope exhausted (${self.spent:.2f})"
            )
        if self.spent >= self.soft_limit:
            return CostCheckResult(
                status=CostStatus.SOFT_LIMIT_REACHED,
                message=f"Cost alert: approaching limit (${self.spent:.2f} of ${self.hard_limit:.2f})"
            )
        return CostCheckResult(status=CostStatus.OK, remaining=self.hard_limit - self.spent)
```

Cost envelope **per-task, enforce tại orchestration layer**, ngăn chi phí runaway bất kể chuyện gì xảy ra ở dưới stack. Set soft limit ở **70-80%** hard limit để hệ thống có thời gian alert và task hoàn thành bình thường nếu sát budget. Cost attribution per step (từ [[agent-observability]]) cho biết phần nào của workflow đang đốt budget.

## Prompt caching: đòn giảm chi phí input token (production)

Bổ sung từ case study [[stripe-financial-compliance-agents|Stripe]]: trong vòng [[react-pattern|ReAct]] nhiều turn, phần lớn prompt (system prompt, lịch sử hội thoại) lặp lại giữa các turn. **Prompt caching** tái dùng prefix chung, chỉ tính tiền cho observation/thought **mới append** ở mỗi turn — Stripe giảm được **60% chi phí**. Kết hợp với **cost instrumentation per invocation** (track token mỗi lần gọi) để forecast chi tiêu và phát hiện điểm tối ưu trước khi vượt ngân sách. Đây là bổ sung mang tính "đòn bẩy chi phí" cho phần hard-limit ở trên: hard limit chặn runaway, prompt caching hạ chi phí baseline.

## max_iter và model tiering: số liệu từ CrewAI production

Bổ sung số liệu định lượng từ [[crewai-production-lessons|CrewAI in Production 2026]]:

- **`max_iter` mặc định là "cost leak" lớn nhất**: CrewAI để mặc định **25** iteration/agent — một run tồi có thể đốt **5–10× budget token**. Khuyến nghị hạ về **5–8**. Đây chính là hiện thân cụ thể của nguyên tắc "max iteration count" ở trên.
- **Số liệu thật**: pipeline 3-agent tốn ~**$0.30/run** (~29K token) → **$900/tháng** ở 100 run/ngày. Cho thấy chi phí *nhân theo số agent + số vòng*, không cộng tuyến tính.
- **Model tiering** (đòn giảm chi phí thứ ba, bên cạnh prompt caching và CostEnvelope hard-limit): dùng model rẻ cho task không quan trọng — gpt-4o-mini cho editing (rẻ ~10×), Claude Haiku cho extraction/formatting; `@lru_cache` cho tool result lặp. Giảm ~30% chi phí mà không mất chất lượng ở khâu chính.

> Ba đòn bẩy chi phí bổ trợ nhau: **hard limit** (CostEnvelope) chặn runaway · **prompt caching** ([[stripe-financial-compliance-agents|Stripe]]) hạ baseline input token · **model tiering** (CrewAI) hạ đơn giá theo độ khó task.

## Xem thêm
- [[crewai-production-lessons]] · 📖 [[articles/crewai-production-lessons]] — max_iter, cost table, model tiering
- [[autonomy-spectrum]] — mức autonomy càng cao chi phí càng lớn
- [[agent-service-architecture]] · [[stripe-financial-compliance-agents]] — LLM Proxy + prompt caching giảm 60% chi phí
- [[production-reliability]] — cost limit như một guardrail
- [[agent-frameworks-comparison]] — hiệu quả chi phí theo framework
- [[harness-engineering]] · [[harness-checklist]] — cost envelope là ưu tiên #2 trước go-live
- [[agent-observability]] — cost attribution per task/step
