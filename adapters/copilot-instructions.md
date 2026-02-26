# GitHub Copilot 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: Copilot Chat (VS Code / JetBrains)、Copilot Workspace

---

## 配置方式

### 方式 1：`.github/copilot-instructions.md`（推荐）

由 `scripts/init.sh` 自动生成，也可手动创建：

```markdown
# Copilot Instructions

This project uses AI Dev Workflow with risk-based gates.

## Required files
- process.md
- todolist.csv
- ai-dev-workflow/stages/

## Required flow
1. Read process.md and todolist.csv first
2. Determine priority and gate_profile before coding
3. Follow status flow: todo -> in-progress -> review -> done
4. Do not mark done until review_status=approved and verify_status=passed

## Gate profiles
- strict: Red/Green + task-level review + full verification evidence
- balanced: at least one fail->pass cycle + batch review + verification evidence
- light: minimal verification + sampled review
```

### 方式 2：VS Code 设置

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    { "file": "process.md" },
    { "file": "todolist.csv" },
    { "file": "ai-dev-workflow/CHEATSHEET.md" }
  ]
}
```

---

## Copilot Chat 使用模板

### 任务执行
```text
#file:process.md #file:todolist.csv

我在 Stage [N]，任务 [id]。
请先判断 gate_profile，再执行任务。
完成后给出：
- 代码变更
- review_status / verify_status
- evidence（命令 + 结果摘要）
```

### 代码审查
```text
#file:process.md #file:todolist.csv

请审查任务 [id] 是否满足 gate_profile 门禁要求，
并指出是否可以从 review 进入 done。
```

---

## 注意事项

- Copilot 更适合辅助编码，不适合单独承担 strict 全流程
- strict 任务建议配合 Claude/Codex 做评审与验收
- 不允许跳过 review 直接 done
