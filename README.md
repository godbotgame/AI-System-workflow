# AI 大型系统开发工作流 (AI Dev Workflow)

> 适用于 Codex、Cursor、Claude、Antigravity、Windsurf、Copilot 等 AI 编程工具的标准化多阶段开发工作流

## 🚀 快速开始

1. **初始化项目**：`bash ai-dev-workflow/scripts/init.sh my-project`
2. **选择你的 AI 工具**：查看 `adapters/` 对应接入说明
3. **从 Stage 0 开始**：打开 `stages/stage-0-project-init.md`
4. **按阶段推进**：每个阶段完成后人工验收，通过后进入下一阶段
5. **速查卡**：`CHEATSHEET.md`

## 🗺️ 工作流概览

```text
Stage 0: 项目初始化  -> 技术栈选型 + 项目脚手架
Stage 1: 架构设计    -> 模块划分 + DB 设计 + API 合约
Stage 2: 阶段规划    -> 按模块依赖划分开发阶段
Stage 3: 任务分解    -> todolist.csv + gate_profile
Stage 4: 阶段执行    -> 按分级门禁实施并沉淀证据
Stage 5: 审查交接    -> 阶段出口校验 + 人工业务验收
```

## ⚖️ 效率优化：分级门禁（质量优先 + 速度平衡）

为避免“所有任务都走最重流程”导致效率下降，本工作流引入 `gate_profile`：

| 优先级 | 默认 gate_profile | 执行强度 |
|---|---|---|
| high | strict | TDD Red/Green + 任务级 code review + 完整验证证据 |
| medium | balanced | 至少 1 组失败→通过测试循环 + 阶段内批量 review + 验证证据 |
| low | light | 最小验证（lint/type-check/smoke 至少 1 项）+ 抽样 review |

- 默认映射：`high -> strict`、`medium -> balanced`、`low -> light`
- 可手动覆写 `gate_profile`（例如将高风险 medium 提升为 strict）
- 统一状态机：`todo -> in-progress -> review -> done`

## 📁 目录结构

```text
ai-dev-workflow/
├── README.md
├── CHEATSHEET.md
├── workflow-main.md
├── agent-routing.md
├── scripts/
│   └── init.sh
├── adapters/
│   ├── antigravity-workflow.md
│   ├── claude-instructions.md
│   ├── codex-prompt.md
│   ├── windsurf-workflow.md
│   └── copilot-instructions.md
├── stages/
│   ├── stage-0-project-init.md
│   ├── stage-1-architecture.md
│   ├── stage-2-phase-planning.md
│   ├── stage-3-task-decomposition.md
│   ├── stage-4-execution.md
│   └── stage-5-review-handoff.md
└── templates/
    ├── feature-task.md
    ├── process.md
    ├── todolist.csv
    └── changelog.md
```

## 🔧 支持的 AI 工具

| 工具 | 适配器文件 | 最擅长 |
|------|------------|--------|
| Antigravity / Gemini | `adapters/antigravity-workflow.md` | 全流程编排、长上下文分析 |
| Claude / Cursor | `adapters/claude-instructions.md` | 架构设计、代码审查 |
| Codex / ChatGPT | `adapters/codex-prompt.md` | 快速代码生成、API 调用 |
| Windsurf / Codeium | `adapters/windsurf-workflow.md` | 多文件编辑、Cascade 自动化 |
| GitHub Copilot | `adapters/copilot-instructions.md` | 行内补全、函数实现 |

## 📋 核心原则

1. **人机协作**：AI 执行，人工决策与验收
2. **阶段隔离**：每阶段输入/输出/验收标准明确
3. **质量前移**：主要技术门禁在 Stage 4 完成，Stage 5 做出口复核
4. **可追溯**：通过 `todolist.csv`、`process.md`、`CHANGELOG.md` 留痕
5. **效率平衡**：通过分级门禁控制质量与速度
