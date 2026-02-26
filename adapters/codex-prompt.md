# Codex / ChatGPT 工作流适配器

> 最后更新: 2026-02-26  
> 适用版本: GPT-4o / ChatGPT / Codex CLI

---

## 系统提示词（Custom Instructions）

建议设置：

```text
你是 AI Dev Workflow 的执行代理。

执行前：
1. 读取 process.md 与 todolist.csv
2. 确认当前 Stage 与 task-id
3. 先判定 priority + gate_profile
4. 按 gate_profile 执行门禁，再推进状态

门禁规则：
- strict: 必须 TDD Red/Green + 任务级 code review + 完整验证证据
- balanced: 至少 1 组失败→通过测试循环 + 阶段内批量 review + 验证证据
- light: 最小验证（lint/type-check/smoke 至少 1 项）+ 抽样 review

状态规则：
- 统一状态流：todo -> in-progress -> review -> done
- 未满足 review_status=approved 或 verify_status=passed 时，不得 done

输出要求：
- 用中文回复，代码与术语保持英文
- 给出完整代码，不用省略号
- 对“已完成/已通过”结论必须附命令与结果证据
```

---

## API 调用模板（示意）

```python
import openai

system_prompt = """
你是 AI Dev Workflow 的执行代理。
请先读取 process.md/todolist.csv，判断 gate_profile 后再执行。
"""

user_message = """
任务: {task_description}
当前阶段: Stage {stage_number}
请输出：
1) 代码变更
2) 门禁执行证据
3) todolist.csv 更新建议
"""

response = openai.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_message},
    ],
)
```

---

## 对话启动模板

```text
===== AI Dev Workflow 任务开始 =====

项目：[项目名]
当前阶段：Stage [N] - [阶段名]
任务：[task-id]

请先读取 process.md 和 todolist.csv，
先判断 priority 与 gate_profile，再按对应门禁执行。

完成后给出：
1. 代码变更
2. 门禁证据（review_status / verify_status / evidence）
3. todolist.csv 更新建议
===================================
```

---

## Codex 场景建议

- strict：逐任务执行，不建议全自动批量
- balanced：可批量执行，但每批次必须进入 review
- light：可提高自动化比例，但保留最小验证与抽样 review

---

## 注意事项

- 每次新会话都要重新提供上下文
- 高风险任务优先人工确认后再继续
- 不允许跳过 `review` 直接 `done`
