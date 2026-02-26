# Codex 使用示例（分级门禁版）

## Step 1：初始化项目

```bash
mkdir my-app && cd my-app
bash /path/to/ai-dev-workflow/scripts/init.sh my-app
```

初始化后会生成：`process.md`、`todolist.csv`、`CHANGELOG.md`、`AGENTS.md`、`tasks/` 等。

---

## Step 2：准备 Codex 上下文

Codex 场景建议使用 `AGENTS.md` + 阶段文档双约束。

每次执行任务前都先让 Codex：
1. 读取 `process.md`
2. 读取 `todolist.csv`
3. 判断 `priority` 与 `gate_profile`
4. 给出本任务门禁清单后再开始实现

---

## Step 3：按阶段执行

### Stage 3（任务分解）

```bash
codex "请读取 ai-dev-workflow/stages/stage-3-task-decomposition.md、process.md。为当前阶段拆分任务，写入 todolist.csv，并给每个任务标注 gate_profile。"
```

### Stage 4（编码执行）

```bash
codex "请读取 process.md 和 todolist.csv，认领任务 001。先判断 gate_profile，再按门禁执行。完成后更新 status/review_status/verify_status/evidence。"
```

### Stage 5（审查交接）

```bash
codex "请读取 stage-5-review-handoff.md 和 todolist.csv，先做阶段出口校验，再输出人工业务验收报告。"
```

---

## 关键实践

### 1) 不再盲目全自动批量

- `strict` 任务：建议逐任务执行 + 人工确认
- `balanced` 任务：可小批量执行后统一 review
- `light` 任务：可提高自动化比例，但必须保留最小验证

### 2) 每次都要先判定 gate_profile

```bash
codex "先读取 process.md 和 todolist.csv，告诉我任务 003 的 priority/gate_profile，以及该任务 done 前必须满足哪些门禁。"
```

### 3) 完成声明必须带证据

要求 Codex 输出：
- 执行命令
- 关键输出摘要
- `review_status`
- `verify_status`
- `evidence`

---

## 推荐会话模板

```bash
codex "
项目：my-app
当前阶段：Stage 4
任务：001

请先读取 process.md 与 todolist.csv。
先判断 priority 与 gate_profile，再执行任务。

输出必须包含：
1) 代码变更
2) 门禁执行证据
3) todolist.csv 更新建议（含 status/review_status/verify_status/evidence）
"
```
