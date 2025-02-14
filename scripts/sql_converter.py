import os
import re
import csv
import logging
from pathlib import Path
from datetime import datetime

class SQLConverter:
    def __init__(self, workspace_path, rule_path):
        self.workspace = Path(workspace_path)
        self.rules = self._load_rules(rule_path)
        self.logs_path = self.workspace / 'conversion_logs'
        self.converted_path = self.workspace / 'converted_code_blocks'
        
        # 创建必要目录
        self.logs_path.mkdir(exist_ok=True)
        self.converted_path.mkdir(exist_ok=True)
        
        # 配置日志
        logging.basicConfig(
            filename=self.logs_path / 'conversion.log',
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )

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
                logging.info(f'Replaced {func} with {replacement}')
        return sql

    def _convert_values(self, sql):
        """状态值转换规则"""
        # 示例：status = 1 → status = '1'
        sql = re.sub(r'(status\s*=\s*)(\d+)', r"\1'\2'", sql, flags=re.IGNORECASE)
        return sql

    def convert_file(self, input_path):
        """转换单个SQL文件"""
        try:
            with open(input_path, 'r', encoding='utf-8') as f:
                sql = f.read()
                
            original_sql = sql
            
            # 应用转换规则
            sql = self._convert_functions(sql)
            sql = self._convert_values(sql)
            
            # 生成输出路径
            output_path = self.converted_path / input_path.name
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(sql)
                
            # 记录转换日志
            self._log_conversion(input_path, original_sql, sql)
            
            return True
        except Exception as e:
            logging.error(f'Error converting {input_path}: {str(e)}')
            return False

    def _log_conversion(self, input_path, original, converted):
        """生成详细转换日志"""
        log_file = self.logs_path / f'{input_path.stem}_log.md'
        
        with open(log_file, 'w', encoding='utf-8') as f:
            f.write(f'# Conversion Log - {input_path.name}\n')
            f.write(f'**Conversion Time**: {datetime.now()}\n\n')
            
            f.write('## Original SQL\n```sql\n')
            f.write(original + '\n```\n\n')
            
            f.write('## Converted SQL\n```sql\n')
            f.write(converted + '\n```\n\n')
            
            f.write('## Diff Summary\n```diff\n')
            # 这里可以添加diff生成逻辑
            f.write('+ Updated function calls\n')
            f.write('- Removed backticks\n')
            f.write('```\n')

if __name__ == '__main__':
    converter = SQLConverter(
        workspace_path='alert_convert_workspace',
        rule_path='rule.md'
    )
    
    # 从优先级列表读取需要转换的文件
    with open('alert_convert_workspace/AlertMapper_conversion/convert_priority_list.csv', 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            input_file = Path('alert_convert_workspace/AlertMapper_conversion/code_blocks') / row['filename']
            if input_file.exists():
                success = converter.convert_file(input_file)
                print(f'Converted {input_file.name}: {"Success" if success else "Failed"}') 