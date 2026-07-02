---
title: "Agent Frameworks Comparison"
type: concept
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [ai-agents, frameworks, autogen, crewai, llamaindex, comparison]
---

# Agent Frameworks Comparison

So sánh ba framework agent chính dựa trên trải nghiệm production thực tế: [[autogen|AutoGen]], [[crewai|CrewAI]], và [[llamaindex|LlamaIndex]]. Mỗi framework mang một triết lý (paradigm) khác nhau.

## AutoGen: mạnh mẽ nhưng đắt đỏ

Mô hình tư duy của [[autogen|AutoGen]] là **các cuộc hội thoại (conversations)**. Bạn định nghĩa agent với persona cụ thể, và chúng nói chuyện với nhau để hoàn thành task.

**Điểm tốt**: paradigm hội thoại trực quan cho task phức tạp; thêm agent vào workflow đã có dễ dàng; hỗ trợ tốt code execution agent; Human-in-the-Loop là first-class citizen.

**Điểm không tốt**: hội thoại đi vòng, agent nói mà không hội tụ; token tiêu thụ cực cao (task 1,000 token có thể tốn 5,000+ vì mỗi agent thấy toàn bộ lịch sử); debug multi-agent là cơn ác mộng; agent đôi khi gọi tool nhiều lần dù 1 lần là đủ.

> AutoGen mạnh cho task khám phá. Cho deterministic workflow thì quá đáng và tốn kém.

## CrewAI: sự cân bằng thực tế

[[crewai|CrewAI]] nghĩ theo **task**, không phải hội thoại. Bạn định nghĩa agent với role và giao task cụ thể theo tuần tự hoặc phân cấp.

Dẫn chứng thực tế: build lại đúng hệ thống đặt bàn với CrewAI mất **1 tuần** — so với **3 tuần** với AutoGen.

**Điểm tốt**: approach task-based cho cảm giác production-ready ngay; kiểm soát execution flow tốt hơn AutoGen; tích hợp tool có sẵn mượt, tài liệu tốt.

**Điểm không tốt**: kém linh hoạt hơn AutoGen cho scenario open-ended; memory giữa các task khó quản lý; customization sâu cần workaround.

## LlamaIndex Workflows: chuyên gia tài liệu

[[llamaindex|LlamaIndex]] xuất sắc cho ứng dụng document-heavy, RAG-centric.

**Điểm tốt**: xuất sắc cho xử lý tài liệu và information retrieval; abstraction sạch cho workflow step; event-driven architecture giúp thêm logging/retry tự nhiên; tích hợp chặt với RAG infrastructure.

**Điểm không tốt**: tài liệu cho use case nâng cao thưa thớt; debug workflow phức tạp cần custom tooling; error handling cần work nhiều; không phải lựa chọn cho orchestration thuần túy.

## Bảng so sánh

| Tiêu chí | AutoGen | CrewAI | LlamaIndex |
|---|---|---|---|
| **Phù hợp nhất** | Cộng tác multi-agent khám phá | Task multi-step có cấu trúc | Workflow RAG nặng |
| **Độ khó học** | Dốc | Nhẹ nhàng | Trung bình |
| **Production-Ready** | Cần guardrail mạnh | Tốt cho workflow có cấu trúc | Tốt cho RAG |
| **Hiệu quả chi phí** | Kém (token cao) | Trung bình | Tốt |
| **Debug** | Khó (hỗn loạn multi-agent) | Tốt | Trung bình |

## Hệ sinh thái rộng hơn

- [[openai-agents-sdk|OpenAI Agents SDK]] — tối giản, 4 primitive, provider-agnostic
- [[langgraph|LangGraph]] — workflow engine dạng graph, xuất sắc cho ứng dụng stateful có cycle
- **Parlant** — framework open-source (Apache 2.0) cho agent hội thoại hướng khách hàng
- **Coding Agents (Claude Code, Cursor)** — chứng minh: agent hoạt động tốt nhất khi phạm vi hẹp
- **Low-Code (n8n, Zapier)** — cho team non-developer hoặc prototype nhanh

Mọi framework này đều triển khai một biến thể của [[react-pattern|ReAct]]. Chọn framework theo vị trí use case trên [[autonomy-spectrum]] và mô hình chi phí (xem [[agent-cost-management]]).

## Bối cảnh ngành: multi-model là chuẩn

Theo [[state-of-agent-engineering-langchain|khảo sát LangChain 2026]] (n=1.340): dù **OpenAI GPT** chiếm **67%+**, có tới **75%+** tổ chức deploy **nhiều model** (multi-vendor) thay vì đặt cược một nhà cung cấp; **33%** self-host model open-source; chỉ **43%** fine-tune (đa số dùng base model + prompt + RAG). Hàm ý: lựa chọn framework nên tính đến khả năng **provider-agnostic / model routing**, không khóa cứng vào một model.

## Xem thêm
- [[state-of-agent-engineering-langchain]] — số liệu multi-model & fine-tuning toàn ngành
- [[human-in-the-loop]] — cách mỗi framework hỗ trợ HITL
- [[agent-deployment-roadmap]] — thứ tự áp dụng framework
