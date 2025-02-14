#!/usr/bin/env python3
"""
XML预处理脚本 - 版本1.2
功能：解析XML文件、提取代码块、优先级分类、生成转换工作区
"""

import argparse
import os
import xml.etree.ElementTree as ET
from pathlib import Path
import csv
import uuid
import logging
import yaml  # 需要添加pyyaml依赖
import re  # 需要添加re依赖
import shutil

# 配置参数
TARGET_TAGS = ['select', 'insert', 'update', 'delete']  # 需要提取的SQL标签
PRIORITY_BREAKPOINTS = [40, 80]  # 优先级分界点
RULE_CONFIG = "config/preprocess_config.yaml"

def setup_logging():
    """配置日志记录"""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s [%(levelname)s] %(filename)s:%(lineno)d - %(message)s',
        handlers=[logging.FileHandler('preprocessing.log'), logging.StreamHandler()]
    )

def calculate_priority(line_count):
    """根据行数计算优先级"""
    if line_count < PRIORITY_BREAKPOINTS[0]:
        return 'high'
    elif PRIORITY_BREAKPOINTS[0] <= line_count < PRIORITY_BREAKPOINTS[1]:
        return 'medium'
    else:
        return 'low'

def load_config():
    """加载规则配置"""
    config_path = Path(__file__).parent / RULE_CONFIG
    with open(config_path, encoding='utf-8') as f:
        return yaml.safe_load(f)

def validate_config(config):
    """配置验证"""
    required_sections = ['function_mappings', 'type_conversions', 'structure_rules']
    for section in required_sections:
        if section not in config:
            raise ValueError(f"Missing required config section: {section}")

def process_xml_file(xml_path):
    """处理单个XML文件"""
    try:
        print(f"【调试】开始处理文件: {xml_path}")  # 添加调试输出
        # 固定输出目录结构
        input_dir = xml_path.parent
        output_root = input_dir.parent / "alert_convert_workspace"
        file_stem = xml_path.stem
        print(f"1111111")  # 显示目录路径

        conversion_dir = output_root / f"{file_stem}_conversion"
        # 删除旧目录（新增）
        if conversion_dir.exists():
            shutil.rmtree(conversion_dir)
        print(f"【调试】目标目录: {conversion_dir}")  # 显示目录路径
        codeblocks_dir = conversion_dir / "code_blocks"
        codeblocks_new_dir = conversion_dir / "code_blocks_new"  # 新增空文件目录
        codeblocks_dir.mkdir(parents=True, exist_ok=True)
        codeblocks_new_dir.mkdir(parents=True, exist_ok=True)  # 创建新目录
        
        # 解析XML
        tree = ET.parse(xml_path)
        root = tree.getroot()

        # 提取代码块
        blocks = []
        for tag in TARGET_TAGS:
            for elem in root.findall(f'.//{tag}'):
                content = elem.text.strip() if elem.text else ''
                if not content:  # 跳过空内容
                    continue
                
                # 使用标签ID作为block_id
                block_id = elem.get('id')
                if not block_id:  # 如果没有ID则跳过
                    logging.warning(f"Found {tag} without ID in {xml_path}")
                    continue

                lines = [line for line in content.split('\n') if line.strip()]
                line_count = len(lines)
                
                # 计算基础优先级
                priority = calculate_priority(line_count)
                
                # 加载配置规则
                config = load_config()
                func_pattern = re.compile(r'\b(' + '|'.join(config['function_mappings'].keys()) + r')\b', re.IGNORECASE)
                
                # 检测需要转换的关键字
                found_functions = func_pattern.findall(content)
                if found_functions:
                    logging.info(f"Found functions {set(found_functions)} in block {block_id}")
                    priority = 'high' if 'high' in priority else 'medium'  # 发现函数提升优先级

                # 检测复杂结构
                complex_structures = [
                    ('UPDATE .*,', 'multi_table_update'),
                    ('REPLACE INTO', 'replace_into'),
                    ('GROUP_CONCAT', 'group_concat')
                ]
                for pattern, flag in complex_structures:
                    if re.search(pattern, content, re.IGNORECASE):
                        priority = 'high' if priority == 'low' else priority
                
                # 保存代码块文件（使用标签ID作为文件名）
                block_file = codeblocks_dir / f"{block_id}.sql"
                with open(block_file, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                # 新增：创建对应的空文件
                block_file_new = codeblocks_new_dir / f"{block_id}.sql"
                with open(block_file_new, 'w', encoding='utf-8') as f:
                    pass  # 创建空文件
                
                blocks.append({
                    'id': block_id,
                    'source_file': xml_path.name,
                    'block_file': block_file.name,
                    'line_count': line_count,
                    'priority': priority,
                    'found_functions': ','.join(set(found_functions))
                })

        # 生成优先级清单
        priority_list = conversion_dir / "convert_priority_list.csv"
        with open(priority_list, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=blocks[0].keys())
            writer.writeheader()
            writer.writerows(sorted(blocks, key=lambda x: x['priority'], reverse=True))

        logging.info(f"Processed {xml_path}: {len(blocks)} blocks extracted")

    except Exception as e:
        logging.error(f"Error processing {xml_path}: {str(e)}")

def main():
    """主处理流程"""
    parser = argparse.ArgumentParser(description='XML预处理工具')
    parser.add_argument('input_dir', type=str, help='原始XML文件夹路径')
    args = parser.parse_args()
    
    # 自动生成输出目录
    input_dir = Path(args.input_dir)
    output_root = input_dir.parent / "alert_convert_workspace"
    output_root.mkdir(exist_ok=True)
    
    setup_logging()
    logging.info(f"Starting XML preprocessing from {input_dir}")

    xml_files = list(input_dir.glob('*.xml'))
    if not xml_files:
        logging.warning("No XML files found in input directory")

    total_files = len(xml_files)
    for idx, xml_file in enumerate(xml_files):
        process_xml_file(xml_file)
        print(f"进度: {idx+1}/{total_files} ({((idx+1)/total_files)*100:.1f}%)")

    logging.info("Preprocessing completed")

if __name__ == "__main__":
    main() 