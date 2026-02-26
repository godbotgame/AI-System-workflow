#!/bin/bash
# AI Dev Workflow - 项目初始化脚本
# 用法: bash ai-dev-workflow/scripts/init.sh [项目名称]

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_NAME="${1:-my-project}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

printf "${BLUE}🚀 AI Dev Workflow 项目初始化${NC}\n"
printf "==================================\n"
printf "项目名称: ${GREEN}%s${NC}\n" "${PROJECT_NAME}"
printf "工作流目录: %s\n\n" "${SCRIPT_DIR}"

printf "${YELLOW}[1/7]${NC} 复制 process.md 模板...\n"
if [ -f "./process.md" ]; then
  echo "  ⚠️  process.md 已存在，跳过"
else
  cp "${SCRIPT_DIR}/templates/process.md" ./process.md
  sed -i.bak "s/\[项目名\]/${PROJECT_NAME}/g" ./process.md && rm -f ./process.md.bak
  echo "  ✅ process.md 已创建"
fi

printf "${YELLOW}[2/7]${NC} 复制 todolist.csv 模板...\n"
if [ -f "./todolist.csv" ]; then
  echo "  ⚠️  todolist.csv 已存在，跳过"
else
  head -1 "${SCRIPT_DIR}/templates/todolist.csv" > ./todolist.csv
  echo "  ✅ todolist.csv 已创建（仅表头，含 gate_profile/review_status/verify_status/evidence）"
fi

printf "${YELLOW}[3/7]${NC} 复制 changelog.md 模板...\n"
if [ -f "./CHANGELOG.md" ]; then
  echo "  ⚠️  CHANGELOG.md 已存在，跳过"
else
  cp "${SCRIPT_DIR}/templates/changelog.md" ./CHANGELOG.md
  sed -i.bak "s/\[项目名\]/${PROJECT_NAME}/g" ./CHANGELOG.md && rm -f ./CHANGELOG.md.bak
  echo "  ✅ CHANGELOG.md 已创建"
fi

printf "${YELLOW}[4/7]${NC} 创建 tasks/ 目录...\n"
mkdir -p ./tasks
echo "  ✅ tasks/ 目录已创建"

printf "${YELLOW}[5/7]${NC} 生成 .cursorrules...\n"
if [ ! -f "./.cursorrules" ]; then
cat > ./.cursorrules << 'CURSOR_EOF'
你正在参与一个使用 AI Dev Workflow 的项目。

核心文件：
- process.md
- todolist.csv
- ai-dev-workflow/stages/

执行规则：
1. 每次任务前先读取 process.md 和 todolist.csv
2. 先判断 priority 与 gate_profile，再开始编码
3. 任务状态必须按 todo -> in-progress -> review -> done 流转
4. 未满足 review_status=approved 和 verify_status=passed 时，不得 done
5. 所有完成声明必须附 evidence（命令 + 结果摘要）
CURSOR_EOF
  echo "  ✅ .cursorrules 已创建"
else
  echo "  ⚠️  .cursorrules 已存在，跳过"
fi

printf "${YELLOW}[6/7]${NC} 生成 AGENTS.md...\n"
if [ ! -f "./AGENTS.md" ]; then
cat > ./AGENTS.md << 'AGENTS_EOF'
# AGENTS.md

你是 AI Dev Workflow 执行代理。

## 必读文件
- process.md
- todolist.csv
- ai-dev-workflow/stages/

## 执行规范
1. 先判断 priority 与 gate_profile
2. 按门禁执行，再更新状态
3. 状态流固定：todo -> in-progress -> review -> done
4. review_status=approved 且 verify_status=passed 才可 done
5. 所有“已完成/已通过”结论必须附 evidence

## Gate Profile
- strict: TDD Red/Green + 任务级 code review + 完整验证
- balanced: 至少 1 组失败->通过测试循环 + 批量 review + 验证
- light: 最小验证（lint/type-check/smoke >=1）+ 抽样 review
AGENTS_EOF
  echo "  ✅ AGENTS.md 已创建"
else
  echo "  ⚠️  AGENTS.md 已存在，跳过"
fi

printf "${YELLOW}[7/7]${NC} 生成 .github/copilot-instructions.md...\n"
if [ ! -f "./.github/copilot-instructions.md" ]; then
  mkdir -p ./.github
cat > ./.github/copilot-instructions.md << 'COPILOT_EOF'
# Copilot Instructions

This project uses AI Dev Workflow with risk-based gates.

- Determine gate_profile before implementation.
- Follow status flow: todo -> in-progress -> review -> done.
- Do not mark done before review_status=approved and verify_status=passed.
- Always include evidence (commands + output summary).
COPILOT_EOF
  echo "  ✅ .github/copilot-instructions.md 已创建"
else
  echo "  ⚠️  .github/copilot-instructions.md 已存在，跳过"
fi

echo ""
printf "==================================\n"
printf "${GREEN}✅ 初始化完成！${NC}\n\n"
echo "下一步："
echo "  1. 编辑 process.md 填写项目信息"
echo "  2. 打开 ai-dev-workflow/stages/stage-0-project-init.md"
echo "  3. 在 todolist.csv 为任务设置 priority 与 gate_profile"
echo "  4. high 任务优先创建 tasks/[id]-[task-name].md"
