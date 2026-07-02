---
title: "Evaluation Pipeline"
type: concept
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/02_Lessons_Learned_Harness_Engineering_VN]]"
  - "[[raw/ai-agents-production/state-of-agent-engineering-langchain]]"
tags: [ai-agents, production, harness, evaluation, monitoring, quality]
---

# Evaluation Pipeline

**Evaluation pipeline là production infrastructure, không phải bước QA.** Hầu hết team coi agent evaluation như thứ xảy ra trước deploy: chạy eval suite, check score chấp nhận được, ship. Model này **hỏng trong vài tuần** sau khi live, vì dữ liệu production bộc lộ failure mode mà eval set trước deploy không cover.

## Continuous, không phải periodic

Evaluation pipeline cho production agent cần chạy **liên tục**. Mọi agent task hoàn thành — thành công hay không — là một data point để hiểu hành vi hệ thống.

```mermaid
flowchart LR
    P[Production tasks] --> SA[Sample đại diện<br/>PII stripped]
    SA --> EV[Model-graded evaluator<br/>rubric ổn định]
    EV --> AG[Metric aggregate<br/>theo thời gian]
    AG --> AL{Degradation?}
    AL -->|có| AR[Alert]
    AL -->|pattern failure| FB[Feedback loop]
    FB --> BK[Engineering backlog<br/>prompt + harness iteration]
    BK --> P
```

Một subset task hoàn thành tự động route đến **model-graded evaluator** check chất lượng theo rubric. Pattern failure trong evaluator feed back vào prompt và harness iteration.

## Yêu cầu hạ tầng

Không phải investment nhỏ. Production evaluation pipeline cần:

- **Sample đại diện** của task production thực (PII đã strip khi cần)
- **Model-graded evaluator** với rubric ổn định, well-defined
- **Metric aggregate theo thời gian** — không chỉ snapshot point-in-time
- **Alert khi metric degradation** — bắt quality regression trước khi compound
- **Feedback loop** từ kết quả evaluation đến backlog engineering

> Team vận hành agent đáng tin cậy ở scale đều có infrastructure này. Team chật vật qua vài tháng đầu production hầu như không có.

## Liên hệ

- Feedback loop dựa trên [[agent-observability|execution trace]] và cost attribution để biết task nào đáng sample.
- Cộng hưởng với bài học "tinh chỉnh không bao giờ kết thúc" của [[production-reliability]]: dự án bảo hiểm đi từ 85% → 95% accuracy qua 2 tháng tuning liên tục — chỉ khả thi khi có continuous evaluation.
- Là ưu tiên cuối trong [[harness-checklist]] (build trong 60 ngày đầu production).

## Số liệu ngành (2026)

Khảo sát [[state-of-agent-engineering-langchain|State of Agent Engineering]] (LangChain, n=1.340) định lượng độ chín của thực hành eval: **offline 52,4%**, **online 37,3%** (44,8% ở nhóm production), ~25% dùng cả hai. Phương pháp phổ biến: **human review 59,8%**, **LLM-as-judge 53,3%**; ROUGE/BLEU ít dùng. Đáng chú ý: eval **trưởng thành chậm hơn observability** (89% đã có observability) — nhiều team *nhìn thấy* hành vi agent nhưng chưa *chấm điểm* nó một cách hệ thống.

## Xem thêm
- [[state-of-agent-engineering-langchain]] · 📖 [[articles/state-of-agent-engineering-langchain]] — số liệu offline/online eval toàn ngành
- [[harness-engineering]] · [[agent-observability]] · [[harness-checklist]]
- [[production-reliability]] — tinh chỉnh lặp không bao giờ kết thúc
