# Windsurf (Codeium) 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: Windsurf 1.x+

---

## Cascade Rules 配置

在项目根目录创建 `.windsurfrules`：

```text
你正在参与 AI Dev Workflow 项目。

核心文件：
- process.md
- todolist.csv
- ai-dev-workflow/stages/

执行规则：
1. 每次任务前先读取 process.md / todolist.csv
2. 先判断 priority 与 gate_profile
3. 执行状态流：todo -> in-progress -> review -> done
4. 写入 review_status / verify_status / evidence
5. 未满足门禁时禁止 done

门禁要求：
- strict: Red/Green + 任务级 review + 完整验证
- balanced: 至少 1 组失败→通过循环 + 批量 review + 验证
- light: 最小验证 + 抽样 review
```

---

## Cascade 执行模板

```text
请 Cascade 执行以下步骤：
1. 读取 @process.md 与 @todolist.csv
2. 确认 task-id 的 priority 与 gate_profile
3. 将状态更新为 in-progress
4. 按 gate_profile 执行门禁
5. 更新为 review，写入证据
6. review 通过后更新为 done
```

---

## 多文件编辑模板

```text
请同时修改以下文件并保持一致：
- src/api/users.ts
- src/types/user.ts
- src/tests/users.test.ts

并输出：
- gate_profile
- 执行的门禁项
- review_status / verify_status / evidence
```

---

## 注意事项

- Cascade 自动化前必须先判断 gate_profile
- strict 任务不建议无确认地连续自动执行
- 完成声明必须带证据，不能只写“已完成”
