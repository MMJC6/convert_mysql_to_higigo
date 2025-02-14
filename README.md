# 数据库迁移实施方案

## 方案概述

本方案采用分阶段渐进式迁移策略，通过双重验证机制确保转换可靠性，主要包含 7 个核心阶段：

1. 预处理与优先级排序
2. 规则驱动转换
3. 验证反馈机制
4. 迭代优化
5. 最终验证
6. SQL 测试生成
7. 结果回写与验证

## 执行核心规则

### 优先级标记规则

```markdown
1. 基础优先级（按行数）：

   - 高优先级：<40 行
   - 中优先级：40-80 行
   - 低优先级：>80 行

2. 函数检测提升规则：

   - 检测到任意转换函数 → 提升至最少中优先级
   - 检测到多个函数/复杂结构 → 强制高优先级

3. 最终优先级判定：
   Final Priority = max(基础优先级, 函数检测优先级)
```

## 详细实施步骤

### 1. 预处理阶段

#### 使用脚本文件 /scripts/xml_preprocessor.py

#### 示例命令：`./scripts/xml_preprocessor.py alert`

#### 示例输出结果

- alert_convert_workspace/code_blocks/assessmentTaskNotice.sql
- alert_convert_workspace/convert_priority_list.csv
- alert_convert_workspace/new_code_blocks/assessmentTaskNotice.sql (new_code_blocks 下的文件内容都为空)

### 2. 规则转换阶段

- 根据规则文件 /rule.md，对 alert_convert_workspace/AlertMapper_conversion/code_blocks 文件夹下所有的文件需要替换的原数据进行转换，顺序为 AlertMapper_conversion/convert_priority_list.csv 中的优先级。
- 流程为：根据 rule.md 中的规则预检查，实施转换流程，严格按照 rule.md 执行转换。
- 输出结果记录到 alert_convert_workspace/AlertMapper_conversion/code_blocks_new 文件夹下对应的文件，同样以代码块的 id 命名。需要记录每个代码块的转换日志到 logs 文件夹下,日志文件名称为文件夹的名称，例如 log_conversion.md。

### 3. 首次验证阶段

- 根据验证文件 /valid_convert.md 对 alert_convert_workspace/AlertMapper_conversion/code_blocks_new 文件夹下的文件进行验证，并记录结果。
- 验证结果输出到 alert_convert_workspace/AlertMapper_conversion/valid_result.md 文件中，最末尾需要有 “复检列表”一栏，验证不通过的文件记录到“复检列表”中。

### 4. 二次转换阶段

```markdown
- **输入**：validResult.md 中的复检列表和对应的详细结果 + 首次转换结果 code_blocks_new
- **优化策略**：
  1. 问题定位分析
  2. 规则权重调整
  3. 直接覆盖式转换
  4. 生成转换错误日志，包括原因和解决方案，记录到 alert_convert_workspace/AlertMapper_conversion/valid_error_log.md 中
- **特殊处理**：
  - code_blocks_new 替换二次转换结果
```

### 5. SQL 测试语句生成

- 输入 code_blocks_new
- **生成规则**：
  1. XML 标签清理
  2. 动态变量替换
  3. 语句格式化
- **输出**：
  - testSql 文件夹下的对应的文件，文件内容是根据 code_blocks_new 的文件生成的 SQL 脚本（\*.sql）

### 6. 转换结果回写

- 将 alert_convert_workspace/new_code_blocks/code_blocks_new中每个文件的内容 回写到对应的 xml 文件中。
- 按照文件名称找到对应关系，如 assessmentTaskNotice.sql 的内容需要回写到 alert/AlertMapper.xml 中的<select id="assessmentTaskNotice">标签中。
- 注意sql语句中的< > 等在xml中应该替换为转义字符对应的 &lt; &gt; &amp;
