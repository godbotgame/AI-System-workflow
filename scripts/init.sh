#!/bin/bash
# AI Dev Workflow - 项目初始化脚本
# 用法: bash ai-dev-workflow/scripts/init.sh [项目名称]

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_NAME="${1:-my-project}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${BLUE}🚀 AI Dev Workflow 项目初始化${NC}"
echo "=================================="
echo -e "项目名称: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "工作流目录: ${SCRIPT_DIR}"
echo ""

# 1. 复制模板文件到当前目录
echo -e "${YELLOW}[1/5]${NC} 复制 process.md 模板..."
if [ -f "./process.md" ]; then
  echo "  ⚠️  process.md 已存在，跳过"
else
  cp "${SCRIPT_DIR}/templates/process.md" ./process.md
  # 替换项目名
  sed -i.bak "s/\[项目名\]/${PROJECT_NAME}/g" ./process.md && rm -f ./process.md.bak
  echo "  ✅ process.md 已创建"
fi

echo -e "${YELLOW}[2/5]${NC} 复制 todolist.csv 模板..."
if [ -f "./todolist.csv" ]; then
  echo "  ⚠️  todolist.csv 已存在，跳过"
else
  # 只复制表头，不复制示例数据
  head -1 "${SCRIPT_DIR}/templates/todolist.csv" > ./todolist.csv
  echo "  ✅ todolist.csv 已创建（仅表头）"
fi

echo -e "${YELLOW}[3/5]${NC} 复制 changelog.md 模板..."
if [ -f "./CHANGELOG.md" ]; then
  echo "  ⚠️  CHANGELOG.md 已存在，跳过"
else
  cp "${SCRIPT_DIR}/templates/changelog.md" ./CHANGELOG.md
  sed -i.bak "s/\[项目名\]/${PROJECT_NAME}/g" ./CHANGELOG.md && rm -f ./CHANGELOG.md.bak
  echo "  ✅ CHANGELOG.md 已创建"
fi

# 2. 创建任务目录
echo -e "${YELLOW}[4/5]${NC} 创建 tasks/ 目录..."
mkdir -p ./tasks
echo "  ✅ tasks/ 目录已创建"

# 3. 生成 .cursorrules
echo -e "${YELLOW}[5/5]${NC} 生成 AI 工具配置文件..."

if [ ! -f "./.cursorrules" ]; then
cat > ./.cursorrules << 'CURSOR_EOF'
你正在参与一个使用 AI Dev Workflow 的项目。

工作流文档：ai-dev-workflow/
项目上下文：process.md
任务列表：todolist.csv
变更日志：CHANGELOG.md

执行代码时：
1. 先读取 process.md 了解项目背景和当前阶段
2. 读取当前阶段的 stage 文件确认任务要求
3. 检查 todolist.csv 了解任务状态
4. 完成后更新 todolist.csv 状态为 done
5. 重要决策记录到 process.md

禁止事项：
- 不要跨阶段执行任务
- 遇到不确定的决策，先列出方案让人工选择
- 不要省略代码（用 ... 代替）
CURSOR_EOF
  echo "  ✅ .cursorrules 已创建"
else
  echo "  ⚠️  .cursorrules 已存在，跳过"
fi

# 生成 GitHub Copilot 指令（如果不存在）
if [ ! -f "./.github/copilot-instructions.md" ]; then
  mkdir -p ./.github
cat > ./.github/copilot-instructions.md << 'COPILOT_EOF'
# Copilot Instructions

This project uses **AI Dev Workflow** for structured development.

## Key Files
- `process.md` - Project context and current stage
- `todolist.csv` - Task list with status tracking
- `ai-dev-workflow/` - Workflow documentation

## Rules
- Follow the current stage instructions
- Update todolist.csv after completing each task
- Record important decisions in process.md
- Provide complete code, never use ellipsis
COPILOT_EOF
  echo "  ✅ .github/copilot-instructions.md 已创建"
else
  echo "  ⚠️  .github/copilot-instructions.md 已存在，跳过"
fi

echo ""
echo "=================================="
echo -e "${GREEN}✅ 初始化完成！${NC}"
echo ""
echo "下一步："
echo "  1. 编辑 process.md 填写项目详细信息"
echo "  2. 打开 ai-dev-workflow/stages/stage-0-project-init.md 开始 Stage 0"
echo "  3. 选择你的 AI 工具，参考 ai-dev-workflow/agent-routing.md"
