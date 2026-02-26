# GitHub Copilot 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: Copilot Chat (VS Code / JetBrains)、Copilot Workspace

---

## 配置方式

### 方式 1：`.github/copilot-instructions.md`（推荐）

由 `scripts/init.sh` 自动生成，也可手动创建：

```markdown
# Copilot Instructions

This project follows the **AI Dev Workflow** methodology.

## Key Files
- `process.md` - Project context, current stage, and tech decisions
- `todolist.csv` - Task tracking with status (todo/in-progress/done)
- `ai-dev-workflow/stages/` - Stage-specific instructions

## Workflow Stage
Current stage is tracked in `process.md`. Always check it before starting work.

## Code Standards
- Provide complete code, never abbreviate with "..."
- Add error handling for all API endpoints
- Include TypeScript types for all interfaces
- Write unit tests for new functions

## Task Completion
After each task:
1. Update the task status in todolist.csv to "done"
2. Record any key decisions in process.md
```

### 方式 2：VS Code 设置

在 `.vscode/settings.json` 中添加：

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    { "file": "process.md" },
    { "file": "ai-dev-workflow/CHEATSHEET.md" }
  ]
}
```

---

## Copilot Chat 使用模板

### 任务执行
```
#file:process.md #file:todolist.csv

我在 Stage [N]，请帮我执行 todolist.csv 中任务 [id]：
[任务描述]

要求：
- 完整代码
- 包含测试
- 完成后告诉我如何更新 todolist.csv
```

### 代码审查
```
#file:process.md

请审查以下代码，对照项目约定（见 process.md 重要约定部分）检查：
1. 命名规范
2. 错误处理
3. 类型安全
4. 测试覆盖
```

---

## Copilot Workspace 使用

Copilot Workspace 适合处理 **Stage 4** 中的具体编码任务：

1. 在 GitHub Issue 中描述任务（从 todolist.csv 复制）
2. 打开 Copilot Workspace
3. 让 Workspace 分析代码库并生成方案
4. 审查并确认修改
5. 提交 PR

---

## 适合 Copilot 的任务

| 任务类型 | 适合度 | 说明 |
|----------|--------|------|
| 代码补全 | ⭐⭐⭐⭐⭐ | Copilot 核心能力 |
| 函数实现 | ⭐⭐⭐⭐⭐ | 给函数签名和注释即可 |
| 测试生成 | ⭐⭐⭐⭐ | 自动生成测试用例 |
| 文档注释 | ⭐⭐⭐⭐ | 代码注释和 JSDoc |
| 架构设计 | ⭐⭐ | 上下文理解有限 |

---

## 与其他工具的协作

Copilot 最适合作为 **辅助工具**（Stage 4），与主力工具配合：

```
主力工具（Cursor/Windsurf）: 负责复杂任务、多文件编辑
Copilot: 负责行内补全、快速函数实现、注释生成
```

---

## 注意事项

- Copilot 无法直接读取和修改 `todolist.csv`，需要人工同步
- Copilot Chat 上下文有限，每次只能处理 1-2 个任务
- 对于需要理解全局架构的任务，建议使用 Claude/Antigravity
