# Stage 4: 阶段执行

**输入**：`todolist.csv`（任务列表）、`process.md`（项目上下文）  
**输出**：完成的代码、更新的 `todolist.csv`（所有 status=done）  

---

## 执行模式

### 单 Agent 模式（简单阶段）

AI 按顺序执行 todolist.csv 中的任务：

```
FOR each task in todolist.csv WHERE status = "todo":
  1. 读取任务详情
  2. 检查依赖任务是否 done
  3. 执行任务
  4. 自测（运行相关测试）
  5. 更新 status = "done"，填写 actual_hours
DONE
```

### 多 Agent 并行模式（复杂阶段）

对于任务量大、可并行的阶段，使用多个 AI 工具同时执行：

```
Agent A (Cursor): 负责前端任务 (module=frontend)
Agent B (Codex):  负责后端 API (module=api)
Agent C (Claude): 负责测试 (module=test)

协调规则：
- 每个 Agent 只认领 status=todo 的任务
- 认领后立即更新为 status=in-progress
- 完成后更新为 status=done
- 有依赖的任务等依赖完成后再认领
```

#### ⚠️ 冲突避免策略

多 Agent 并行时，`todolist.csv` 是文件，无法实现实时同步。推荐以下策略：

| 策略 | 适用场景 | 说明 |
|------|----------|------|
| **按模块/目录划分** | 模块间耦合低 | 每个 Agent 只修改自己模块的文件，物理隔离 |
| **Git 分支隔离** | 推荐方案 | 每个 Agent 在独立 feature 分支上工作，完成后 merge |
| **顺序编排** | 最安全 | 放弃并行，人工逐一分配任务给不同 Agent |

**推荐流程（Git 分支法）**：
```bash
# Agent A 的分支
git checkout -b feature/frontend-phase-1

# Agent B 的分支
git checkout -b feature/api-phase-1

# 各自完成后
git checkout dev
git merge feature/frontend-phase-1
git merge feature/api-phase-1  # 解决冲突
```

---

## 执行步骤

### Step 1: 任务认领

```
请查看 todolist.csv，找到所有 status=todo 且依赖已完成的任务。
按优先级（high > medium > low）认领第一个任务，并将其状态更新为 in-progress。
告诉我你认领了哪个任务。
```

### Step 2: 任务实现

每个任务的执行流程：

1. **理解任务**：读取任务描述和技术方案（如有）
2. **规划实现**：说明实现思路（1-3句话）
3. **编写代码**：输出完整代码
4. **添加测试**：输出单元测试（如果适用）
5. **自检清单**：
   - [ ] 代码是否符合项目规范？
   - [ ] 是否处理了边界情况？
   - [ ] 是否有明显的性能问题？
   - [ ] 注释是否足够？
   - [ ] 是否违反了 process.md 中的"禁止事项"？

### Step 3: 任务完成

```
任务 [task-id] 完成。
变更摘要：[简要说明做了什么]
更新 todolist.csv: task [id] status = done, actual_hours = [N]
下一个任务：[task-id]
```

---

## 错误处理

当遇到问题时：

```markdown
## 问题报告

**任务**：[task-id]
**问题描述**：[遇到什么问题]
**已尝试**：[尝试了什么解决方案]
**需要协助**：[需要人工提供什么信息]

在此任务解决前，切换到下一个无依赖的任务：[task-id]
```

---

## 测试要求

每个任务完成后，执行：

```bash
# 运行相关测试
npm run test -- --testPathPattern=[模块名]

# 类型检查
npm run type-check

# Lint 检查
npm run lint
```

如果测试失败，**不要**更新 status=done，先修复再更新。

---

## 验收标准

- [ ] todolist.csv 中所有 high 优先级任务状态为 done
- [ ] 所有自动化测试通过
- [ ] 类型检查无错误
- [ ] Lint 无错误（或已知豁免）
- [ ] 功能在开发环境可以正常运行

---

## 输出到 Stage 5

将以下内容交给 Stage 5：
- 更新后的 `todolist.csv`（全部 done，含 actual_hours）
- 测试报告
- 功能演示说明（如何验收）

---

## ❓ 常见问题 FAQ

**Q1: 编码过程中发现架构设计有问题怎么办？**  
A: 停止编码，在 process.md 中记录问题，通知人工决策。如果是小问题，在 notes 中记录后继续；如果是根本性问题，可能需要回到 Stage 1 修改架构。

**Q2: 测试一直失败，是否可以跳过？**  
A: 不可以。先在问题报告中记录失败原因，尝试修复。如果确认是已知问题且不影响核心功能，在 notes 中注明"已知问题：[描述]"，由人工决定是否放行。

**Q3: 预估时间远超 actual_hours 怎么办？**  
A: 正常记录即可。这些数据用于后续阶段的估时优化，不是考核工具。

**Q4: 多个 Agent 修改了同一个文件导致冲突？**  
A: 使用 Git 分支隔离策略。如果已经冲突，由人工裁决合并哪个版本，另一个 Agent 基于合并后的代码重做。
