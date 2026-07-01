---
title: "Bài Học Từ Việc Triển Khai AI Agent Trên Production"
type: article
created: 2026-07-01
updated: 2026-07-01
sources:
  - "https://harness-engineering.ai/blog/lessons-learned-from-deploying-ai-agents-in-production/"
tags: [ai-agents, production, harness, observability, cost, evaluation, reliability]
---

# Bài Học Từ Việc Triển Khai AI Agent Trên Production

> **Nguồn gốc**: [Harness Engineering Blog](https://harness-engineering.ai/blog/lessons-learned-from-deploying-ai-agents-in-production/)
> **Tác giả**: Dr. Sarah Chen
> **Ngày đăng**: 10/03/2026 (cập nhật 02/04/2026) | Thời gian đọc: ~12 phút
> 📝 Bản tóm tắt ngắn: [[summaries/lessons-learned-harness-engineering]]

---

Lần đầu tiên bạn deploy AI agent lên production, nó sẽ thất bại theo cách bạn không lường trước được. Không phải vì model sinh ra output tệ. Không phải vì prompt của bạn sai. Nó sẽ thất bại vì **hạ tầng bao quanh model — harness — không được thiết kế để xử lý các edge case chỉ xuất hiện khi có tải thực, người dùng thực, task thực.**

Tôi đã chứng kiến pattern này lặp lại trên hàng chục triển khai. Team ship một agent chạy hoàn hảo ở staging. Nó pass mọi test được thiết kế. Rồi lên production và bắt đầu fail 18% task theo cách không thấy trong log, đắt đỏ để debug, và bẽ bàng khi giải trình với stakeholder. Bản năng là tinh chỉnh prompt. Vấn đề hầu như không bao giờ là prompt.

Bài viết này ghi lại những bài học đắt giá nhất từ việc deploy AI agent lên production — các failure mode xuất hiện sau khi launch, các pattern khắc phục, và các quyết định infrastructure đáng lẽ phải có sớm hơn. Nếu bạn đang chuẩn bị deploy production, hãy coi đây như **incident retrospective từ team đã đi trước.**

---

## Hầu hết thất bại xảy ra ở tầng harness, không phải tầng model

Đây là bài học khó nhất để team thấm, vì model là phần dễ thấy nhất. Khi agent fail, câu hỏi tự nhiên là "model đã làm sai gì?". Câu trả lời trung thực, trong hầu hết trường hợp, là: **không gì cả.**

Harness — logic orchestration, code tích hợp tool, quản lý context, error handling, và verification step bao quanh model — là nơi production reliability được quyết định. Một retry policy thiếu, một tool call fail im lặng, một context window tràn ở bước thứ 15 của task 20 bước: không cái nào là model failure. Đây là **harness failure**.

Một pattern tôi thấy lặp lại: team deploy agent, quan sát failure rate 15-20%, dành 2 tháng tinh chỉnh prompt, giảm xuống 11%, và tuyên bố tiến bộ. Trong khi đó, root cause thật là tool call error bị nuốt im lặng — agent gọi external API, nhận 500 response, không có signal lỗi rõ ràng, và tiếp tục với dữ liệu thiếu như thể call thành công. Một verification step có cấu trúc sau mỗi tool call sẽ phát hiện ngay và retry hoặc escalate gracefully.

Hàm ý kiến trúc rất lớn: **Tầng harness là bề mặt engineering nơi reliability work xảy ra.** Tối ưu prompt có lợi ích giảm dần sau một mức — thường khoảng 85-90% task completion rate cho task phức tạp. Từ 90% lên 97% cần engineering, không phải prompting. Điều đó nghĩa là: verification loop, structured error handling, fallback path, và observability.

---

## Tool call thất bại im lặng là kẻ giết reliability bạn không thấy trước

Trong mọi failure mode tôi gặp khi deploy AI agent production, **silent tool call failure** là phổ biến nhất và đắt nhất. Đắt không chỉ vì tác động trực tiếp đến completion rate, mà còn vì thời gian debug nó tiêu tốn — vì nó không để lại signal rõ ràng trong execution trace.

Pattern: agent gọi tool đến external API. API trả về error — timeout, 429 rate limit, response malformed, schema thay đổi phá format. Code tích hợp tool catch exception nhưng trả về kết quả rỗng thay vì signal failure tường minh. Agent diễn giải rỗng là "không có kết quả" chứ không phải "thất bại", và tiếp tục thực thi. Phần còn lại của task chạy trên tiền đề sai.

Cách fix là verification loop sau mỗi tool call:

```python
# Verify tool call output before passing it forward to the next agent step.
# Without this, API failures propagate silently through multi-step chains.
def verify_tool_output(
    result: ToolResult,
    expected_schema: dict,
    required_fields: list[str]
) -> VerificationResult:
    if result.status_code not in (200, 201):
        return VerificationResult(
            passed=False,
            reason=f"HTTP {result.status_code}: {result.error_message}",
            should_retry=result.status_code in (429, 500, 502, 503)
        )
    if not result.data:
        return VerificationResult(
            passed=False,
            reason="Empty response body",
            should_retry=True
        )
    missing = [f for f in required_fields if f not in result.data]
    if missing:
        return VerificationResult(
            passed=False,
            reason=f"Missing required fields: {missing}",
            should_retry=False  # Schema mismatch won't resolve on retry
        )
    return VerificationResult(passed=True, data=result.data)
```

Pattern này — verify, phân loại failure type, quyết định retry hay escalate — thêm 30-50ms mỗi tool call ở một deployment và đưa completion rate từ 81% lên 94%. Model không đổi. Prompt không đổi. Verification loop bộc lộ failure trước đó vô hình và cho orchestration layer đủ thông tin để phản ứng đúng.

> **Production note**: Phân biệt failure retryable (rate limit, transient 500) và non-retryable (schema mismatch, authorization error) là then chốt. Retry chung chung mọi tool failure sẽ đốt token budget retry các error không bao giờ giải quyết được.

---

## Context window overflow xảy ra ở task quan trọng nhất

Các task agent mang lại giá trị cao nhất — operation multi-step phức tạp trên tài liệu lớn, workflow chạy dài, deep research task — chính là task dễ chạm giới hạn context window nhất. Đây không phải trùng hợp. Độ phức tạp và tiêu thụ context tỉ lệ với nhau.

Failure mode tinh tế. Agent sâu trong task 25 bước chạm trần context. Tùy cách harness xử lý overflow, một trong ba điều xảy ra: model âm thầm bỏ context cũ nhất (thường là instruction task gốc), harness throw exception không xử lý làm task chết, hoặc chất lượng response giảm khi model thao tác trên view bị cắt ngắn.

Cả ba đều tệ. Cái đầu tệ nhất, vì agent tiếp tục thực thi mà không có task context cần thiết — thường theo hướng có vẻ hợp lý nhưng sai hoàn toàn ý chính.

Context engineering hiệu quả cho production agent cần 3 thứ kết hợp:

**1. Theo dõi token budget mỗi agent step**: Trước mỗi LLM call, tính token count ước tính của full context. Nếu trong khoảng 15-20% giới hạn, kích hoạt strategy summarization hoặc truncation **trước** khi proceed — không phải sau overflow.

**2. Context tier có cấu trúc**: Không phải mọi context đều quan trọng như nhau. Task specification và tool call result mới nhất là critical. Background document load đầu session có thể tóm tắt. Tổ chức context thành tier (permanent, working, archivable) và áp dụng retention policy khác nhau.

**3. Checkpoint-resume tại context boundary**: Nếu task quá lớn để hoàn thành trong một context window, thiết kế workflow checkpoint tại các boundary tự nhiên, serialize agent state, và resume trong context mới với summary compact. Phức tạp hơn nghe có vẻ — summary phải giữ đủ độ trung thực để agent tiếp tục coherent — nhưng là pattern duy nhất xử lý task long-horizon đáng tin cậy.

---

## Khoảng trống observability sẽ khiến debug bất khả thi

Tôi đã debug agent failure với observability tốt và observability tệ. Khác biệt đo bằng giờ vs ngày, và "tìm ra root cause" vs "chúng tôi đoán có thể là...".

Thách thức với agent observability là application monitoring chuẩn không đủ. Bạn có thể có uptime metric hoàn hảo, error rate, latency histogram, mà vẫn không biết tại sao agent task cụ thể cho kết quả sai. Agent cần **execution trace** — bản ghi có cấu trúc về causality, không chỉ event. Context nào được pass ở mỗi bước? Model đã reasoning gì? Tool nào được gọi, theo thứ tự nào, với input gì, trả về gì? Đâu trong chain output bắt đầu lệch khỏi hành vi mong đợi?

Khoảng trống observability phổ biến nhất là vắng mặt step-level trace. Team instrument entry point (task received) và exit point (result returned), nhưng không có gì ở giữa. Khi task fail, execution trace cho: task started, result: failure. **Đó không phải observability. Đó là black box với một cái alarm.**

Observability tối thiểu cho production agent gồm:

- **Span-level tracing**: Mỗi agent step là một span với quan hệ parent-child tái tạo execution tree. Dùng span OpenTelemetry-compatible
- **Logging input/output mỗi tool call**: Full request và response cho mọi tool call, với timestamp. Đúng là dài. Đúng là bạn cần
- **Context snapshot tại điểm quyết định**: Token count và hash của context tại mỗi LLM call. Khi failure xảy ra, bạn có thể tái tạo những gì model thấy
- **Cost attribution per task**: Token spend chia theo step, để xác định phần nào của workflow tiêu budget không cân xứng

---

## Cost envelope cần hard limit, không phải soft suggestion

Bài học này đến từ một cuộc gọi page lúc 3 giờ sáng tôi không muốn lặp lại. Một agent kẹt trong retry loop — tool trả về response malformed, retry policy không có backoff, và cost control là alert threshold chứ không phải hard limit — tiêu **$800 trong 40 phút** trước khi có người can thiệp.

Thất bại có 3 nguyên nhân, tất cả cần fix độc lập:

1. Retry policy thiếu exponential backoff và max retry count
2. Response malformed lẽ ra phải kích hoạt non-retryable failure, không phải retryable
3. Cost limit là Slack alert, không phải circuit breaker

Cost control cho production agent cần engineering discipline như mọi resource constraint khác. Soft threshold sinh alert là cần nhưng không đủ. **Hard limit terminate execution — và fail gracefully thay vì chỉ crash — là standard production-grade.**

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

Cost envelope per-task, enforce tại orchestration layer, ngăn chi phí runaway bất kể chuyện gì xảy ra ở dưới stack. Set soft limit ở 70-80% hard limit để cho hệ thống thời gian alert và task hoàn thành bình thường nếu sát budget.

---

## Evaluation pipeline là production infrastructure, không phải bước QA

Hầu hết team coi agent evaluation như thứ xảy ra trước deploy: chạy eval suite, check score chấp nhận được, ship. Model này hỏng trong vài tuần sau khi live, vì dữ liệu production bộc lộ failure mode mà eval set trước deploy không cover.

Evaluation pipeline cho production agent cần chạy **liên tục, không định kỳ**. Mọi agent task hoàn thành — thành công hay không — là một data point để hiểu hành vi hệ thống. Một subset task hoàn thành nên tự động route đến model-graded evaluator check chất lượng output theo rubric. Pattern failure trong evaluator này nên feed back vào prokit prompt và harness iteration.

Đây không phải investment infrastructure nhỏ. Production evaluation pipeline cần:

- Sample đại diện của task production thực (PII đã strip khi cần)
- Model-graded evaluator với rubric ổn định, well-defined
- Metric aggregate theo thời gian (không chỉ snapshot point-in-time)
- Alert khi metric degradation — bắt quality regression trước khi compound
- Feedback loop từ kết quả evaluation đến backlog engineering

Team vận hành agent đáng tin cậy ở scale đều có infrastructure này. Team chật vật qua vài tháng đầu production hầu như không có.

---

## Nên build gì trước: Harness checklist ưu tiên

Với tất cả những điều trên, team deploy AI agent production nên tập trung effort engineering vào đâu? Dựa trên failure mode gây nhiều incident production nhất, theo thứ tự ưu tiên:

1. **Verification có cấu trúc sau mỗi tool call** — bắt #1 reliability killer ngay. Implement đầu tiên
2. **Cost envelope với hard limit** — ngăn chi phí runaway thảm họa. Implement trước khi go live
3. **Step-level execution trace** — không có thì debug production failure bất khả thi. Implement trước khi go live
4. **Retry policy với exponential backoff và max count** — resilience cơ bản. Phải là table stakes
5. **Context budget tracking** — ngăn overflow ở task phức tạp quan trọng. Implement trong sprint đầu sau launch
6. **Checkpoint-resume cho task long-horizon** — bắt buộc nếu agent xử lý task hơn 10-15 bước. Implement khi đã hiểu phân bố độ dài task
7. **Continuous evaluation pipeline** — infrastructure cho biết hệ thống đang tốt lên hay xấu đi theo thời gian. Build trong 60 ngày đầu vận hành production

---

## Kỷ luật trưởng thành khi team ngừng tối ưu thứ sai

Pattern đằng sau hầu hết production failure agent là **misallocated engineering effort**. Team đầu tư nặng vào model selection và prompt optimization — phần dễ thấy, hấp dẫn của hệ thống — và under-invest vào harness — hạ tầng không lấp lánh nhưng quyết định hệ thống có thực sự hoạt động.

Deploy AI agent production là vấn đề systems engineering. Model là một component. Harness — verification loop, context management, observability, cost control, evaluation pipeline, graceful degradation — là phần còn lại. **Team vận hành agent đáng tin cậy ở scale là những team hiểu điều này sớm và build theo.**

Mọi pattern trong bài này đến từ một incident production thực. Mọi cái đều có thể ngăn ngừa với harness infrastructure đúng đắn trước launch. Mục tiêu là học những bài này từ bài viết, không phải từ chính cuộc gọi 3 giờ sáng của bạn.

---

**Nguồn**: [Harness Engineering - Lessons Learned from Deploying AI Agents in Production](https://harness-engineering.ai/blog/lessons-learned-from-deploying-ai-agents-in-production/)
