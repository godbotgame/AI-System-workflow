🚀 Step 1：初始化项目
bash
# 假设你有一个新项目 my-app
mkdir my-app && cd my-app
bash /path/to/ai-dev-workflow/scripts/init.sh my-app
这会在项目根目录生成 

process.md
、

todolist.csv
、CHANGELOG.md 等文件。

🔧 Step 2：配置 Codex
Codex 使用 AGENTS.md 文件作为其系统指令（类似 Cursor 的 .cursorrules）。在项目根目录创建：

bash
touch AGENTS.md
然后把 

adapters/codex-prompt.md
 中的系统提示词写进去。核心内容类似：

markdown
# AGENTS.md
你是 AI Dev Workflow 的执行代理。
## 核心文件
- 工作流规范：ai-dev-workflow/
- 项目上下文：process.md（每次任务前必须阅读）
- 任务列表：todolist.csv
- 变更日志：CHANGELOG.md
## 执行规则
1. 每次开始前阅读 process.md 了解当前阶段
2. 阅读当前阶段对应的 stage 文件
3. 按 todolist.csv 中的任务顺序执行
4. 完成任务后更新 todolist.csv 状态为 done
5. 重要决策记录到 process.md
6. 不要跨阶段执行任务
7. 遇到不确定的决策，先列方案让人工选择
8. 代码必须完整，不能用省略号代替
📋 Step 3：按阶段使用 Codex
Stage 0 - 项目初始化
bash
codex "请阅读 ai-dev-workflow/stages/stage-0-project-init.md，然后帮我完成技术栈选型。项目需求是：[你的需求描述]"
Stage 1 - 架构设计
bash
codex "请阅读 ai-dev-workflow/stages/stage-1-architecture.md 和 process.md，为项目设计系统架构，包括模块划分、数据库设计和 API 合约。"
Stage 2 - 阶段规划
bash
codex "请阅读 ai-dev-workflow/stages/stage-2-phase-planning.md 和 process.md，根据 Stage 1 的模块划分，制定 3-5 个开发阶段的规划。"
Stage 3 - 任务分解（循环开始）
bash
codex "请阅读 ai-dev-workflow/stages/stage-3-task-decomposition.md 和 process.md。当前进入阶段 1，请将阶段 1 的模块分解为具体任务，填写到 todolist.csv。"
Stage 4 - 执行编码（Codex 最擅长的！）
bash
# 方式 1：让 Codex 自动认领下一个任务
codex "请阅读 todolist.csv，找到第一个 status=todo 的任务，执行它。完成后更新 todolist.csv。"
# 方式 2：指定某个任务
codex "请执行 todolist.csv 中的任务 003：实现 JWT 鉴权中间件。参考 process.md 中的技术栈和约定。"
# 方式 3：批量执行（Codex 支持自动模式）
codex --full-auto "请依次执行 todolist.csv 中所有 status=todo 的任务，每完成一个更新状态。"
Stage 5 - 审查
bash
codex "请阅读 ai-dev-workflow/stages/stage-5-review-handoff.md，对当前阶段的代码进行自动审查，生成审查报告。"
💡 Codex 使用的关键技巧
1. 利用 --full-auto 模式
Codex 的全自动模式适合 Stage 4 批量执行任务，但要注意：

建议只对 medium/low 优先级的任务用 full-auto
high 优先级任务建议逐个确认
2. 每次对话带上上下文
Codex 没有持久记忆，所以每次调用都要引导它读文件：

bash
codex "先读取 process.md 和 todolist.csv，然后 [你的具体指令]"
3. 搭配其他工具
参考 

agent-routing.md
 中的建议：

阶段	用 Codex	用其他工具
Stage 0-2	❌ 规划不是它强项	✅ 用 Claude/Antigravity
Stage 3	⚠️ 可以用	✅ Claude 更擅长结构化分解
Stage 4	✅ 主力	Copilot 辅助补全
Stage 5	⚠️ 可以跑自动检查	✅ Claude 做深度审查
📌 一个完整的 Codex 会话示例
bash
# 1. 初始化
bash ai-dev-workflow/scripts/init.sh my-app
# 编辑 process.md 填写项目信息...
# 2. Stage 0: 技术选型（建议用 Claude，但 Codex 也行）
codex "读取 ai-dev-workflow/stages/stage-0-project-init.md，我要做一个任务管理系统，Vue 3 + Node.js + PostgreSQL，帮我完成技术栈选型并更新 process.md"
# 3. Stage 1: 架构设计
codex "读取 stage-1-architecture.md 和 process.md，设计系统架构 + DB schema + API 合约"
# 4. Stage 2: 阶段规划
codex "读取 stage-2-phase-planning.md，规划开发阶段"
# 5. Stage 3: 任务分解（阶段 1）
codex "读取 stage-3-task-decomposition.md，分解阶段 1 的任务到 todolist.csv"
# 6. Stage 4: 逐个执行任务
codex "读取 todolist.csv，执行任务 001"
codex "读取 todolist.csv，执行任务 002"
# ...或者批量
codex --full-auto "执行 todolist.csv 中阶段 1 所有 todo 任务"
# 7. Stage 5: 审查
codex "运行 npm test && npm run lint，生成阶段审查报告"