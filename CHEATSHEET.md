# AI Dev Workflow 快速参考卡 (Cheatsheet)

> 一页纸速查，覆盖日常使用的 80% 场景

---

## 🔄 工作流速览

```text
Stage 0 项目初始化 -> Stage 1 架构设计 -> Stage 2 阶段规划
                                       |
                                Stage 3 任务分解
                                       |
                                Stage 4 阶段执行
                                       |
                                Stage 5 审查交接
```

---

## 📦 初始化新项目

```bash
bash ai-dev-workflow/scripts/init.sh my-project
```

生成：`process.md`、`todolist.csv`、`CHANGELOG.md`、`.cursorrules`、`AGENTS.md`、`tasks/`

---

## 📄 核心文件速查

| 文件 | 作用 | 何时更新 |
|------|------|----------|
| `process.md` | 项目背景与阶段上下文 | 每个 Stage 结束 |
| `todolist.csv` | 任务状态 + 门禁证据 | 每个任务流转时 |
| `tasks/*.md` | 关键任务执行证据 | high 任务必填 |
| `CHANGELOG.md` | 阶段变更记录 | 每阶段验收后 |

---

## 🚦 分级门禁速查矩阵

| gate_profile | 触发条件 | 必做门禁 | 进入 done 条件 |
|---|---|---|---|
| `strict` | 默认 high | Red/Green + 任务级 review + 完整验证 | review=approved 且 verify=passed |
| `balanced` | 默认 medium | 至少 1 组失败→通过测试循环 + 批量 review + 验证 | review=approved 且 verify=passed |
| `light` | 默认 low | lint/type-check/smoke 至少 1 项 + 抽样 review | review=approved 且 verify=passed |

默认映射：`high->strict`、`medium->balanced`、`low->light`，可手动覆写。

---

## 📊 todolist.csv 关键字段

- `priority`：high / medium / low
- `gate_profile`：strict / balanced / light
- `status`：todo / in-progress / review / done / blocked
- `review_status`：pending / approved / changes-requested
- `verify_status`：pending / passed / failed
- `evidence`：命令与结果摘要（可填链接/路径）

---

## ✅ 阶段完成检查

```text
□ status 全部到 done
□ review_status 全部 approved
□ verify_status 全部 passed
□ evidence 可复核
□ process.md 已更新
□ 人工验收通过
```

---

## 💬 对话启动模板

```text
项目：[项目名]
当前阶段：Stage [N] - [Name]
任务：[描述]

请先读取：
1. ai-dev-workflow/stages/stage-[N]-xxx.md
2. process.md
3. todolist.csv

并先判断 gate_profile 与门禁清单。
```
