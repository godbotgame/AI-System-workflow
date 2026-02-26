# Claude 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: Claude 3.5+ / Cursor 0.40+

> 通过 Claude (claude.ai / API / Cursor 内置) 执行 AI Dev Workflow 的配置说明

---

## 系统提示词

```
<role>
你是一个严格遵循工作流的 AI 开发代理。你使用 AI Dev Workflow 规范来协助大型系统开发。
</role>

<workflow>
当前工作流：AI 大型系统开发工作流
文档位置：ai-dev-workflow/

你必须：
1. 每次对话开始时，确认当前 Stage 和任务
2. 严格按照 stage 文件的步骤执行
3. 完成每个任务后更新 todolist.csv
4. 遇到模糊需求，主动澄清而不是假设
</workflow>

<output_format>
- 代码变更：提供完整代码，不要省略
- 技术决策：列出选项 + 推荐 + 理由
- 任务状态：每次任务完成后报告进度
</output_format>
```

---

## Cursor Rules 配置

在项目根目录创建 `.cursorrules`：

```
你正在参与一个使用 AI Dev Workflow 的项目。

工作流文档：ai-dev-workflow/
当前阶段规范：ai-dev-workflow/stages/stage-[N]-[name].md
项目上下文：process.md
任务列表：todolist.csv

执行代码时：
1. 先读取相关 stage 文件确认当前任务
2. 检查 todolist.csv 了解任务状态
3. 完成后更新 todolist.csv 状态为 done
4. 重要决策记录到 process.md
```

---

## 对话启动模板

```xml
<context>
项目：[项目名]
阶段：Stage [N] - [阶段名]
任务：[当前任务描述]
</context>

<files>
请先读取以下文件：
1. ai-dev-workflow/stages/stage-[N]-[name].md
2. process.md
3. todolist.csv
</files>

<request>
[具体请求]
</request>
```

---

## Claude 特有能力利用

### 适合 Claude 的任务
- **架构文档**：条理清晰，适合生成 ADR（架构决策记录）
- **代码审查**：理解代码意图，提出改进点
- **API 设计**：RESTful / GraphQL 接口设计
- **测试策略**：单测、集测的方案设计

### 示例：架构审查请求
```
请审查以下架构方案，从以下维度评估：
1. 可扩展性
2. 可维护性  
3. 性能风险
4. 与现有系统的兼容性

[架构描述]
```

---

## 注意事项

- Claude 的上下文窗口约 200K tokens，超大项目需要分批处理
- 每次新对话需要重新提供上下文，建议保持 process.md 简洁准确
- Cursor 集成模式下，Claude 可以直接读取本地文件，无需手动粘贴
