# Cursor 使用示例（分级门禁版）

## Step 1：初始化项目

```bash
mkdir my-app && cd my-app
bash /path/to/ai-dev-workflow/scripts/init.sh my-app
```

初始化后会生成：`process.md`、`todolist.csv`、`CHANGELOG.md`、`.cursorrules`、`tasks/` 等。

> Cursor 会自动读取项目根目录的 `.cursorrules`，无需手动粘贴系统提示词。

---

## Step 2：Cursor 配置要点

### .cursorrules（已由 init.sh 自动生成）

`.cursorrules` 包含门禁规则、状态流、evidence 要求等，Cursor 每次对话都会自动加载。

### 推荐 Cursor Settings

- **Model**：选择 Claude 3.5 Sonnet 或更高版本
- **Codebase indexing**：开启，让 Cursor 自动索引项目文件
- **Long context**：开启，确保能完整读取 `process.md` 和 `todolist.csv`

---

## Step 3：按阶段在 Cursor Chat 中执行

### Stage 3（任务分解）

在 Cursor Chat 中输入：

```text
@stage-3-task-decomposition.md @process.md

当前进入阶段 1，请将模块分解为具体任务，写入 todolist.csv。
每个任务标注 priority 和 gate_profile。
high 任务需要同时输出简要技术方案。
```

### Stage 4（编码执行）— strict 任务

```text
@process.md @todolist.csv

请认领任务 001（priority=high, gate_profile=strict）。

执行要求：
1. 先写 failing test（RED），给出命令和失败输出
2. 实现代码使测试通过（GREEN），给出命令和通过输出
3. 运行完整验证：test + type-check + lint + build
4. 输出任务级 code review 结论
5. 更新 todolist.csv：status/review_status/verify_status/evidence
```

### Stage 4（编码执行）— balanced 任务

```text
@process.md @todolist.csv

请认领任务 003（priority=medium, gate_profile=balanced）。

执行要求：
1. 至少完成 1 组失败→通过测试循环
2. 运行 test + type-check
3. 完成后将状态置为 review，等待批量评审
4. 输出 review_status/verify_status/evidence
```

### Stage 4（编码执行）— light 任务

```text
@process.md @todolist.csv

请认领任务 004（priority=low, gate_profile=light）。

完成后运行 lint 或 type-check（至少 1 项），
输出 evidence 后将状态设为 review。
```

### Stage 5（审查交接）

```text
@stage-5-review-handoff.md @todolist.csv

请执行阶段出口校验：
1. 检查所有任务 status=done
2. 检查 review_status 与 verify_status
3. 抽查 strict 任务的 evidence 完整性
4. 输出人工业务验收报告
```

---

## 关键实践

### 1) 利用 Cursor 的 @ 引用

Cursor 可以直接用 `@文件名` 引用项目文件作为上下文：

```text
@process.md @todolist.csv @src/api/users.ts

请在 users.ts 中实现任务 002，gate_profile=strict。
```

这比手动粘贴上下文高效得多。

### 2) Composer 模式处理多文件变更

对于涉及多个文件的 strict 任务，使用 Cursor Composer：

```text
@process.md @todolist.csv

任务 001 需要同时修改以下文件：
- src/api/users.ts（API 实现）
- src/types/user.ts（类型定义）
- src/tests/users.test.ts（测试）

请按 strict 门禁执行，先写 RED test，再实现 GREEN。
```

### 3) inline edit 处理 light 任务

对于 light 任务（如样式调整、文档补充），可以直接在编辑器中选中代码，按 `Cmd+K` 使用 inline edit：

```text
补充这个函数的 JSDoc 注释，运行 lint 后给我 evidence。
```

### 4) 完成声明必须带证据

每个任务完成后，要求 Cursor 输出：

- 执行的验证命令
- 关键输出摘要
- `review_status`
- `verify_status`
- `evidence`

---

## 推荐会话模板

### 单任务执行

```text
@process.md @todolist.csv

项目：my-app
当前阶段：Stage 4
任务：001

请先判断 priority 与 gate_profile，列出门禁清单，再执行任务。

输出必须包含：
1) 代码变更
2) 门禁执行证据（RED/GREEN/验证命令与结果）
3) todolist.csv 更新建议（含 status/review_status/verify_status/evidence）
```

### 批量评审（balanced/light）

```text
@todolist.csv

当前阶段 1 中，以下 balanced/light 任务已完成编码并处于 review 状态：
- 任务 003（balanced）
- 任务 004（light）

请统一检查门禁证据，确认是否可以批量 approved -> done。
```
