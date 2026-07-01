---
title: "CrewAI"
type: entity
created: 2026-07-01
updated: 2026-07-01
sources:
  - "[[raw/ai-agents-production/01_AI_Agents_Production_47Billion_VN]]"
tags: [entity, framework, crewai, multi-agent]
---

# CrewAI

Framework agent nghĩ theo **task**, không phải hội thoại: định nghĩa agent với role và giao task cụ thể theo tuần tự hoặc phân cấp. Được xem là **"sự cân bằng thực tế"**.

- **Phù hợp nhất**: task multi-step có cấu trúc.
- **Điểm mạnh**: approach task-based cho cảm giác production-ready ngay; kiểm soát execution flow tốt hơn [[autogen|AutoGen]]; tích hợp tool mượt, tài liệu tốt; [[human-in-the-loop|HITL]] qua `human_input=True` trên task.
- **Điểm yếu**: kém linh hoạt cho scenario open-ended; memory giữa task khó quản lý; customization sâu cần workaround.
- **Chi phí**: $0.50–$2.00/task, 3,000–10,000 token.
- **Dẫn chứng**: build lại hệ thống đặt bàn trong **1 tuần** so với 3 tuần của AutoGen.

Là lựa chọn khuyến nghị cho Phase 1 trong [[agent-deployment-roadmap]]. Đã tích hợp [[ag-ui|AG-UI]]. So sánh tại [[agent-frameworks-comparison]].
