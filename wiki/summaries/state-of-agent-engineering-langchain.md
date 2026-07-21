---
title: "State of Agent Engineering 2026 (LangChain)"
type: summary
created: 2026-07-02
updated: 2026-07-02
sources:
  - "[[raw/ai-agents-production/state-of-agent-engineering-langchain]]"
  - "https://www.langchain.com/state-of-agent-engineering"
tags: [ai-agents, production, survey, adoption, observability, evaluation, multi-model]
---

# State of Agent Engineering 2026 (LangChain)

> 📖 Bản đầy đủ: [[articles/state-of-agent-engineering-langchain]]

Báo cáo khảo sát của [[langchain|LangChain]] (đăng 12/06/2026, dữ liệu thu 11–12/2025) trên **1.340** người hành nghề — nguồn **số liệu adoption production** đầu tiên trong wiki, dùng để định lượng những nguyên tắc mà các bài case-study khẳng định. (Bài **backfill**: giá trị cao nhưng ngoài cửa sổ 7 ngày.)

## Key takeaways (số liệu)

- **Adoption**: **57,3%** đã có agent in production (tăng từ 51% năm trước), **30,4%** đang phát triển + có kế hoạch deploy. Enterprise 10k+ đạt **67%** vs **50%** ở công ty <100 người.

- **Use cases**: customer service **26,5%**, research & data analysis **24,4%**, internal workflow automation **18%**. Ở tổ chức lớn, internal productivity dẫn đầu (26,8%).

- **Rào cản production**: **Quality 32%** (accuracy/consistency/tone/policy) là blocker #1 — vượt **Latency 20%**; **Cost** ít được nhắc hơn trước. Ở tổ chức 2k+, **Security** là concern #2 (24,9%). Củng cố luận điểm của [[production-reliability]] và [[harness-engineering]]: rào cản là *reliability*, không phải model.

- **Observability = bắt buộc**: **89%** đã triển khai; với production agent lên **94%**, **71,5%** có full tracing, **62%** giữ step-level + tool-call trace. Số liệu định lượng cho [[agent-observability]].

- **Evaluation** (trưởng thành chậm hơn observability): offline **52,4%**, online **37,3%** (44,8% ở nhóm production); human review **59,8%**, LLM-as-judge **53,3%**. Khớp mô hình offline+online của [[evaluation-pipeline]].

- **Model strategy**: OpenAI GPT **67%+**, nhưng **75%+ multi-vendor**; self-hosted OSS **33%**; chỉ **43%** fine-tune (đa số dùng base model + prompt + RAG). Bổ sung cho [[agent-frameworks-comparison]].

- **Agent dùng nhiều nhất**: coding assistants (Claude Code, Cursor, GitHub Copilot, Amazon Q, Windsurf, Antigravity) dẫn đầu; research agents (ChatGPT, Claude, Gemini, Perplexity) thứ nhì.

**Kết luận**: ngành đã qua giai đoạn "có nên deploy" sang lo *operational maturity* — quality + latency chi phối, observability là hạ tầng bắt buộc.

> Đối chiếu chéo: [[anthropic-2026-state-of-ai-agents|khảo sát Anthropic 2026]] (500+ US leaders) hội tụ cùng bức tranh (57% multi-stage, coding dẫn đầu, HITL là chuẩn) nhưng nhấn ROI (80%) + coding-agent leadership (42%).
