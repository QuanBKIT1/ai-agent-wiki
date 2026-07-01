---
title: "AI Agents trên Production: Framework, Protocol và Những Gì Thực Sự Hoạt Động Năm 2026"
type: article
created: 2026-07-01
updated: 2026-07-01
sources:
  - "https://47billion.com/blog/ai-agents-in-production-frameworks-protocols-and-what-actually-works-in-2026/"
tags: [ai-agents, production, frameworks, protocols, react-pattern, multi-agent]
---

# AI Agents trên Production: Framework, Protocol và Những Gì Thực Sự Hoạt Động Năm 2026

> **Nguồn gốc**: [47Billion Blog](https://47billion.com/blog/ai-agents-in-production-frameworks-protocols-and-what-actually-works-in-2026/)
> **Tác giả**: KamalPreet Singh (Tech Lead) & Samyak Jain (Associate Software Engineer)
> **Ngày đăng**: 24/02/2026 | Thời gian đọc: ~20 phút
> 📝 Bản tóm tắt ngắn: [[summaries/ai-agents-production-47billion]]

---

## Lời hứa thì đơn giản. Thực tế thì không.

Mọi bài thuyết trình tại các hội nghị năm 2025 đều có cùng một thông điệp: AI agent sẽ tự động hóa mọi thứ. Đưa cho LLM một vài công cụ, định nghĩa một mục tiêu, và xem nó tự làm. Các bản demo rất ấn tượng. Hệ thống multi-agent viết code, phân tích dữ liệu, tạo báo cáo — tất cả mà không cần con người can thiệp.

Chúng tôi đã tin vào lời hứa đó. Và có lý do chính đáng để tin. Tại **[7Seers](https://7seers.ai/)** — nền tảng giáo dục được hỗ trợ bởi AI của chúng tôi — chúng tôi đã chạy hàng chục tính năng LLM trên nhiều microservice. Tạo nội dung, tạo bài đánh giá, phỏng vấn giả lập. Việc thêm khả năng agent có vẻ là bước đi tự nhiên tiếp theo.

Vậy là chúng tôi đi sâu vào nghiên cứu. Ba framework. Nhiều dự án PoC. Một triển khai production cho một công ty bảo hiểm toàn cầu. Bốn tháng xây dựng, kiểm thử và học hỏi.

Điều chúng tôi khám phá ra vừa khiêm tốn vừa sáng tỏ: **bối cảnh AI agent năm 2025 đồng thời mạnh mẽ hơn và mong manh hơn so với những gì marketing ngụ ý.** Các framework là thật. Các pattern là vững chắc. Nhưng khoảng cách giữa một demo ấn tượng và một hệ thống production đáng tin cậy rộng hơn nhiều so với những gì người tham dự hội nghị sẵn sàng thừa nhận.

Đây là những gì chúng tôi đã học được.

## AI Agent thực sự là gì?

Thuật ngữ này được dùng khá lỏng lẻo, vì vậy chúng ta cần định nghĩa chính xác. Một **AI agent** là phần mềm có thể: nhận biết môi trường, lý luận để quyết định hành động, hành động để đạt mục tiêu, và học từ phản hồi. Sự khác biệt chính so với chatbot là **tính tự chủ**. Chatbot trả lời câu hỏi. Agent hoàn thành nhiệm vụ.

Phân loại học thuật có 5 loại, và hiểu chúng giúp ta hình dung được những gì LLM agent hiện đại đang làm:

| Loại | Cách hoạt động | Ví dụ |
|---|---|---|
| Simple Reflex | Luật if-then, không có bộ nhớ | Bộ điều nhiệt, bộ lọc spam |
| Model-Based | Duy trì trạng thái nội bộ, theo dõi context | Hệ thống điều hướng nhớ vị trí của bạn |
| Goal-Based | Lập kế hoạch để đạt mục tiêu | GPS tìm đường nhanh nhất |
| Utility-Based | Tối ưu kết quả tốt nhất trong các lựa chọn | Hệ thống gợi ý Netflix |
| Learning | Cải thiện hiệu suất theo thời gian | Alexa hiểu bạn tốt hơn theo thời gian |

Hầu hết LLM agent hiện đại là sự kết hợp của goal-based, utility-based và learning. Chúng lập kế hoạch, tối ưu, và cải thiện dần. Ít nhất, đó là kỳ vọng.

## Pattern ReAct: Cách Agent Hiện Đại Tư Duy

Trọng tâm của mọi framework agent chúng tôi đã kiểm thử là một pattern gọi là **ReAct** — viết tắt của Reasoning and Acting (Lý luận và Hành động). Đây là vòng lặp khiến agent trông có vẻ thông minh:

Agent nhận một task. Nó **suy nghĩ** về việc tiếp theo (reasoning). Nó **hành động** bằng cách gọi một tool, một API, hoặc thực hiện tìm kiếm. Nó **quan sát** kết quả. Rồi lại suy nghĩ tiếp. Vòng lặp này tiếp tục cho đến khi đạt mục tiêu hoặc agent quyết định không thể tiếp tục.

Ví dụ thực tế với agent phỏng vấn:

- **Thought**: "Người dùng muốn luyện phỏng vấn dev Python. Tôi cần câu hỏi theo vai trò."
- **Action**: Gọi tool tạo câu hỏi với role=Python Developer, level=Mid
- **Observation**: Nhận 5 câu hỏi về data structures, OOP, concurrency
- **Thought**: "Câu hỏi tốt. Trình bày câu đầu tiên và chờ phản hồi."
- **Action**: Hiển thị câu hỏi, ghi âm câu trả lời người dùng
- **Observation**: Người dùng nói về list comprehensions nhưng bỏ sót generator expressions
- **Thought**: "Đánh giá theo rubric. Chấm điểm và đưa phản hồi xây dựng."
- **Action**: Gọi tool đánh giá với câu trả lời và rubric
- **Observation**: Score 7/10. Phản hồi đã tạo. Chuyển sang câu tiếp theo.

Vòng lặp này phân biệt agent với hệ thống prompt-response đơn giản. Mọi framework chúng tôi đã test — AutoGen, CrewAI, LlamaIndex, OpenAI Agents SDK — đều cài đặt một biến thể của ReAct.

> *Chất lượng của agent phụ thuộc nhiều vào việc các thành phần được tích hợp tốt đến đâu, hơn là độ thông minh của LLM bên dưới. Một model trung bình với tooling xuất sắc sẽ vượt trội hơn một model thông minh với orchestration kém.*

## Phổ Autonomy: Từ Prompt Chain đến Multi-Agent

Một trong những nhận thức đầu tiên của chúng tôi là: "AI agent" không phải là một phân loại nhị phân. Có một phổ autonomy, và biết use case của bạn nằm ở đâu sẽ quyết định framework — và độ phức tạp — bạn thực sự cần.

### Level 1: Prompt Chaining

Luồng tuyến tính. Input đến LLM, output feed vào lần gọi LLM khác, cứ thế tiếp tục. Deterministic, dễ đoán, dễ debug. Chúng tôi dùng cách này để tạo câu hỏi phỏng vấn từ JD, rồi tạo rubric đánh giá từ câu hỏi đó. Nó hoạt động. Nhàm chán. Và nhàm chán là tốt trong production.

### Level 2: Workflows with Branching

Logic điều kiện dựa trên output LLM. Hệ thống ra quyết định, nhưng mọi nhánh đều được định nghĩa sẵn. Tạo nội dung với kiểm tra chất lượng nằm ở đây — nếu nội dung được tạo dưới ngưỡng chất lượng, nó loop lại để sửa.

### Level 3: Tool-Using Agents

LLM quyết định gọi tool nào. Đây là nơi pattern ReAct xuất hiện. Tự chủ hơn, nhưng vẫn là single agent. Một research agent quyết định search web, query database, hay hỏi câu hỏi làm rõ hoạt động ở level này.

### Level 4: Multi-Agent Systems

Nhiều agent chuyên biệt cộng tác. Một agent research, một agent viết, một agent review. Đây là level phức tạp nhất, mạnh mẽ nhất, và khó đoán nhất. Cũng là nơi chi phí bùng nổ và debug trở nên thực sự khó khăn.

**Khuyến nghị**: Với hầu hết use case production hiện nay, **Level 2-3 là điểm ngọt**. Level 4 hấp dẫn cho demo nhưng đau đớn cho production.

## Ba Framework, Ba Triết Lý

### AutoGen: Mạnh Mẽ Nhưng Đắt Đỏ

Mô hình tư duy của AutoGen là **các cuộc hội thoại**. Bạn định nghĩa agent với persona cụ thể, và chúng nói chuyện với nhau để hoàn thành task. Cảm giác tự nhiên khi nó hoạt động. Hỗn loạn khi không.

Chúng tôi build 2 dự án với AutoGen. Đầu tiên là hệ thống đặt bàn — single agent kiểm tra chỗ trống, xác nhận sở thích, đặt bàn. Mất khoảng 3 tuần. Thứ hai là FinRobot — hệ thống multi-agent tạo báo cáo tài chính thường niên.

**Điểm tốt**:
- Paradigm hội thoại trực quan cho task phức tạp
- Thêm agent vào workflow đã có dễ dàng
- Hỗ trợ tốt cho code execution agent
- Human-in-the-loop là first-class citizen

**Điểm không tốt**:
- Hội thoại đi vòng. Agent cứ nói mà không hội tụ giải pháp
- Token tiêu thụ cực cao. Task 1,000 token với workflow đơn giản lại tốn 5,000+ vì mỗi agent thấy toàn bộ lịch sử
- Debug multi-agent là cơn ác mộng
- Agent đôi khi gọi tool nhiều lần dù 1 lần là đủ

*AutoGen mạnh cho task khám phá. Cho deterministic workflow thì quá đáng và tốn kém.*

### CrewAI: Sự Cân Bằng Thực Tế

CrewAI nghĩ theo **task**, không phải hội thoại. Bạn định nghĩa agent với role và giao task cụ thể theo tuần tự hoặc phân cấp. Có cấu trúc hơn, dễ đoán hơn, phát triển nhanh hơn đáng kể.

Chúng tôi build lại đúng hệ thống đặt bàn với CrewAI. Phiên bản hoạt động trong 1 tuần — so với 3 tuần với AutoGen. Khác biệt rõ rệt.

**Điểm tốt**:
- Approach task-based cho cảm giác production-ready ngay
- Kiểm soát execution flow tốt hơn AutoGen
- Tích hợp tool có sẵn mượt và tài liệu tốt

**Điểm không tốt**:
- Kém linh hoạt hơn AutoGen cho scenario open-ended
- Memory giữa các task khó quản lý
- Customization sâu cần workaround

*CrewAI là điểm cân bằng tốt cho task multi-step có cấu trúc.*

### LlamaIndex Workflows: Chuyên Gia Tài Liệu

LlamaIndex theo cách tiếp cận khác. Xuất sắc cho ứng dụng document-heavy, RAG-centric. Chúng tôi dùng nó cho 2 dự án: hệ thống tóm tắt note và trợ lý bảo hiểm trích xuất dữ liệu có cấu trúc từ tài liệu phi cấu trúc.

**Điểm tốt**:
- Xuất sắc cho xử lý tài liệu và truy hồi thông tin
- Abstraction sạch cho định nghĩa workflow step
- Event-driven architecture giúp thêm logging, retry tự nhiên
- Tích hợp chặt với RAG infrastructure

**Điểm không tốt**:
- Tài liệu cho use case nâng cao thưa thớt
- Debug workflow phức tạp cần custom tooling
- Error handling cần work nhiều
- Không phải lựa chọn cho orchestration thuần túy

### Bảng So Sánh

| Tiêu chí | AutoGen | CrewAI | LlamaIndex |
|---|---|---|---|
| **Phù hợp nhất** | Cộng tác multi-agent khám phá | Task multi-step có cấu trúc | Workflow RAG nặng |
| **Độ khó học** | Dốc | Nhẹ nhàng | Trung bình |
| **Production-Ready** | Cần guardrail mạnh | Tốt cho workflow có cấu trúc | Tốt cho RAG |
| **Hiệu quả chi phí** | Kém (token cao) | Trung bình | Tốt |
| **Debug** | Khó (hỗn loạn multi-agent) | Tốt | Trung bình |

## Case Study: AI Sales Training cho Công Ty Bảo Hiểm Toàn Cầu

Bài học quan trọng nhất đến từ một triển khai production — mô phỏng huấn luyện bán hàng AI cho công ty bảo hiểm toàn cầu. Hai agent làm việc cùng nhau: một đóng vai khách hàng (chuyên gia tài chính với personality có thể cấu hình), một đóng vai coach real-time cho học viên.

Người dùng điều chỉnh personality type, mức độ khó, phong cách hội thoại. Hệ thống tạo kịch bản training động thích ứng theo từng session. Build 4 tháng từ đầu đến production-ready.

### 6 Bài Học Khó Khăn từ Production

**1. Agent Cần Ranh Giới Rõ Ràng Tàn Nhẫn**

Ở các prototype đầu, agent gọi cùng một tool nhiều lần dù 1 lần là đủ. Có lần agent cố gọi function trông hợp lý nhưng không tồn tại. Sửa bằng cách: giới hạn tool call tối đa, validate strict các tool có sẵn, error message rõ ràng khi chạm giới hạn.

**2. Hội Thoại Dài Phá Vỡ Mọi Thứ**

Session training kéo dài 30-45 phút. Đó là rất nhiều context. Agent cần theo dõi thông tin quan trọng mà không bị quá tải. Chúng tôi cài đặt smart summarization — giữ context quan trọng trong khi cắt bỏ trao đổi dư thừa.

**3. Input Không Mong Đợi Là Bình Thường**

Học viên sales nói những thứ không test suite nào lường trước. Agent cần xử lý gracefully câu hỏi lạc đề, phản ứng cảm xúc, lệch hướng hội thoại. Cần prompt engineering rộng và tinh chỉnh lặp.

**4. Cost Monitoring Là Không Thể Thương Lượng**

Hội thoại multi-agent đói token. Không có monitor từ ngày đầu, chi phí sẽ vượt dự kiến đáng kể. Chúng tôi set tracking real-time với alert ở 80% ngưỡng budget.

**5. Độ Biến Thiên Response Time Quan Trọng**

Đôi khi agent trả lời dưới 1 giây. Đôi khi 4 giây. Sự biến thiên gây khó chịu hơn là chậm đều. Chúng tôi thêm loading indicator, background processing, timeout limit.

**6. Tinh Chỉnh Không Bao Giờ Kết Thúc**

Chúng tôi dành nhiều thời gian điều chỉnh hành vi agent hơn build hệ thống ban đầu. Thay đổi nhỏ trong system prompt tạo ra pattern hội thoại khác biệt rõ rệt.

*Cho hệ thống production hướng khách hàng, mức độ kiểm soát của framework quan trọng hơn tốc độ phát triển. 4 tháng là thực tế cho hệ thống agent production-grade. Ai nói khác thì chưa từng ship.*

## Human in the Loop: Pattern Không Ai Muốn Nói Đến

Mọi demo framework cho thấy hoạt động tự chủ. Thực tế đòi hỏi checkpoint con người. Đây có lẽ là bài học quan trọng nhất: **HITL không phải hạn chế của hệ thống agent. Nó là yêu cầu để có hệ thống đáng tin cậy.**

### Tại sao HITL quan trọng

- **Xây dựng niềm tin**: Người dùng chưa tin agent hoàn toàn tự chủ. Và thực sự, họ không nên tin
- **Phục hồi lỗi**: Khi agent đi sai, con người bắt được trước khi cascading
- **Compliance và audit**: Trong ngành regulated (finance, healthcare, education), cần chứng minh con người duyệt quyết định quan trọng
- **Kiểm soát chất lượng**: Cho tạo nội dung, review của con người đảm bảo chất lượng

### 4 Pattern HITL

| Pattern | Khi nào dùng | Ví dụ |
|---|---|---|
| Approval Gates | Trước hành động không thể đảo ngược | Con người duyệt trước khi tạo báo cáo cuối |
| Review & Edit | Cho chất lượng nội dung | Trainer review kịch bản training do AI tạo |
| Escalation | Khi agent confidence thấp | Agent route đến con người khi không chắc |
| Feedback Loop | Cải thiện liên tục | Người dùng chấm điểm agent; hệ thống học |

### Hỗ trợ HITL trong framework

- **AutoGen**: `human_input_mode` built-in với ALWAYS, TERMINATE, NEVER
- **CrewAI**: tham số `human_input=True` trên task
- **LangGraph**: Human node tường minh trong workflow graph
- **OpenAI Agents SDK**: Handoff primitive route đến human agent

**Nguyên tắc là progressive autonomy**: bắt đầu với nhiều can thiệp con người, sau đó giảm dần khi hệ thống chứng minh được. Không phải ngược lại.

## Stack Protocol Mới Nổi: MCP, A2A, AG-UI

Ngoài framework, năm 2025 chứng kiến sự xuất hiện của các protocol chuẩn hóa định hình cách agent được xây dựng và kết nối.

### MCP: Model Context Protocol

Anthropic phát hành cuối 2024, MCP là chuẩn cho cách agent kết nối với tool. Hãy nghĩ nó như **USB cho AI tool** — cách chuẩn hóa để bất kỳ agent nào discover và sử dụng bất kỳ tool nào, không cần code tích hợp custom.

- **Server** expose tool, resource, prompt
- **Client** là AI application sử dụng các capability đó
- **Protocol** dùng JSON-RPC chuẩn
- Đã được hỗ trợ bởi Claude Desktop, Cursor, Zed và đang phát triển nhanh

**Tại sao quan trọng**: Nếu bạn build MCP server cho internal API, mọi MCP-compatible agent đều dùng được. Thay vì viết custom connector cho từng framework, bạn implement một lần.

### A2A: Agent-to-Agent Protocol

Google ra mắt 4/2025 và đóng góp cho Linux Foundation 6/2025. A2A giải quyết vấn đề khác: cách agent từ tổ chức khác nhau giao tiếp. Hơn 150 tổ chức hỗ trợ, gồm Salesforce, SAP, ServiceNow, Atlassian.

| Protocol | Mục đích | Phép so sánh |
|---|---|---|
| **MCP** | Agent ↔ Tool | Cách agent nói chuyện với API/DB |
| **A2A** | Agent ↔ Agent | Cách agent từ các tổ chức cộng tác |

A2A giới thiệu khái niệm **Agent Cards** — file JSON mô tả khả năng của agent, như card thông tin AI. Agent discover lẫn nhau, đàm phán phương thức tương tác, xác thực, ủy quyền task qua protocol có cấu trúc trên HTTP, SSE, JSON-RPC.

### AG-UI: Agent-User Interaction Protocol

CopilotKit ra mắt 5/2025. AG-UI giải quyết khoảng trống cuối: cách agent giao tiếp với UI.

- Protocol dựa trên event qua HTTP/WebSocket với ~17 event type chuẩn
- Hai chiều: UI gửi context đến agent, agent stream lại về UI
- Hỗ trợ built-in cho streaming, đồng bộ state, tool visualization, HITL approval
- Đã tích hợp với LangGraph, CrewAI, Mastra, Microsoft Agent Framework

### Chúng kết hợp thế nào

Ba protocol này bổ trợ nhau:
- **MCP** kết nối tool (DB, API, search)
- **A2A** cộng tác với agent ngoài (đối tác, service chuyên biệt)
- **AG-UI** giao tiếp với người dùng (feedback real-time, approval workflow)

Đội nào áp dụng chuẩn này sớm sẽ tốn ít thời gian cho custom integration và nhiều thời gian hơn cho sản phẩm thực sự.

## Hệ Sinh Thái Rộng Hơn

- **OpenAI Agents SDK** (3/2025): Cách tiếp cận tối giản với 4 primitive cốt lõi: Agents, Handoffs, Guardrails, Tracing. Provider-agnostic, hoạt động với 100+ LLM
- **LangGraph**: Workflow engine dạng graph của LangChain. Xuất sắc cho ứng dụng stateful có cycle
- **Parlant**: Framework open-source (Apache 2.0) tập trung vào agent hội thoại hướng khách hàng
- **Coding Agents (Claude Code, Cursor)**: Chứng minh nguyên tắc: **agent hoạt động tốt nhất khi phạm vi hẹp**
- **Low-Code Options (n8n, Zapier)**: Hữu ích cho team non-developer hoặc prototype nhanh

## Câu Hỏi Chi Phí

Đây luôn là câu hỏi đầu tiên từ lãnh đạo, và nó xứng đáng câu trả lời thẳng thắn.

### Khoảng chi phí mỗi task

| Approach | Cost / Task | Tokens / Task | Khi nào dùng |
|---|---|---|---|
| Simple Workflow | $0.10 – $0.50 | 1,000 – 3,000 | Task tuyến tính, deterministic |
| CrewAI Multi-Agent | $0.50 – $2.00 | 3,000 – 10,000 | Task multi-step có cấu trúc |
| AutoGen Multi-Agent | $2.00 – $5.00 | 5,000 – 25,000 | Task khám phá, cộng tác |
| LlamaIndex RAG | $0.20 – $1.00 | 1,000 – 5,000 | Query xử lý tài liệu |

## Production Reliability: Có Thực Sự Tin Được Không?

Câu trả lời trung thực, phân loại theo độ phức tạp:

| Loại hệ thống | Production Ready? | Cần gì |
|---|---|---|
| Simple Workflows | Có | Error handling, input validation, monitoring |
| Tool-Using Agents | Có, với guardrail | Output validation, cost limit, fallback |
| Multi-Agent (có cấu trúc) | Cẩn trọng có | Guardrail mạnh, HITL checkpoint, progressive rollout |
| Multi-Agent (open-ended) | Chưa | Vẫn quá khó đoán cho critical path |

### Reliability Playbook của Chúng Tôi

- **Output có cấu trúc với validation**: Không bao giờ tin raw LLM output cho thứ đến tay end user
- **Temperature thấp**: Cho task deterministic. Sáng tạo là kẻ thù của reliability
- **Ràng buộc tool use**: Strict whitelist để ngăn agent gọi function ảo
- **Progressive rollout**: Pilot internal → beta select customer → general availability
- **Tinh chỉnh lặp**: Bảo hiểm bắt đầu ở 85% accuracy và đạt 95% sau 2 tháng tuning liên tục

## Tích Hợp Với Kiến Trúc Hiện Có

Cho team chạy microservices (như chúng tôi với 33 FastAPI service trên AWS EKS), agent không phải để thay thế. Chúng là **tầng orchestration** ngồi trên service hiện có:

- Agent gọi API hiện có để làm việc thực sự. Chúng điều phối, không thay thế
- MCP cung cấp cách chuẩn expose microservice cho agent
- Agent xử lý lý luận và sequencing. Service xử lý execution
- Test suite, monitoring, deployment pipeline hiện có vẫn nguyên vẹn

Không cần viết lại gì. Chỉ cần thêm tầng orchestration gọi thông minh những gì đã build.

## Bảo Mật và Compliance

### Prompt Injection

Agent xử lý input user dễ bị prompt injection — input độc hại được thiết kế để ghi đè instruction. Giảm thiểu: input sanitization, system prompt hardening, output validation layer kiểm tra vi phạm policy.

### Data Exposure

Multi-agent system truyền context giữa agent. Dữ liệu nhạy cảm trong context một agent có thể rò sang agent khác. Giải pháp: phân loại dữ liệu rõ ràng, lọc context giữa agent, audit log mọi luồng dữ liệu.

### Cost Attacks

Người dùng độc hại có thể tạo input khiến agent vào loop tốn kém. Giải pháp: giới hạn chi phí per request, max iteration count, monitor budget real-time.

### Compliance

- **Audit trail**: Mọi quyết định agent, tool call, output phải log
- **Data residency**: Cho ngành regulated, có thể cần LLM self-hosted hoặc endpoint theo region
- **Role-based access**: Không phải ai cũng được sửa hành vi agent. Tool prompt management với RBAC là cần thiết
- **Reproducibility**: Hành vi agent phải có version. Khi có lỗi, cần tái tạo điều kiện

## 7 Bài Học từ Xây Dựng Hệ Thống Agent

1. **Bắt đầu đơn giản, chỉ thêm phức tạp khi cần**: Hầu hết use case không cần multi-agent. Simple workflow xử lý 80% yêu cầu thực tế

2. **Chi phí là cấp số nhân, không cộng**: Multi-agent không tốn gấp đôi single agent — tốn 5-10 lần, vì mỗi agent thấy toàn bộ hội thoại. Set monitor từ ngày đầu. Không phải tùy chọn

3. **Đánh giá là vấn đề khó nhất**: Cần đánh giá trajectory (quá trình reasoning có hợp lý không?), không chỉ output. Không có gì thay thế được test thực với người dùng thật

4. **Guardrails là infrastructure thiết yếu**: Output validation, action constraints, cost limit, human approval. Không phải nice-to-have

5. **Kiến trúc memory quan trọng hơn bạn nghĩ**: Smart summarization tạo ra khác biệt giữa hệ thống dùng được và hệ thống xuống cấp theo thời gian

6. **Giai đoạn tinh chỉnh là dự án thật**: Build agent ban đầu chiếm 20% effort. Đưa lên production chiếm 80%. Plan cho hàng tuần tinh chỉnh

7. **Narrow agent đánh bại general agent**: Hệ thống thành công nhất chúng tôi build (Claude Code, Cursor, training simulator) đều có domain hẹp

## Roadmap Áp Dụng

### Phase 1: Quick Wins (Tuần 1-3)

- Xác định 2-3 use case bạn đang làm multi-step LLM thủ công
- Pilot **CrewAI** cho task tạo nội dung có cấu trúc. Demo trong 1 tuần, production-ready trong 3 tuần
- Set up cost monitoring trước mọi thứ khác
- Bắt đầu document API có thể thành MCP server

### Phase 2: Production Hardening (Tuần 4-8)

- Thêm **LlamaIndex** cho xử lý tài liệu và RAG-heavy workflow
- Cài đặt HITL pattern cho mọi nội dung đến tay end user
- Build evaluation framework kết hợp check tự động + review con người
- Đánh giá **OpenAI Agents SDK** như lựa chọn đơn giản hơn cho dự án mới

### Phase 3: Khả Năng Nâng Cao (Tháng 3-6)

- Cân nhắc multi-agent cho use case thực sự phức tạp
- Áp dụng **MCP** cho tích hợp tool chuẩn hóa
- Đánh giá **A2A** cho scenario tích hợp đối tác
- Khám phá **AG-UI** cho giao tiếp frontend-agent chuẩn hóa

### Điều KHÔNG nên làm

- Đừng bắt đầu với multi-agent. Bắt đầu workflow đơn giản và nâng cấp dần
- Đừng bỏ qua cost monitoring. Bạn sẽ hối hận trong tháng đầu
- Đừng kỳ vọng chất lượng production từ demo. Plan 4-6 tháng cho hệ thống agent phức tạp
- Đừng viết custom integration khi đã có chuẩn. MCP, A2A, AG-UI tồn tại có lý do

## Tương Lai: Agent Năm 2026

- **Hội tụ protocol**: MCP, A2A, AG-UI sẽ thành infrastructure chuẩn
- **Chuyên biệt hơn tổng quát**: Agent thành công nhất sẽ tích hợp sâu vào workflow cụ thể
- **Tooling đánh giá**: Bottleneck lớn nhất hiện nay là testing. Sẽ có đầu tư lớn cho framework đánh giá agent
- **Tối ưu chi phí**: Model nhỏ hơn, chuyên biệt cho task agent cụ thể
- **Cộng tác người-agent**: Tương lai không phải agent hoàn toàn tự chủ. Là agent khiến con người hiệu quả hơn

---

**Nguồn**: [47Billion - AI Agents in Production: Frameworks, Protocols, and What Actually Works in 2026](https://47billion.com/blog/ai-agents-in-production-frameworks-protocols-and-what-actually-works-in-2026/)
