---
title: "Agent Observability: Hướng Dẫn Đầy Đủ Cho 2026"
type: article
created: 2026-07-01
updated: 2026-07-01
sources:
  - "https://www.braintrust.dev/articles/agent-observability-complete-guide-2026"
  - "[[raw/ai-agents-production/agent-observability-guide-braintrust]]"
tags: [ai-agents, production, observability, tracing, spans, evaluation, apm]
---

# Agent Observability: Hướng Dẫn Đầy Đủ Cho 2026

> **Nguồn gốc**: [Agent observability: The complete guide for 2026 — Braintrust](https://www.braintrust.dev/articles/agent-observability-complete-guide-2026)
> **Tác giả**: Braintrust Team | **Ngày đăng**: 21/06/2026 | **Thời gian đọc**: ~18 phút | ⭐ 5/5

> 📝 Bản tóm tắt ngắn: [[summaries/agent-observability-guide-braintrust]]

Trong production, agent thất bại theo cách mà monitoring truyền thống **không nhìn thấy**: nó chọn sai tool, truyền sai tham số, lấy nhầm entry trong bộ nhớ, hoặc lặng lẽ trôi khỏi kế hoạch ban đầu — trong khi mọi metric hạ tầng vẫn xanh. Bài viết này định nghĩa một schema trace tối thiểu cho agent, giải thích vì sao APM chuẩn không đủ, và chỉ ra cách khép vòng từ **trace → evaluation → CI gate**.

## Bốn loại span — schema trace tối thiểu

Observability cho agent không phải là "thêm log", mà là ghi lại **quan hệ nhân quả** của từng bước dưới dạng span có cấu trúc. Bài viết đề xuất bốn loại span, mỗi loại bắt một nhóm failure riêng:

1. **Tool-Call Spans** — ghi `tool name, arguments, raw output, duration, retry count, error state`. Đây là nơi lộ ra **hallucinated arguments** (agent bịa tham số) và **silent retry loop** (lặp lại âm thầm).
2. **Reasoning Spans** — ghi *"kế hoạch của model, hành động nó chọn, quan sát nó thu được, và điều nó quyết định làm tiếp"*. Bộc lộ **plan drift** và việc chọn sai nhánh.
3. **State Transition Spans** — ghi working memory trước và sau mỗi bước, gồm cả `context edits` và `handoff payloads`. Bắt **context loss** trong các run dài.
4. **Memory Operation Spans** — ghi read/write tới long-term store: `query, returned entries, relevance scores, freshness`. Bộc lộ **stale reads** (đọc dữ liệu cũ) và **memory leakage**.

Bốn loại này liên hệ trực tiếp với các concept sẵn có trong wiki: tool-call span là công cụ phát hiện [[silent-tool-call-failures|silent tool call failures]], còn state-transition span hỗ trợ [[context-window-management|quản lý context window]].

## Vì sao Application Performance Monitoring (APM) truyền thống thất bại

| Chiều | Traditional APM | Application Logging | Agent Observability |
|-------|-----------------|---------------------|---------------------|
| Ghi gì | Request rate, latency, error rate, span count | Event do dev định nghĩa | Tool calls, reasoning, state, memory ops |
| Tín hiệu failure | HTTP error / timeout | Chuỗi exception/warning | Sai tool, sai arguments, plan bị lệch |
| Silent failure | Agent lặp vẫn trông "healthy" | Event thiếu ngữ cảnh reasoning | Trace cho thấy loop, retry, nhánh sai |

Cốt lõi vấn đề, theo bài viết:

> "Một dashboard truyền thống có thể xác nhận rằng agent service đang chạy. Nó **không thể** xác nhận rằng agent đã chọn đúng tool, truyền đúng tham số, lấy đúng entry bộ nhớ, hay bám đúng kế hoạch ban đầu."

Nói cách khác: một response `200 OK` hoàn toàn có thể bọc một câu trả lời **sai một cách tự tin**. Đây chính là mở rộng thực hành cho luận điểm của [[agent-observability]]: *"uptime hoàn hảo vẫn không cho biết vì sao một task cụ thể cho kết quả sai"*.

## Multi-agent: handoff phải nhìn thấy được

Trong hệ multi-agent, thất bại thường nằm ở **đường bàn giao (handoff)** giữa các agent. Bài viết khuyến nghị xem *mỗi ranh giới agent như một ranh giới service* và log input/output/timing của mỗi handoff **giống như một RPC** giữa hai service:

- Ghi handoff payload thành một span trên trace của **parent agent**.
- **Nest** run của agent nhận dưới handoff span đó.
- Cho **cùng một trace ID** chảy xuyên qua cả hai agent.

Kết quả là *"một trace duy nhất cho thấy planning agent, handoff payload, các tool call của sub-agent, và câu trả lời cuối — trong cùng một khung nhìn"*. Không có quan hệ parent-child span, handoff failure sẽ **vô hình**.

## Code: gắn tracing vào framework

### LangGraph (Python)

```python
import braintrust
from braintrust_langchain import BraintrustCallbackHandler, set_global_handler
from langgraph.graph import StateGraph

braintrust.init_logger(project="My Project")

handler = BraintrustCallbackHandler()
set_global_handler(handler)

graph = StateGraph(AgentState)
graph.add_node("plan", plan_node)
graph.add_node("act", act_node)
graph.add_edge("plan", "act")

app = graph.compile()
result = app.invoke({"input": "Refund the duplicate charge from last week"})
```

Mỗi node của [[langgraph|LangGraph]] trở thành một **nested span** dưới parent agent run, liên kết các bước `plan` và `act` xuyên suốt lần thực thi.

### Mastra (TypeScript)

```typescript
initLogger({ projectName: "My Project" });

const assistant = new Agent({
  name: "assistant",
  instructions: "You are a helpful assistant.",
  model: wrapLanguageModel({
    model: openai("gpt-4o"),
    middleware: BraintrustMiddleware(),
  }),
  tools: { lookupTransactions, createRefund },
});

const wrappedAgent = wrapMastraAgent(assistant, { span_name: "assistant" });
const result = await wrappedAgent.generateVNext(
  "Refund the duplicate charge from last week",
);
```

Việc wrap tạo nested span cho agent run, cho **từng tool call**, và cho **từng LLM request** bên dưới — giữ cho *"mọi bước trong execution graph của agent luôn có thể soi được"*.

## Khép vòng: production trace → evaluation

Điểm mạnh nhất của cách tiếp cận này là biến observability thành **evaluation loop** thay vì chỉ để debug sự cố:

- **Online Evaluation** — inline scorer và LLM-as-a-judge chạy ngay trên **live trace**, nên quality regression lộ ra *khi nó đang xảy ra*.
- **Offline Evaluation** — chạy agent trên bộ **golden cases** đã curate trước khi deploy.
- **Feedback Loop** — trace nào **fail** online scoring sẽ được chuyển thành **eval case** mới. Bộ eval do đó lớn dần từ hành vi người dùng thật, và regression tương lai bị bắt tự động. Một **GitHub Action** *"chạy eval trên mỗi pull request, chặn merge nếu chất lượng tụt dưới ngưỡng cấu hình"*.

Đây chính là hiện thực hoá cụ thể của [[evaluation-pipeline|continuous evaluation như production infrastructure]].

## Metrics và tính năng theo dõi

- **Cost tracking**: chi phí ước tính per-span + rollup ở cấp trace (feed vào [[agent-cost-management|cost attribution]]).
- **Error classification**: typed error state, retry count, phân loại failure.
- **Timing**: start/end/duration mỗi span.
- **Behavioral signals**: độ chính xác chọn tool, plan drift, memory freshness.
- **Topics** (đặc thù Braintrust): phân loại mỗi trace theo intent/sentiment/issue *ngay khi nó landing*, để xu hướng chất lượng nổi lên trên toàn bộ traffic chứ không chỉ các run trip failure detector.

## So sánh landscape platform

| Platform | Điểm mạnh | Phù hợp nhất |
|----------|-----------|--------------|
| [[braintrust]] | Native integration 7+ framework, nested spans, online eval trên trace, CI/CD gate, self-hosting | Workflow trace-to-eval; failure production thành eval case |
| Galileo AI | Evaluator do vendor quản lý, runtime guardrails, phát hiện multi-agent (Enterprise) | Đội muốn guardrails sẵn |
| Arize Phoenix | Open-source, [[opentelemetry]]-first, self-host | Đội thích OSS + OTEL stack |
| Datadog LLM Observability | Tích hợp APM, SOC 2/HIPAA | Observability vận hành (agent-specific hạn chế) |

Braintrust free tier: *1 GB processed data* và *10k evaluation scores/tháng*.

## Lộ trình áp dụng (adoption path)

- **Day 1**: trace các LLM call và tool invocation.
- **Week 1**: thêm reasoning step, correlate user session, đo cost/trace.
- **Month 1**: score hành vi live trên sample trace, alert khi regression.
- **Quarter 1**: enforce chất lượng khi release qua **CI gate**.

## Kết luận

Observability cho agent không phải là dashboard uptime — nó là **execution trace có cấu trúc** cộng với một **vòng eval** khép kín. Bốn loại span (tool / reasoning / state / memory) là lớp nền; online scoring biến trace thành tín hiệu chất lượng; CI gate biến tín hiệu đó thành hàng rào chặn regression. Đây là phần "làm thế nào" bổ sung cho phần "tại sao" của [[agent-observability]].

## Liên kết wiki
- [[agent-observability]] — concept gốc (span-level trace, OpenTelemetry, cost attribution)
- [[evaluation-pipeline]] — continuous eval; bài này cho thấy trace nuôi eval ra sao
- [[silent-tool-call-failures]] — tool-call span là công cụ phát hiện
- [[context-window-management]] — state-transition span bắt context loss
- [[braintrust]] · [[opentelemetry]] · [[langgraph]]
