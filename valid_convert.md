# SQL转换验证手册

## 检查清单模板
```markdown
- [ ] 函数替换验证
- [ ] 语句结构验证  
- [ ] 值转换验证
- [ ] 查询结构验证
- [ ] 标识符验证
- [ ] 特殊规则验证
- [ ] UUID转换验证
- [ ] 类型转换白名单验证
- [ ] 别名处理验证
- [ ] 除零异常处理验证
- [ ] REPLACE INTO转换验证
```
## 按照验证清单进行检查，并记录结果。

## 详细检查指南

### 1. 函数替换验证示例
| 检查项 | 验证方法 | 结果 | 示例 |
|-------|---------|------|-----|
| GROUP_CONCAT→string_agg | 检查是否添加分隔符参数 | ✅/⚠️ | `string_agg(id, ',')` |
| DATE_FORMAT→to_char | 验证格式符映射(%Y→YYYY) | ✅/❌ | `to_char(date, 'YYYY-MM-DD')` |
| IF→CASE WHEN | 检查所有IF函数是否转换 | ✅/⚠️ | `CASE WHEN ... THEN ... END` |
| TIMESTAMPDIFF→extract | 验证时间差计算逻辑 | ✅/❌ | `extract(epoch from end - start)/60` |
| UUID转换 | 检查是否添加空字符串连接 | ✅/⚠️ | `uuid_generate_v4() || ''` |
| LOCATE→POSITION | 验证IN语法结构 | ✅/❌ | `POSITION('a' IN col)` |
| 除法运算 | 检查分母是否为0处理 | ✅/⚠️ | `CASE WHEN count=0 THEN NULL ELSE total/count END` |



### 2. 语句结构验证
| 检查项 | 验证方法 | 结果 | 示例 |
|-------|---------|------|-----|
| 多表UPDATE拆分 | 检查是否拆分为多个UPDATE | ✅/❌ | 每个UPDATE单表操作 |
| BETWEEN→IN转换 | 验证字符串范围转换 | ✅/⚠️ | `stage IN ('1','2','3')` |
| HAVING别名处理 | 检查是否使用子查询包装 | ✅/❌ | 外层WHERE过滤 |
| REPLACE INTO | 检查是否转换为DELETE+INSERT或ON CONFLICT | ✅/❌ | 见转换规则7.2 |
| 子查询别名 | 验证是否保留原始层级 | ✅/⚠️ | 禁止添加额外别名层级 |



### 3. 值转换验证
| 检查项 | 验证方法 | 结果 | 示例 |
|-------|---------|------|-----|
| 状态值字符串化 | 检查status字段类型 | ✅/⚠️ | `status='1'` |
| 显式类型转换 | 检查未授权的::转换 | ✅/❌ | `workday::timestamp` |

**正则检查**
```regex
# 检测数值型status
\bstatus\s*=\s*[0-9]
```

### 4. 查询结构验证
| 检查项 | 验证方法 | 结果 | 示例 |
|-------|---------|------|-----|
| GROUP BY完整性 | 检查SELECT与GROUP BY列匹配 | ✅/⚠️ | 包含所有非聚合列 |
| DISTINCT移除 | 检查GROUP BY时DISTINCT存在 | ✅/❌ | 无DISTINCT关键字 |

**验证逻辑**
```mermaid
A[开始] --> B{存在GROUP BY?}
B -->|是| C[检查SELECT列]
C --> D{包含非聚合列?}
D -->|是| E[检查GROUP BY包含]
D -->|否| F[验证通过]
E --> G{完全包含?}
G -->|是| F
G -->|否| H[标记异常]
```


### 5. 结果输出模板
```markdown
## 验证报告

**基本概况**
- 文件：example.sql
- 检查时间：2023-12-20
- 总检查项：38
- 通过率：92.1%

**详细结果**
| 检查类别 | 通过率 | 问题项 |
|---------|-------|--------|
| 函数替换 | 100%  | 无 |
| 语句结构 | 85%   | HAVING别名处理未完成 |
| 值转换 | 100%  | 无 |
| 查询结构 | 90%   | GROUP BY缺失2处 |

**问题详情**
```json
{
  "GROUP_BY_MISSING": {
    "location": "line 45-48",
    "problem": "SELECT包含email未包含在GROUP BY",
    "solution": "添加t.email到GROUP BY子句"
  },
  "ALIAS_SCOPE_VIOLATION": {
    "location": "line 89-92",
    "problem": "错误添加作用域别名au",
    "solution": "移除非法别名前缀",
    "severity": "HIGH",
    "rule_id": "ALIAS-001"
  }
}
```

**验证结论**
[✅] 通过基本验证  
[⚠️] 需要人工复核2处异常

**影响评估**
- 高优先级问题：2处（导致语法错误）
- 中优先级问题：5处（可能影响执行结果）
- 低优先级问题：3处（格式问题）


## 注意事项
1. 转义符检查需保留原始XML实体：
   - `&lt;` → `<`
   - `&gt;` → `>`  









3. 增加XML转义符保留检查：
   ```bash
   # 应保留转义符
   grep -E '&(amp|lt|gt|quot);' converted.sql | wc -l
   # 应等于原文件数量
   ```

