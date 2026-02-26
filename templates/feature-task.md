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
| 状态 | todo → in-progress → done |
| 负责工具 | AI (Cursor / Codex / Claude) |

---

## 任务描述

[清晰描述要实现的功能，包含：]
- 功能目标
- 用户故事（可选）：作为 [用户]，我想要 [动作]，以便 [目的]

---

## 验收标准

- [ ] [可测试的标准1]
- [ ] [可测试的标准2]
- [ ] 相关单元测试通过
- [ ] 无 TypeScript 错误

---

## 技术要求

### 涉及文件
- `src/[path]/[file].ts` - [说明]
- `src/[path]/[file].test.ts` - [说明]

### 接口签名（如适用）
```typescript
// 函数/API 接口定义
interface [InterfaceName] {
  [field]: [type]
}

function [functionName](params: [ParamsType]): [ReturnType]
```

### 依赖关系
- 前置任务：[task-id]（必须先完成）
- 被依赖：[task-id]（完成后解锁）

---

## 实现笔记

> AI 在实现过程中填写此部分

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
| 测试结果 | [通过/失败] |
| 代码文件 | [变更的主要文件] |
