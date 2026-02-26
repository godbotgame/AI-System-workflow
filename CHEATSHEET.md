# AI Dev Workflow 快速参考卡 (Cheatsheet)

> 📋 一页纸速查，覆盖日常使用的 80% 场景

---

## 🔄 工作流速览

```
Stage 0 项目初始化 → Stage 1 架构设计 → Stage 2 阶段规划
                                              ↓
                           ┌── Stage 3 任务分解 ←──┐
                           ↓                       │
                      Stage 4 阶段执行              │
                           ↓                       │
                      Stage 5 审查交接 ─(循环)──────┘
                           ↓
                        项目交付
```

---

## 📦 初始化新项目

```bash
# 一条命令初始化
bash ai-dev-workflow/scripts/init.sh my-project

# 生成的文件：
# ./process.md      ← 填写项目信息
# ./todolist.csv    ← 任务追踪
# ./CHANGELOG.md    ← 变更日志
# ./.cursorrules    ← Cursor 配置
# ./tasks/          ← 任务详情目录
```

---

## 📄 核心文件速查

| 文件 | 作用 | 何时更新 |
|------|------|----------|
| `process.md` | AI 的"记忆" | 每个 Stage 结束 |
| `todolist.csv` | 任务状态追踪 | 每个任务完成时 |
| `CHANGELOG.md` | 阶段变更记录 | 每个阶段验收后 |

---

## 🛠️ 工具选择速查

| 任务 | 首选工具 | 原因 |
|------|----------|------|
| 规划 / 架构 | Antigravity / Claude | 长上下文、系统思考 |
| 编码实现 | Cursor | IDE 集成 |
| 快速生成 | Codex / Copilot | 代码补全快 |
| 代码审查 | Claude / Antigravity | 全局理解 |

---

## 💬 AI 对话启动模板

```
项目：[项目名]
当前阶段：Stage [N] - [Name]
任务：[描述]

请先阅读：
1. ai-dev-workflow/stages/stage-[N]-xxx.md
2. process.md
3. todolist.csv
```

---

## 📊 todolist.csv 状态码

| 状态 | 含义 |
|------|------|
| `todo` | 待开始 |
| `in-progress` | 进行中 |
| `done` | 已完成 |
| `blocked` | 被阻塞（见 notes） |
| `review` | 等待人工验收 |

---

## ✅ 每阶段完成检查

```
□ todolist.csv 全部 done
□ 测试通过
□ process.md 已更新
□ CHANGELOG.md 已记录
□ 人工验收通过
```

---

## 🔀 切换工具时的交接

```
项目：xxx  |  当前 Stage N  |  已完成：[列表]  |  接下来：[任务]
```

将 `process.md` + `todolist.csv` 交给新工具即可。
