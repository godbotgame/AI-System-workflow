# Stage 1: 架构设计

**输入**：技术栈选型结果、项目需求文档  
**输出**：系统架构图、模块划分文档、数据库设计、API 合约  

---

## 执行步骤

### Step 1: 系统架构设计

生成系统架构描述：

```markdown
## 系统架构

### 整体架构
[描述前后端分离/微服务/单体等架构模式]

### 模块划分
- 模块 A：[职责描述]
- 模块 B：[职责描述]
- 模块 C：[职责描述]

### 模块依赖关系
A → B（A 依赖 B）
B → C
（画出依赖图）

### 技术分层
[前端] → [API Gateway] → [业务服务] → [数据层]
```

### Step 2: 数据库设计

为每个核心实体生成 ER 模型：

```sql
-- 示例：用户系统
CREATE TABLE users (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username    VARCHAR(50) UNIQUE NOT NULL,
  email       VARCHAR(255) UNIQUE NOT NULL,
  created_at  TIMESTAMP DEFAULT NOW(),
  updated_at  TIMESTAMP DEFAULT NOW()
);

-- [继续添加其他表...]
```

同时生成 TypeScript/ORM 类型定义：

```typescript
interface User {
  id: string
  username: string
  email: string
  createdAt: Date
  updatedAt: Date
}
```

### Step 3: API 合约设计

为每个模块定义核心 API：

```yaml
# api-contract.yaml

openapi: "3.0.0"
info:
  title: "[项目名] API"
  version: "1.0.0"

paths:
  /api/v1/users:
    get:
      summary: 获取用户列表
      parameters:
        - name: page
          in: query
          schema:
            type: integer
      responses:
        "200":
          description: 成功
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/UserList"
```

### Step 4: 技术决策记录（ADR）

对每个重要技术决策，记录：

```markdown
## ADR-001: [决策标题]

**状态**：已接受

**背景**：
[为什么需要做这个决策]

**决策**：
[具体决定是什么]

**后果**：
- 好处：[好处]
- 坏处：[坏处/权衡]
```

---

## 验收标准

- [ ] 系统架构图已创建（可以是文字描述 + ASCII 图）
- [ ] 所有核心模块已识别并划分职责
- [ ] 模块间依赖关系已梳理（无循环依赖）
- [ ] 核心数据表设计完成
- [ ] 主要 API 接口已定义
- [ ] 重要技术决策已记录 ADR

---

## 输出到下一阶段

完成此阶段后，将以下输出交给 Stage 2：
- 模块列表（含依赖关系）
- 数据库 Schema
- API 合约文档
