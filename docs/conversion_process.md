## 规则转换阶段执行流程

### 执行步骤
1. 从优先级列表读取待转换文件
```bash
python scripts/sql_converter.py
```

2. 生成文件结构：
```
alert_convert_workspace/
├── converted_code_blocks/     # 转换后的SQL文件
│   ├── assessmentTaskNotice.sql
│   └── deleteSameAlert.sql
└── conversion_logs/           # 转换日志
    ├── assessmentTaskNotice_log.md
    └── conversion.log         # 全局日志
```

3. 日志文件格式示例：
```markdown
# Conversion Log - assessmentTaskNotice.sql

**Conversion Time**: 2024-03-20 14:30:00

## Applied Rules
- Replaced UUID() with uuid_generate_v4()
- Converted status values to string

## Validation Results
✅ Passed structure check
⚠️ Warning: Unconverted DATE_FORMAT in line 45
```

### 监控指标
- 转换成功率：`success_count / total_files`
- 规则覆盖率：`applied_rules / total_rules`
- 残留问题：`warnings.log` 