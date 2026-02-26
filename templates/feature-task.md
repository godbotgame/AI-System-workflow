# 功能任务模板 (Feature Task Template)

> 为每个功能任务创建一个此文件，放在 `tasks/[task-id]-[task-name].md`

---

## 任务信息

| 字段 | 内容 |
|------|------|
| 任务 ID | [从 todolist.csv 对应的 id] |
| 阶段 | Phase [N] |
| 模块 | [module 名称] |
| 优先级 | high / medium / low |
| Gate Profile | strict / balanced / light |
| 状态 | todo → in-progress → review → done |
| 负责工具 | AI (Cursor / Codex / Claude) |

> 默认映射：`high -> strict`、`medium -> balanced`、`low -> light`。特殊任务可手动覆写 `gate_profile`。

---

## 任务描述

[清晰描述要实现的功能，包含：]
- 功能目标
- 用户故事（可选）：作为 [用户]，我想要 [动作]，以便 [目的]

---

## 验收标准

- [ ] [可测试的标准1]
- [ ] [可测试的标准2]
- [ ] 已完成对应 gate_profile 的门禁要求
- [ ] 相关自动化验证通过

---

## 技术要求

### 涉及文件
- `src/[path]/[file].ts` - [说明]
- `src/[path]/[file].test.ts` - [说明]

### 接口签名（如适用）
```typescript
interface [InterfaceName] {
  [field]: [type]
}

function [functionName](params: [ParamsType]): [ReturnType]
```

### 依赖关系
- 前置任务：[task-id]（必须先完成）
- 被依赖：[task-id]（完成后解锁）

---

## 分级证据区块（必填）

### strict（high）
- RED 证据（失败测试命令 + 失败摘要）：
- GREEN 证据（通过测试命令 + 通过摘要）：
- 任务级代码评审结论（critical/important=0）：
- 完整验证证据（test/type-check/lint/build）：

### balanced（medium）
- 至少 1 组失败→通过测试循环证据：
- 阶段内批量评审结论：
- 验证证据（至少 2 项，如 test + type-check）：

### light（low）
- 最小验证证据（lint / type-check / smoke 至少 1 项）：
- 抽样评审记录：

---

## 实现笔记

### 实现思路
[简述实现方案]

### 关键决策
- [决策1]：[选择方案及理由]

### 遇到的问题
- [问题描述] → [解决方案]

---

## 完成记录

| 字段 | 内容 |
|------|------|
| 完成时间 | YYYY-MM-DD HH:mm |
| 执行工具 | [AI 工具名] |
| gate_profile | [strict/balanced/light] |
| review_status | [approved/changes-requested] |
| verify_status | [passed/failed] |
| 代码文件 | [变更的主要文件] |
