# Preprocessing Analysis - selectNightAlertConfig.sql

## File Information
- Priority: high
- Line Count: 7
- Source: AlertMapper.xml
- Functions to Convert: DATE_FORMAT

## Function Conversions Needed

### 1. DATE_FORMAT
- Format mapping: '%Y-%m-%d %T' → 'YYYY-MM-DD HH24:MI:SS'
- Context: Used in expireTimeStr column formatting
- Location: Single instance in SELECT clause
- Example:
  ```sql
  Before: DATE_FORMAT(expire_time, '%Y-%m-%d %T' ) expireTimeStr
  After:  to_char(expire_time, 'YYYY-MM-DD HH24:MI:SS') AS expireTimeStr
  ```

## Value Conversions
1. Status Values (Already in String Format)
   ```sql
   where status = '1' and type = '0'
   ```
   - No conversion needed as values already use string format

2. Aliases
   - Add explicit AS for expireTimeStr column
   - Other columns already have implicit aliases which are acceptable

## Structure Changes
- No multi-table UPDATEs present
- No HAVING conditions present
- No REPLACE INTO statements present
- No ON DUPLICATE KEY UPDATE clauses present
- Simple SELECT query with straightforward conversion needs

## XML Considerations
- Preserve XML entities in mapper file
- Maintain original formatting and indentation
- No CDATA sections present in this query

## Test Cases Created
1. Basic Date Format Test
   ```sql
   SELECT to_char(expire_time, 'YYYY-MM-DD HH24:MI:SS') AS expireTimeStr
   FROM alert_config
   WHERE status = '1' AND type = '0'
   LIMIT 1;
   ```

2. Full Query Test
   ```sql
   SELECT all columns with converted date format...
   ```

3. Status String Comparison Test
   ```sql
   SELECT COUNT(*)
   FROM alert_config
   WHERE status = '1' AND type = '0';
   ```

## Validation Requirements
1. Function Conversion
   - Verify to_char format matches DATE_FORMAT output
   - Confirm timezone handling consistency

2. Value Handling
   - Verify status string comparisons work correctly
   - Check alias resolution in result set

3. XML Structure
   - Ensure XML mapper structure remains valid
   - Verify no unintended changes to surrounding XML
