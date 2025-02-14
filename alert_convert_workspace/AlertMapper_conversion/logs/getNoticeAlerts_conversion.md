# Conversion Log - getNoticeAlerts.sql

## Overview
- File: getNoticeAlerts.sql
- Priority: medium
- Conversion Time: $(date '+%Y-%m-%d %H:%M:%S')

## Conversions Applied

### 1. GROUP_CONCAT to string_agg
- Basic aggregation: `GROUP_CONCAT(t.id)` → `string_agg(t.id, ',')`
- With separator: Added proper separators for all string_agg calls
- With conditions: Converted IF conditions to CASE WHEN inside string_agg

### 2. IF to CASE WHEN
- In GROUP_CONCAT: Converted all IF conditions to CASE WHEN
- In CONCAT: Converted status checks to CASE WHEN expressions
- In column selection: Converted NULL checks to CASE WHEN

### 3. DATE_FORMAT to to_char
- Format mapping: '%Y-%m-%d' → 'YYYY-MM-DD'
- In comparisons: Converted all date comparisons
- In concatenations: Handled timestamp construction properly

### 4. TIMESTAMPDIFF to extract epoch
- Minute calculations: Added proper divisor (60)
- Complex calculations: Handled cross-day calculations correctly

### 5. date_add Operations
- Parameter order: Reversed for PostgreSQL syntax
- Interval handling: Added proper interval type specifications

### 6. Value Conversions
- Added explicit AS for all aliases
- Status values already in string format
- No backticks present
- No BETWEEN conditions present

## Test Cases
1. Basic aggregation test
2. Conditional aggregation test
3. Date calculation test
4. Status handling test
5. Workday calculation test

## Validation Status
Ready for validation phase
