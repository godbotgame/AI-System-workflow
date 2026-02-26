# AI 工具路由指南 (Agent Routing)

> 根据任务类型和当前阶段，选择最合适的 AI 工具。

---

## 路由决策表

| 阶段 | 任务类型 | 推荐工具 | 原因 |
|------|----------|----------|------|
| Stage 0 | 技术栈选型 | Claude / Antigravity | 需要深度分析和权衡 |
| Stage 0 | 脚手架生成 | Codex / Cursor | 代码生成能力强 |
| Stage 1 | 架构设计 | Claude / Antigravity | 需要系统性思考 |
| Stage 1 | 数据库设计 | Claude | 结构化输出准确 |
| Stage 1 | API 合约 | Codex | 代码格式相关 |
| Stage 2 | 阶段规划 | Antigravity | 复杂编排能力 |
| Stage 3 | 任务分解 | Claude | 结构化分析 |
| Stage 4 | 代码实现 | Cursor / Codex | 集成 IDE，实时编码 |
| Stage 4 | 单元测试 | Codex / Cursor | 代码补全 |
| Stage 5 | 代码审查 | Claude / Antigravity | 全局理解能力 |

---

## 工具特性对比

### 🤖 Antigravity (Gemini)
- **优势**：长上下文、全文件读取、复杂编排
- **适用**：Stage 0-2 规划阶段；需要读取多个文件的场景
- **接入**：`adapters/antigravity-workflow.md`
- **上下文限制**：超长（100万+ tokens）

### 🤖 Claude (Cursor 内置)
- **优势**：代码质量高、理解能力强、指令遵循好
- **适用**：Stage 1 架构、Stage 5 审查
- **接入**：`adapters/claude-instructions.md`
- **上下文限制**：200K tokens

### 🤖 Codex / GPT-4 (ChatGPT)
- **优势**：快速、擅长补全、API 生态成熟
- **适用**：Stage 4 具体任务实现
- **接入**：`adapters/codex-prompt.md`
- **上下文限制**：128K tokens（gpt-4o）

### 🤖 Cursor (AI IDE)
- **优势**：集成开发环境、实时预览、多文件编辑
- **适用**：Stage 4 所有编码任务（推荐主力工具）
- **接入**：使用 `adapters/claude-instructions.md` 中的 Cursor Rules
- **特点**：可直接读取本地文件和项目上下文

### 🤖 Windsurf (Codeium)
- **优势**：Cascade 多步骤自动化、文件索引
- **适用**：Stage 4 多文件编码和重构
- **接入**：`adapters/windsurf-workflow.md`
- **特点**：用 `@` 引用文件提供上下文

### 🤖 GitHub Copilot
- **优势**：行内补全极快、IDE 深度集成
- **适用**：Stage 4 辅助编码（与主力工具配合）
- **接入**：`adapters/copilot-instructions.md`
- **特点**：适合快速函数实现和注释生成

---

## 多 Agent 协作模式（Stage 4）

当一个阶段任务较多时，可以并行使用多个 Agent：

```
阶段 N 任务列表
├── 模块 A（前端）  ──> Cursor + Claude
├── 模块 B（后端）  ──> Cursor + Codex  
└── 模块 C（测试）  ──> Codex
```

各 Agent 通过 `todolist.csv` 协调，避免冲突：
- 每个 Agent 只认领 `status=todo` 的任务
- 完成后立即更新状态为 `done`
- 有依赖的任务等待前置任务 `done` 后才开始

---

## 切换工具时的交接模板

```markdown
## 上下文交接

**项目**：[项目名]
**前一个工具**：[工具名，如 Antigravity]
**完成的工作**：
- [已完成事项1]
- [已完成事项2]

**当前状态**：[当前处于 Stage N，正在做什么]

**接下来需要你做**：
- [具体任务]

**重要上下文**：
- [关键决策1]
- [关键决策2]
```
