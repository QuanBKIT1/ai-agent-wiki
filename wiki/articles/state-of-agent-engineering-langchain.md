---
title: "State of Agent Engineering 2026 — Báo Cáo Khảo Sát LangChain"
type: article
created: 2026-07-02
updated: 2026-07-02
sources:
  - "https://www.langchain.com/state-of-agent-engineering"
  - "[[raw/ai-agents-production/state-of-agent-engineering-langchain]]"
tags: [ai-agents, production, survey, adoption, observability, evaluation, multi-model]
---

# State of Agent Engineering 2026 — Báo Cáo Khảo Sát LangChain

> **Nguồn gốc**: [State of Agent Engineering — LangChain](https://www.langchain.com/state-of-agent-engineering)
> **Tác giả**: LangChain | **Ngày đăng**: 12/06/2026 | **Thời gian đọc**: ~12 phút | ⭐ 4/5

> 📝 Bản tóm tắt ngắn: [[summaries/state-of-agent-engineering-langchain]]

Đây là báo cáo khảo sát ngành của [[langchain|LangChain]], dựa trên **1.340 phản hồi** thu thập từ 18/11 đến 2/12/2025. Khác với các bài case-study khác trong wiki (kể một câu chuyện triển khai cụ thể), báo cáo này cung cấp **số liệu định lượng trên diện rộng** — giúp kiểm chứng những nguyên tắc mà các case-study khẳng định (observability quan trọng, quality là rào cản chính, multi-model là chuẩn).

## Phương pháp khảo sát

- **Quy mô**: 1.340 phản hồi (18/11 – 2/12/2025).
- **Ngành**: Technology 63%, Financial Services 10%, Healthcare 6%, Education 4%, Consumer Goods 3%, Manufacturing 3%.
- **Quy mô công ty**: <100 người (49%), 100–500 (18%), 500–2.000 (15%), 2.000–10.000 (9%), 10.000+ (9%).

## Mức độ áp dụng production

- **57,3%** đã có agent chạy trong production; **30,4%** đang phát triển tích cực và có kế hoạch deploy.
- Tăng so với **51%** tỷ lệ production năm trước.
- **Doanh nghiệp lớn (10k+ nhân viên): 67%** đã production, so với **50%** ở công ty <100 người.
- Công ty nhỏ bù lại bằng tốc độ phát triển: **36%** tổ chức <100 người đang phát triển tích cực (so với 24% ở doanh nghiệp lớn).

## Các use case dẫn đầu

1. **Customer service — 26,5%** (phổ biến nhất)
2. **Research & data analysis — 24,4%**
3. **Internal workflow automation — 18%**

Ở tổ chức 10k+ nhân viên, thứ tự đổi: **internal productivity 26,8%**, customer service 24,7%, research/data analysis 22,2%.

## Rào cản đưa vào production

| Rào cản | Tỷ lệ | Ghi chú |
|---------|-------|---------|
| **Quality** | **32%** | accuracy, consistency, tone, tuân thủ policy — blocker #1 |
| **Latency** | **20%** | độ trễ phản hồi |
| **Cost** | (giảm) | ít được nhắc hơn các năm trước |
| **Security** (tổ chức 2k+) | **24,9%** | nổi lên là concern #2 ở doanh nghiệp lớn |

Điểm này củng cố mạnh luận điểm xuyên suốt wiki: rào cản production là **reliability**, không phải năng lực model — đồng điệu với [[harness-engineering]] ("failure ở tầng harness") và [[production-reliability]]. Việc *cost* tụt hạng cho thấy ngành đã học cách kiểm soát chi phí (xem [[agent-cost-management]]).

## Observability — đã thành hạ tầng bắt buộc

- **89%** tổ chức đã triển khai observability.
- Với **production agent**: **94%** có observability, **71,5%** có full tracing.
- **62%** duy trì detailed tracing cho từng agent step và tool call.

Đây là số liệu định lượng trực tiếp cho [[agent-observability]]: điều mà bài Braintrust mô tả ở mức kỹ thuật (span-level tracing) thì báo cáo này cho thấy đã là **thực hành chuẩn của đa số** khi lên production.

## Evaluation & testing — trưởng thành chậm hơn observability

- **Offline evaluation**: 52,4% tổ chức.
- **Online evaluation**: 37,3% (lên **44,8%** trong nhóm đã production).
- Gần **25%** nhóm dùng eval áp dụng **cả offline lẫn online**.
- Phương pháp: **human review 59,8%**, **LLM-as-judge 53,3%**; các metric ML truyền thống (ROUGE/BLEU) ít được dùng.

Mô hình offline + online này chính là cấu trúc mà [[evaluation-pipeline]] mô tả. Việc eval "trưởng thành chậm hơn tooling visibility" là một khoảng trống đáng chú ý: nhiều team *nhìn thấy* agent làm gì (observability) nhưng chưa *chấm điểm* hành vi đó một cách hệ thống.

## Chiến lược model & hạ tầng

- **OpenAI GPT**: 67%+ sử dụng.
- **Multi-vendor**: **75%+** deploy nhiều model (production hoặc dev) — không đặt cược vào một nhà cung cấp.
- **Open-source self-hosted**: 33%.
- **Fine-tuning**: chỉ **43%**; đa số dựa vào base model + prompt engineering + RAG.

Góc nhìn multi-model này bổ sung cho [[agent-frameworks-comparison]] và củng cố xu hướng "model nhỏ, chuyên biệt theo task" đã nêu ở [[agent-cost-management]].

## Agent được dùng nhiều nhất trong công việc hằng ngày

- **Coding assistants** dẫn đầu: Claude Code, Cursor, GitHub Copilot, Amazon Q, Windsurf, Antigravity.
- **Research agents** thứ nhì: ChatGPT, Claude, Gemini, Perplexity.
- **Custom agents** (build trên LangChain/LangGraph): QA testing, knowledge-base search, SQL-to-text, demand planning, customer support.

## Kết luận

Ngành đã bước qua câu hỏi "**có nên** deploy agent" để đến các mối lo về **operational maturity**. Quality consistency và latency giờ chi phối thảo luận thay cho cost. Observability đã trở thành hạ tầng bắt buộc cho production agent, trong khi thực hành evaluation vẫn trưởng thành chậm hơn so với tooling quan sát.

## Liên kết wiki
- [[langchain]] — publisher báo cáo; [[langgraph]] — sản phẩm liên quan
- [[agent-observability]] — báo cáo cho số liệu 89%/94%/71,5%
- [[evaluation-pipeline]] — offline 52,4% + online 37,3%, human review vs LLM-judge
- [[production-reliability]] · [[harness-engineering]] — quality/reliability là rào cản #1
- [[agent-frameworks-comparison]] — multi-model 75%+, OpenAI 67%
