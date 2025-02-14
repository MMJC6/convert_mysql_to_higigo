# 数据库迁移实施方案

## 方案概述
本方案采用分阶段渐进式迁移策略，通过双重验证机制确保转换可靠性，主要包含7个核心阶段：
1. 预处理与优先级排序
2. 规则驱动转换
3. 验证反馈机制
4. 迭代优化
5. 最终验证
6. SQL测试生成
7. 结果回写与验证

## 执行核心规则
### 优先级标记规则
```markdown
1. 基础优先级（按行数）：
   - 高优先级：<40行
   - 中优先级：40-80行  
   - 低优先级：>80行

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
- alert_convert_workspace/new_code_blocks/assessmentTaskNotice.sql (new_code_blocks下的文件内容都为空)


### 2. 规则转换阶段
- 根据规则文件rule.md，对alert_convert_workspace文件夹下所有的code_blocks中的文件需要替换的原数据进行转换，顺序为convert_priority_list.csv中的优先级。
- 流程为：根据规则预检查，实施转换流程。
- 输出结果记录到code_blocks_new文件夹下对应的文件，同样以代码块的id命名。需要记录每个代码块的转换日志到logs文件夹下,日志文件名称为文件夹的名称，例如AlertMapper_conversion.md。

### 3. 首次验证阶段
- 根据验证文件valid_convert.md对code_blocks_new文件夹下的文件进行验证，并记录结果。
- 验证结果输出到validResult文件夹中，文件名称为文件夹的名称，例如AlertMapper_conversion.md，验证不通过的文件记录到“复检列表”中。

### 4. 二次转换阶段
```markdown
- **输入**：validResult中的复检列表 + 首次转换结果code_blocks_new
- **优化策略**：
  1. 问题定位分析
  2. 规则权重调整
  3. 直接覆盖式转换
- **特殊处理**：
  - code_blocks_new替换二次转换结果
```



### 6. SQL测试生成
- 输入 code_blocks_new
- **生成规则**：
  1. XML标签清理
  2. 动态变量替换
  3. 语句格式化
- **输出**：
  - testSql文件夹下的对应的文件，文件内容是根据code_blocks_new的文件生成的SQL脚本（*.sql）

```



