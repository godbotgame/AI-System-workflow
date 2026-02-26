# Stage 0: 项目初始化

**输入**：项目需求文档（PRD）或需求描述  
**输出**：技术栈决策、项目脚手架、初始化的 `process.md`  

---

## 执行步骤

### Step 1: 需求澄清

将以下问题提给人工确认：

```markdown
在开始项目前，请确认以下信息：

**业务需求**
- [ ] 核心用户场景是什么？
- [ ] 预期用户规模？（DAU/MAU）
- [ ] 性能要求？（响应时间、并发数）

**技术约束**
- [ ] 是否有指定技术栈？
- [ ] 需要支持哪些平台？（Web/Mobile/Desktop）
- [ ] 是否有现有系统需要集成？

**项目约束**
- [ ] 预期交付时间？
- [ ] 团队规模和技术背景？
- [ ] 预算约束？
```

### Step 2: 技术栈选型

根据确认的需求，生成技术选型报告：

```markdown
## 技术栈选型报告

### 前端
- 推荐：[框架] + [UI库] + [状态管理]
- 原因：[理由]
- 备选：[备选方案]

### 后端
- 推荐：[语言/框架] + [数据库]
- 原因：[理由]

### 部署
- 推荐：[云服务/容器方案]
- CI/CD：[方案]
```

### Step 3: 项目脚手架

执行以下命令初始化项目：

```bash
# 根据选型的技术栈执行，例如 Vue + Node.js

# 前端
npm create vite@latest [project-name]-web -- --template vue-ts
cd [project-name]-web && npm install

# 后端
mkdir [project-name]-api && cd [project-name]-api
npm init -y
npm install express typescript @types/node

# 初始化 git
git init && git add . && git commit -m "chore: project init"
```

### Step 4: 创建 process.md

在项目根目录创建 `process.md`（从模板复制并填写）：

```bash
cp ai-dev-workflow/templates/process.md ./process.md
cp ai-dev-workflow/templates/todolist.csv ./todolist.csv
```

---

## 验收标准

- [ ] 技术栈已确认并记录在 `process.md`
- [ ] 项目目录结构已创建
- [ ] 代码仓库已初始化（git）
- [ ] `process.md` 已填写项目基本信息
- [ ] 开发环境可以正常运行

---

## 输出到下一阶段

完成此阶段后，将以下内容交给 Stage 1：
- 确认的技术栈
- 项目目录结构
- 初始化的 `process.md`
