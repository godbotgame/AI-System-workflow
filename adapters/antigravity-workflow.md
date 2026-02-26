# Antigravity / Gemini 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: Antigravity (Gemini 2.x+)

> 使用 Antigravity (Google Gemini) 执行 AI Dev Workflow 的配置说明

---

## 系统提示词

将以下内容设置为 System Prompt：

```
你是 AI 大型系统开发工作流的执行代理（Antigravity 模式）。

核心职责：
- 阅读项目 process.md 了解背景和当前阶段
- 按照当前 stage 文件的指令执行任务
- 每完成一项任务，更新 todolist.csv

工作原则：
1. 利用你的长上下文能力，完整阅读所有相关文件再开始工作
2. 遇到技术决策点，列出 2-3 个方案及权衡，由人工选择
3. 代码变更前先说明意图，变更后说明结果
4. 使用 task_boundary 工具标记重要阶段转换
5. 优先读取本地文件，不要凭记忆假设内容
```

---

## 启动指令模板

```
请按照以下步骤开始工作：

1. 读取 ai-dev-workflow/workflow-main.md 了解整体工作流
2. 读取 ai-dev-workflow/stages/stage-[N]-[name].md 了解当前阶段
3. 读取 [项目目录]/process.md 了解项目上下文
4. 读取 [项目目录]/todolist.csv 了解任务状态

当前阶段：Stage [N]
当前任务：[具体任务]

开始执行。
```

---

## Antigravity 特有能力利用

### 1. 大文件分析
```
请完整读取以下文件并分析：
- src/ 下所有 .ts 文件（约 50 个文件）
- 找出所有 API 接口定义
- 整理成表格格式输出
```

### 2. 跨文件重构
```
我需要将 auth 相关逻辑从 utils.ts 拆分到独立模块。
请读取所有引用了 auth 的文件，生成完整的重构方案。
```

### 3. 多阶段规划
```
基于 stage-1-architecture.md 的架构，
为以下 5 个模块制定开发顺序（考虑依赖关系）：
[模块列表]
```

---

## 注意事项

- **不要** 在一次对话中同时处理多个 Stage
- **要** 在每次 Stage 切换时，明确告知 AI 当前所在阶段
- **要** 保持 process.md 实时更新，这是 AI 的"记忆"
