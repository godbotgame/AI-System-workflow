# Codex / ChatGPT 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: GPT-4o / ChatGPT Plus / Codex CLI

> 通过 OpenAI Codex / ChatGPT / GPT-4 执行 AI Dev Workflow 的配置说明

---

## 系统提示词（Custom Instructions）

在 ChatGPT 的 "Custom Instructions" 中设置：

**"What would you like ChatGPT to know about you?"**
```
我使用 AI Dev Workflow 进行大型系统开发。
工作流包含 6 个阶段：项目初始化、架构设计、阶段规划、任务分解、阶段执行、审查交接。
每个阶段有明确的输入和输出。
我使用 todolist.csv 跟踪任务，process.md 记录上下文。
```

**"How would you like ChatGPT to respond?"**
```
- 每次开始工作前确认当前阶段和任务
- 代码必须完整，不能用省略号代替代码
- 技术决策给出 2-3 个方案及权衡
- 任务完成后给出 todolist.csv 的更新建议
- 用中文回复，代码和技术术语保持英文
```

---

## API 调用模板（Codex / GPT-4 API）

```python
import openai

system_prompt = """
你是 AI Dev Workflow 的执行代理。

当前项目上下文：
{process_md_content}

当前任务列表：
{todolist_csv_content}

当前阶段：Stage {stage_number} - {stage_name}
"""

user_message = """
请执行以下任务：
{task_description}

完成后，提供：
1. 代码变更（完整代码）
2. 测试方法
3. todolist.csv 状态更新建议
"""

response = openai.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_message}
    ]
)
```

---

## 对话启动模板

```
===== AI Dev Workflow 任务开始 =====

项目：[项目名]
当前阶段：Stage [N] - [阶段名]

项目上下文（来自 process.md）：
---
[粘贴 process.md 内容]
---

当前任务列表（来自 todolist.csv）：
---
[粘贴 todolist.csv 内容]
---

本次任务：
[具体任务描述]

请开始执行。
===================================
```

---

## Codex 特有能力利用

### 适合 Codex / GPT-4 的任务
- **快速代码生成**：函数实现、组件创建
- **代码补全**：填充模板代码
- **格式转换**：JSON → TypeScript 类型、SQL → ORM 模型
- **注释生成**：自动补充代码注释和文档

### 示例：快速生成 API 路由
```
基于以下接口规范，生成 Express.js 路由代码：

接口名：获取用户列表
路径：GET /api/v1/users
参数：page(number), pageSize(number), keyword(string)
返回：{ data: User[], total: number, page: number }

User 类型：{ id: string, name: string, email: string, createdAt: Date }

要求：
- TypeScript
- 错误处理
- 参数验证
- 分页逻辑
```

---

## 注意事项

- GPT-4o 上下文 128K tokens，注意不要贴太多代码
- 每次对话都需要重新提供上下文（没有持久化记忆）
- 复杂任务建议拆分成多个小任务分别对话
- 生成的代码务必人工审查后再使用
