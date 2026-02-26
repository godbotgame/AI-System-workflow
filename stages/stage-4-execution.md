# Stage 4: 阶段执行

**输入**：`todolist.csv`、`process.md`、`tasks/*.md`（如有）  
**输出**：完成的代码、更新的 `todolist.csv`、可审计的门禁证据

---

## 执行原则（分级门禁）

### Gate Profile 与强度

| gate_profile | 典型任务 | 必须满足 |
|---|---|---|
| `strict` | high 风险/核心链路 | TDD Red/Green、任务级评审、完整验证证据 |
| `balanced` | 常规业务改动 | 至少 1 组失败→通过测试循环、阶段内批量评审、验证证据 |
| `light` | 低风险/文档/样式 | 最小验证（lint/type-check/smoke 至少 1 项）+ 抽样评审 |

默认映射：`high -> strict`、`medium -> balanced`、`low -> light`。可在 `todolist.csv` 手动覆写 `gate_profile`。

### 状态机（统一）

`todo -> in-progress -> review -> done`

规则：
- `strict` 必须经过 `review` 才能 `done`
- `balanced/light` 可以批量进入 `review`，统一放行后再 `done`
- 任一门禁失败时，状态回退到 `in-progress`

---

## 执行步骤

### Step 1: 任务认领

1. 找到 `status=todo` 且依赖已完成的任务
2. 读取 `priority + gate_profile`
3. 更新 `status=in-progress`
4. 在 `notes` 标记开始时间和执行人

### Step 2: 按 gate_profile 实施

#### strict（high）
1. 写 failing test（RED）并记录命令/输出摘要
2. 实现最小代码使测试通过（GREEN）并记录证据
3. 运行完整验证：`test + type-check + lint (+build)`
4. 发起任务级 code review（critical/important 必须清零）
5. 更新 `review_status=approved`、`verify_status=passed`

#### balanced（medium）
1. 至少完成 1 组失败→通过测试循环
2. 运行不少于 2 项验证（如 `test + type-check`）
3. 进入阶段内批量评审队列
4. 评审通过后更新 `review_status=approved`、`verify_status=passed`

#### light（low）
1. 执行最小验证（lint/type-check/smoke 至少 1 项）
2. 接受抽样评审
3. 评审通过后更新状态

### Step 3: 进入 review

将任务状态更新为 `review`，并填写：
- `review_status`：`pending -> approved / changes-requested`
- `verify_status`：`pending -> passed / failed`
- `evidence`：命令+结果摘要（可写路径引用）

### Step 4: 任务完成

仅当以下条件满足，才能 `status=done`：
- 对应 gate_profile 的门禁全部通过
- `review_status=approved`
- `verify_status=passed`
- `evidence` 非空且可复核

---

## 推荐验证命令

```bash
# 测试（按项目调整）
npm run test -- --testPathPattern=[模块名]

# 类型检查
npm run type-check

# 规范检查
npm run lint

# 构建（strict 推荐）
npm run build
```

---

## 错误处理

若门禁失败，输出：

```markdown
## 门禁失败报告

**任务**：[task-id]
**gate_profile**：[strict/balanced/light]
**失败环节**：[RED/GREEN/Review/Verify]
**失败证据**：[命令 + 摘要]
**修复计划**：[下一步动作]
```

失败时不得进入 `done`。

---

## 验收标准

- [ ] 所有任务符合 `todo -> in-progress -> review -> done`
- [ ] strict 任务具备完整 TDD + 任务级评审 + 完整验证证据
- [ ] balanced 任务完成最少测试循环 + 批量评审 + 验证
- [ ] light 任务完成最小验证 + 抽样评审
- [ ] `review_status` 与 `verify_status` 已正确填写
- [ ] `evidence` 可复核

---

## 输出到 Stage 5

交付以下内容：
- 更新后的 `todolist.csv`（含 `gate_profile/review_status/verify_status/evidence`）
- 分级门禁执行证据
- 功能演示与人工验收说明

---

## ❓ 常见问题 FAQ

**Q1: balanced 必须像 strict 一样全量 TDD 吗？**  
A: 不必须。至少 1 组失败→通过循环即可，但关键路径建议上调 strict。

**Q2: light 能不能不评审？**  
A: 不能。至少需要抽样评审。

**Q3: 验证命令失败但功能看起来可用，能 done 吗？**  
A: 不能。`verify_status` 必须为 `passed`。
