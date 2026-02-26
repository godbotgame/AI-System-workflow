# 主工作流编排 (Workflow Main)

> 这是 AI Dev Workflow 的指挥文档。每次启动项目，将此文件与项目的 `process.md`、`todolist.csv` 一起提供给 AI。

---

## 系统提示词（System Prompt）

以下内容可直接作为 System Prompt 初始化任意 AI 工具：

```text
你是 AI 大型系统开发工作流的执行代理。

你的工作方式：
1. 每次开始先读取 process.md 和 todolist.csv
2. 按当前 Stage 指南执行，不跨阶段
3. 先判定当前任务 gate_profile，再按门禁强度执行
4. 任务完成前必须进入 review 状态并完成验证
5. 只有 review_status=approved 且 verify_status=passed 才能标记 done

规则：
- 优先遵循 skill-first（先确认需要的过程技能，再执行编码）
- 遇到不确定技术决策，先列出 2-3 个方案让人工选择
- 任何“已完成/已通过”结论都要附最新验证证据
- 记录关键决策到 process.md
```

---

## Gate Profile 规则

默认映射：
- `high -> strict`
- `medium -> balanced`
- `low -> light`

可在 `todolist.csv` 手动覆写 `gate_profile`（例如将高风险 medium 上调为 strict）。

状态机：`todo -> in-progress -> review -> done`

---

## 工作流状态机

```text
[项目启动]
    |
    v
[Stage 0: 项目初始化] -> [Stage 1: 架构设计]
                              |
                              v
                      [Stage 2: 阶段规划]
                              |
                              v
                  +---- [当前阶段 N] ----+
                  |                      |
                  v                      |
          [Stage 3: 任务分解]            |
                  |                      |
                  v                      |
          [Stage 4: 阶段执行]            |
                  |                      |
                  v                      |
          [Stage 5: 审查交接] --未通过----+
                  |
               通过且有下一阶段
                  |
                  +--> 回到 Stage 3（下一阶段）

         全部阶段完成 -> 项目交付
```

---

## 每次对话启动模板

```text
项目：[项目名称]
当前阶段：Stage [N] - [阶段名称]
本次目标：[具体任务描述]

请阅读后开始：
1. stages/stage-[N]-[name].md
2. process.md
3. todolist.csv

并先给出：
- 本任务 gate_profile 判断
- 对应门禁执行清单
```

---

## 阶段完成检查清单

- [ ] `todolist.csv` 所有目标任务为 `done`
- [ ] 所有目标任务 `review_status=approved`
- [ ] 所有目标任务 `verify_status=passed`
- [ ] `evidence` 可复核
- [ ] `process.md` 已更新
- [ ] 人工验收通过
