# AI 工具路由指南 (Agent Routing)

> 根据阶段、任务类型和 `gate_profile` 选择最合适工具。

---

## 路由决策表

| 阶段 | 任务类型 | 推荐工具 | 原因 |
|------|----------|----------|------|
| Stage 0 | 技术栈选型 | Claude / Antigravity | 深度分析与权衡 |
| Stage 1 | 架构设计 | Claude / Antigravity | 系统性思考 |
| Stage 2 | 阶段规划 | Antigravity / Claude | 复杂编排能力 |
| Stage 3 | 任务分解 | Claude | 结构化拆解 |
| Stage 4 | 代码实现 | Cursor / Codex / Windsurf | IDE 集成与多文件编辑 |
| Stage 5 | 审查交接 | Claude / Antigravity | 全局审阅与验收表达 |

---

## Stage × Superpowers Skill × Gate Profile

| Stage | 推荐 Skill | strict | balanced | light |
|---|---|---|---|---|
| Stage 3 | brainstorming / writing-plans | 高风险任务细化到可审计步骤 | 生成批量执行计划 | 简化计划，保留验证点 |
| Stage 4 | test-driven-development / requesting-code-review / verification-before-completion | 全量执行 | 关键路径执行 | 最小执行 |
| Stage 5 | verification-before-completion | 抽查完整证据链 | 抽查代表任务 | 抽样抽查 |

> 说明：本工作流保留 6 Stage，不切换为纯 Superpowers 流程；仅吸收其质量门禁思想。

---

## Gate Profile 与工具建议

### strict（高风险）
- 推荐：Cursor + Claude 审查（或 Codex + Claude）
- 要求：必须有 TDD Red/Green、任务级评审、完整验证

### balanced（常规）
- 推荐：Cursor / Codex / Windsurf
- 要求：至少 1 组失败→通过测试循环，阶段内批量评审

### light（低风险）
- 推荐：Copilot + 主力工具
- 要求：最小验证 + 抽样评审

---

## 多 Agent 协作模式（Stage 4）

建议按模块划分并配合 Git 分支/工作区隔离：

```text
模块 A（前端） -> Cursor + Claude
模块 B（后端） -> Codex + Cursor
模块 C（测试） -> Codex / Claude
```

协作规则：
- 每个 Agent 只认领 `status=todo` 且依赖已完成的任务
- 认领后改为 `in-progress`
- 进入 `review` 后按门禁放行
- 通过后改为 `done`

---

## 切换工具交接模板

```markdown
## 上下文交接

**项目**：[项目名]
**当前 Stage**：[N]
**任务**：[task-id]
**priority / gate_profile**：[high/strict]
**已完成证据**：[命令与摘要]
**待完成门禁**：[review / verify]
```
