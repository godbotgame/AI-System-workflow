# Windsurf (Codeium) 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: Windsurf 1.x+

---

## Cascade Rules 配置

在项目根目录创建 `.windsurfrules`：

```
你正在参与一个使用 AI Dev Workflow 的项目。

## 核心文件
- 工作流规范：ai-dev-workflow/
- 项目上下文：process.md（必须每次任务前阅读）
- 任务列表：todolist.csv
- 变更日志：CHANGELOG.md

## 执行规则
1. 每次开始前阅读 process.md 了解当前阶段
2. 阅读当前阶段对应的 stage 文件
3. 按 todolist.csv 中的任务顺序执行
4. 完成任务后更新 todolist.csv 状态
5. 重要决策记录到 process.md

## 代码要求
- 提供完整代码，不要省略
- 每次变更附带简短说明
- 遇到不确定的决策，先列方案让人工选择
```

---

## Windsurf 特有能力利用

### 1. Cascade 多步骤编排
Windsurf 的 Cascade 模式可以自动执行多步骤任务，非常适合 Stage 4：

```
请 Cascade 执行以下任务序列：
1. 读取 todolist.csv 找到 status=todo 的第一个任务
2. 阅读相关代码文件
3. 实现该任务
4. 编写测试
5. 运行测试
6. 更新 todolist.csv 状态为 done
7. 继续下一个任务
```

### 2. 多文件编辑
```
请同时修改以下文件：
- src/api/users.ts（添加新接口）
- src/types/user.ts（更新类型定义）
- src/tests/users.test.ts（添加测试）

保持三个文件的类型定义一致。
```

### 3. 上下文感知
```
Windsurf 可以自动索引项目文件。
直接引用 @process.md 和 @todolist.csv 获取上下文。
```

---

## 对话启动模板

```
@process.md @todolist.csv

当前阶段：Stage [N] - [Name]
请阅读 ai-dev-workflow/stages/stage-[N]-xxx.md

本次任务：[具体描述]

开始执行。
```

---

## 适合 Windsurf 的任务

| 任务类型 | 适合度 | 说明 |
|----------|--------|------|
| 多文件编码 | ⭐⭐⭐⭐⭐ | Cascade 模式擅长 |
| 重构 | ⭐⭐⭐⭐ | 自动索引理解代码 |
| 测试 | ⭐⭐⭐⭐ | 可自动运行验证 |
| 架构设计 | ⭐⭐⭐ | 上下文有限 |

---

## 注意事项

- Windsurf 的 Cascade 模式偏向自动化执行，**注意在关键步骤设置确认点**
- 上下文用 `@` 引用文件比手动粘贴更高效
- 复杂任务建议拆分为多个 Cascade 步骤，每步确认后再继续
