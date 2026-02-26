# Stage 3: 任务分解

**输入**：当前开发阶段的模块列表和验收标准  
**输出**：`todolist.csv`（任务清单）、`process.md`（更新当前阶段上下文）、`tasks/*.md`（关键任务卡）

---

## 执行步骤

### Step 1: 分解到可执行任务

将当前阶段模块分解为具体编码任务，并按优先级控制粒度：
- `high`：推荐 30-90 分钟，便于严格门禁和快速回滚
- `medium` / `low`：保持 1-4 小时

**任务粒度参考**：
- ✅ 好："实现 POST /api/users 接口，支持用户注册，包含参数验证和错误处理"
- ❌ 太大："实现用户系统"
- ❌ 太小："在 user.ts 中添加一个变量"

### Step 2: 任务分级与门禁映射

为每个任务确定 `gate_profile`（支持覆写）：
- 默认映射：`high -> strict`、`medium -> balanced`、`low -> light`
- 特殊风险任务可手动上调（如 `medium -> strict`）

门禁要求：
- `strict`：TDD Red/Green + 任务级 code review + 完整验证证据
- `balanced`：至少 1 组失败→通过测试循环 + 阶段内批量 review + 验证证据
- `light`：最小验证（lint/type-check/smoke 至少 1 项）+ 抽样 review

### Step 3: 技术方案简述（high 优先级任务）

对每个 high 任务编写简要方案并交人工快速确认：

```markdown
## 任务 [id]：[任务名]

**实现思路**：[1-3 句话描述方案]
**涉及文件**：[列出需要新建/修改的文件]
**风险点**：[有则写，无则留空]
**备选方案**：[如有其他可选方案]
```

> ⚠️ 该环节用于提前止损，避免 Stage 4 走错方向。

### Step 4: 更新 todolist.csv

按新表头填充任务清单：

```csv
id,phase,module,task,priority,gate_profile,status,assignee,estimated_hours,actual_hours,review_status,verify_status,evidence,notes
001,1,auth,实现用户注册 API (POST /api/users),high,strict,todo,AI,2,,,,,需要邮箱验证
002,1,auth,实现用户登录 API (POST /api/auth/login),high,strict,todo,AI,2,,,,,JWT token；依赖 001
003,1,auth,编写 auth 模块集成测试,medium,balanced,todo,AI,3,,,,,依赖 001~002
004,1,docs,补充接口使用说明,low,light,todo,AI,1,,,,,依赖 002
```

**状态说明**：
- `todo`：待开始
- `in-progress`：进行中
- `review`：待评审（任务级或阶段级）
- `done`：已完成
- `blocked`：被阻塞（在 notes 中说明）

### Step 5: 更新 process.md 与任务卡

在 `process.md` 记录本阶段背景，并为高风险任务创建 `tasks/[id]-[task-name].md`：
- high 任务：必须有任务卡，包含 strict 证据区块
- medium/low：按需创建任务卡，至少保留证据链接或摘要

---

## AI 提示词：任务分解

```
当前阶段：阶段 [N] - [阶段名]
涉及模块：[模块列表]

请将模块分解为可执行任务并写入 todolist.csv：
- high 任务拆到 30-90 分钟；medium/low 为 1-4 小时
- 先按 priority 生成 gate_profile（high->strict, medium->balanced, low->light）
- 可手动覆写 gate_profile 并说明理由
- 标注依赖关系（notes 中写 "依赖 task-id"）
- 填写 estimated_hours

模块详细需求：
[从 stage-1 架构文档复制]
```

---

## 验收标准

- [ ] `todolist.csv` 已更新并包含 `gate_profile/review_status/verify_status/evidence`
- [ ] high 任务粒度为 30-90 分钟，medium/low 粒度合理
- [ ] high 任务已有简要技术方案并经人工确认
- [ ] 依赖关系已在 notes 标注
- [ ] `process.md` 已更新当前阶段信息
- [ ] 高风险任务已创建 `tasks/*.md`

---

## 输出到 Stage 4

将以下内容交给 Stage 4：
- 更新后的 `todolist.csv`
- 更新后的 `process.md`
- high 任务技术方案与 `tasks/*.md`
- 当前阶段架构文档（来自 Stage 1）

---

## ❓ 常见问题 FAQ

**Q1: medium 任务可以设为 strict 吗？**  
A: 可以。涉及核心链路、数据安全、支付等场景应手动上调。

**Q2: 任务太多会不会拖慢？**  
A: 只对 high 任务强制细粒度和全门禁，medium/low 保持效率优先。

**Q3: 需求不明确怎么办？**  
A: 先暂停分解，把问题写入 `process.md` 的"遇到的问题"，待人工澄清。
