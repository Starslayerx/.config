---
name: Generate Wrok Report
description: Write daily, weekly and monthly work report from git commit messages and interacting with user.
---

# Work Report

## Instructions

下面是编写工作报告的流程：

1. 使用脚本 generate_report 获取对应时间 git 日志
2. 结合 git 日志内容询问用户相关信息
3. 根据用户要求编写日报、周报或月报

脚本使用方法：

```bash
./scripts/generate_report.sh [PERIOD | DATE [END_DATE]]
```

参数有以下两种格式：

- PERIOD: today, yesterday, thisweek, lastweek, thismonth, lastmonth
- DATE: 开始和结束日期，格式为 YYYY-MM-DD

脚本详细文档在 [generate_report_docs.1](docs/generate_report_docs.1)
报告参考信息在 [report_info](docs/report_into)
