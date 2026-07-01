---
title: "CrewAI"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
  - "[[raw/ai-agents-production/crewai-production-lessons]]"
tags: [entity, framework, crewai, multi-agent, production, cost]
---

# CrewAI

Framework agent nghĩ theo **task**, không phải hội thoại: định nghĩa agent với role và giao task cụ thể theo tuần tự hoặc phân cấp. Được xem là **"sự cân bằng thực tế"**.

- **Phù hợp nhất**: task multi-step có cấu trúc.
- **Điểm mạnh**: approach task-based cho cảm giác production-ready ngay; kiểm soát execution flow tốt hơn [[autogen|AutoGen]]; tích hợp tool mượt, tài liệu tốt; [[human-in-the-loop|HITL]] qua `human_input=True` trên task.
- **Điểm yếu**: kém linh hoạt cho scenario open-ended; memory giữa task khó quản lý; customization sâu cần workaround.
- **Chi phí**: $0.50–$2.00/task, 3,000–10,000 token.
- **Dẫn chứng**: build lại hệ thống đặt bàn trong **1 tuần** so với 3 tuần của AutoGen.

Là lựa chọn khuyến nghị cho Phase 1 trong [[agent-deployment-roadmap]]. Đã tích hợp [[ag-ui|AG-UI]]. So sánh tại [[agent-frameworks-comparison]].

## Bài học production (2026)

Từ [[crewai-production-lessons|CrewAI in Production 2026]] — kinh nghiệm thực chiến, có code + số liệu:

- **Narrow > generalist**: agent **2 tool** + backstory cụ thể thắng agent 6 tool (agent rộng gây wrong-tool, loop, output không nhất quán). Cấu hình production: `max_iter=10`, `max_execution_time=300`, `allow_delegation=False`.
- **`max_iter=25` mặc định là cost leak lớn nhất** → hạ về 5–8; pipeline 3-agent ~$0.30/run (xem [[agent-cost-management]]).
- **Sequential > hierarchical** cho production: hierarchical thêm non-determinism, debug thành black-box; chỉ dùng khi task set không thể định trước (~ pipeline pattern trong [[deployment-topologies]]).
- **`output_pydantic`** là "top reliability fix"; `context=[task]` truyền output đã validate xuống agent kế.
- **Không raise trong tool `_run`** — trả error string để agent retry (đối chiếu [[silent-tool-call-failures]]).
- Deploy: async FastAPI + job-status polling; observability qua LangSmith.

📖 Bản đầy đủ: [[articles/crewai-production-lessons]] · tóm tắt: [[summaries/crewai-production-lessons]].
