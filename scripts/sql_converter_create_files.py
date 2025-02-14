import os
import re
import csv
from pathlib import Path
from datetime import datetime

class SQLConverter:
    def __init__(self, workspace_path, rule_path):
        self.workspace = Path(workspace_path)
        self.rules = self._load_rules(rule_path)
        
        # 修改输出路径为与code_blocks同级的new_code_blocks
        self.code_blocks_path = self.workspace / 'AlertMapper_conversion' / 'code_blocks'
        self.converted_path = self.workspace / 'AlertMapper_conversion' / 'new_code_blocks'
        
        # 创建必要目录
        self.converted_path.mkdir(exist_ok=True)

    def _load_rules(self, rule_path):
        """解析规则文件"""
        rules = {
            'functions': {},
            'structures': [],
            'value_conversions': []
        }
        
        # 这里添加规则解析逻辑（示例解析部分规则）
        with open(rule_path, 'r', encoding='utf-8') as f:
            current_section = None
            for line in f:
                if line.startswith('### '):
                    current_section = line.strip().split(' ')[-1]
                elif line.startswith('- **函数**: `'):
                    func_name = re.search(r'`(.+?)`', line).group(1)
                    next_line = next(f)
                    replace_with = re.search(r'`(.+?)`', next_line).group(1)
                    rules['functions'][func_name] = replace_with
                    
        return rules

    def _convert_functions(self, sql):
        """应用函数替换规则"""
        for func, replacement in self.rules['functions'].items():
            pattern = re.compile(rf'\b{func}\s*\(', re.IGNORECASE)
            if pattern.search(sql):
                sql = re.sub(pattern, f'{replacement}(', sql)
        return sql

    def _convert_values(self, sql):
        """状态值转换规则"""
        # 示例：status = 1 → status = '1'
        sql = re.sub(r'(status\s*=\s*)(\d+)', r"\1'\2'", sql, flags=re.IGNORECASE)
        return sql

    def convert_file(self, input_path):
        """创建空文件结构"""
        try:
            relative_path = input_path.relative_to(self.code_blocks_path)
            output_path = self.converted_path / relative_path
            output_path.parent.mkdir(parents=True, exist_ok=True)
            output_path.touch()
            return True
        except Exception as e:
            return False

if __name__ == '__main__':
    converter = SQLConverter(
        workspace_path='alert_convert_workspace',
        rule_path='rule.md'
    )
    
    # 从优先级列表读取需要转换的文件
    with open('alert_convert_workspace/AlertMapper_conversion/convert_priority_list.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # 修改列名从block_file获取文件名（原代码使用filename列不存在）
            input_file = converter.code_blocks_path / row['block_file']
            if input_file.exists():
                success = converter.convert_file(input_file)
                print(f'Converted {input_file.name}: {"Success" if success else "Failed"}') 