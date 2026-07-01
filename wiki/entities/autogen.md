---
title: "AutoGen"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [entity, framework, autogen, multi-agent]
---

# AutoGen

Framework agent với mô hình tư duy dựa trên **các cuộc hội thoại (conversations)**: định nghĩa agent với persona cụ thể, chúng nói chuyện với nhau để hoàn thành task.

- **Phù hợp nhất**: cộng tác multi-agent khám phá, task phức tạp mở.
- **Điểm mạnh**: paradigm hội thoại trực quan; code execution agent tốt; [[human-in-the-loop|HITL]] là first-class citizen (`human_input_mode`: `ALWAYS`/`TERMINATE`/`NEVER`).
- **Điểm yếu**: hội thoại đi vòng không hội tụ; **token cực cao** (mỗi agent thấy toàn bộ lịch sử — task 1,000 token thành 5,000+); debug multi-agent rất khó; đôi khi gọi tool thừa.
- **Chi phí**: $2.00–$5.00/task, 5,000–25,000 token — đắt nhất trong 3 framework (xem [[agent-cost-management]]).

Triển khai một biến thể của [[react-pattern|ReAct]]. So sánh chi tiết tại [[agent-frameworks-comparison]].
