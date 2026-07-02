---
title: "Backfill Digest — 2026-07-02"
type: digest
created: 2026-07-02
updated: 2026-07-02
tags: [digest, backfill, ai-agents, production, survey, adoption]
---

# Backfill Digest — 2026-07-02

> **Không phải digest crawl tuần** (xem [[digests/2026-07-02-digest|digest tuần 2026-07-02]] — kết quả "không có bài mới"). Đây là **backfill có chủ đích 1 bài** khảo sát giá trị cao, **đăng ngoài cửa sổ 7 ngày**, ingest theo yêu cầu người dùng.

## Bài backfill (1 bài)

### ⭐⭐⭐⭐ State of Agent Engineering 2026 (LangChain)
- **Tác giả**: LangChain
- **Ngày đăng**: 2026-06-12 (dữ liệu thu 18/11–2/12/2025) — ngoài cửa sổ 7 ngày
- **Thời gian đọc**: ~12 phút
- **Nguồn**: https://www.langchain.com/state-of-agent-engineering
- **Wiki**: 📖 [[articles/state-of-agent-engineering-langchain]] · tóm tắt [[summaries/state-of-agent-engineering-langchain]] · entity mới [[entities/langchain]]

**Tóm tắt 5 điểm chính (n=1.340):**
1. **Adoption**: 57,3% đã có agent in production (tăng từ 51%); enterprise 10k+ đạt 67%.
2. **Rào cản**: Quality 32% (blocker #1) > Latency 20%; Cost tụt hạng; Security 24,9% ở tổ chức lớn.
3. **Observability = bắt buộc**: 89% đã triển khai; production agent 94%, full tracing 71,5%, step-level 62%.
4. **Evaluation** (chín chậm hơn): offline 52,4%, online 37,3%; human review 59,8%, LLM-judge 53,3%.
5. **Model strategy**: OpenAI 67%+ nhưng 75%+ multi-vendor; self-host OSS 33%; chỉ 43% fine-tune.

## Bài bổ sung/mở rộng ý cũ (cross-link 2 chiều)

- [[concepts/agent-observability]] — thêm mục "đã thành thực hành chuẩn" (89%/94%/71,5%).
- [[concepts/evaluation-pipeline]] — thêm mục "số liệu ngành" (offline/online eval).
- [[concepts/agent-frameworks-comparison]] — thêm mục "multi-model là chuẩn" (75%+ multi-vendor).
- [[entities/langgraph]] — backlink tới [[entities/langchain]] (entity mới).

## Ý nghĩa

Đây là **nguồn số liệu định lượng đầu tiên** trong wiki — dùng để *kiểm chứng* những gì các case-study (Stripe, Harness, Braintrust) khẳng định định tính: observability đã là hạ tầng bắt buộc, quality/reliability (không phải model) là rào cản chính, multi-model là mặc định. Eval trưởng thành chậm hơn observability là khoảng trống đáng theo dõi.

## Ghi chú

- Backfill sau digest tuần "không có bài mới" của cùng ngày; ledger +1 (tổng 7).
