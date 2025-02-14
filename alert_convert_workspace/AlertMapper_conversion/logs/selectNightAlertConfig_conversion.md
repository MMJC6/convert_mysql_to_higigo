# Conversion Log - selectNightAlertConfig.sql

## Overview
- File: selectNightAlertConfig.sql
- Priority: high
- Conversion Time: 2025-02-14 05:50

## Conversions Applied

### 1. DATE_FORMAT to to_char
```sql
Before: DATE_FORMAT(expire_time, '%Y-%m-%d %T' ) expireTimeStr
After:  to_char(expire_time, 'YYYY-MM-DD HH24:MI:SS') AS expireTimeStr
```

### 2. SQL Style Improvements
- Added explicit AS for expireTimeStr column
- Standardized SQL keywords to uppercase
- Maintained original column ordering

## Validation Status
- Function replacements validated
- Value handling confirmed
- SQL syntax verified
- Test cases created and executed

## Notes
- Simple conversion with single DATE_FORMAT function
- No complex structural changes needed
- Status values already in correct string format
