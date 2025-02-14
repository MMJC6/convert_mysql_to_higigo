# Preprocessing Analysis - getNoticeAlerts.sql

## File Information
- Priority: medium
- Line Count: 55
- Source: AlertMapper.xml

## Function Conversions Needed

### 1. GROUP_CONCAT (7 instances)
a) Basic aggregation:
   ```sql
   GROUP_CONCAT(t.id) id
   ```
b) With CONCAT_WS and separator:
   ```sql
   GROUP_CONCAT(CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) SEPARATOR '#_ssp_#') title
   ```
c) With IF conditions (3 pairs):
   ```sql
   GROUP_CONCAT(IF(t.countType = '1',t.id,NULL)) id1
   GROUP_CONCAT(IF(t.countType = '1',CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), NULL ) SEPARATOR '#_ssp_#' ) title1
   ```

### 2. IF Statements (9 instances)
a) In GROUP_CONCAT:
   - 6 instances for conditional id and title aggregation
b) In CONCAT:
   ```sql
   CONCAT(IF(st.wechat_status = '1','1,',''),IF(st.phone_status = '1','2,',''),IF(st.email_status = '1','3,',''))
   ```
c) In column selection:
   ```sql
   IF(w1.id is NULL,(...),au.start_time_)
   IF(w2.id is NULL,(...),au.end_time_)
   ```

### 3. DATE_FORMAT (8 instances)
a) In comparisons:
   ```sql
   DATE_FORMAT(ba.start_time, '%Y-%m-%d')
   DATE_FORMAT(ba.end_time, '%Y-%m-%d')
   ```
b) In CONCAT operations:
   ```sql
   DATE_FORMAT(assign_time, '%Y-%m-%d')
   DATE_FORMAT(now(), '%Y-%m-%d')
   ```
c) In JOIN conditions:
   ```sql
   DATE_FORMAT(au.start_time_, '%Y-%m-%d')
   DATE_FORMAT(au.end_time_, '%Y-%m-%d')
   ```

### 4. TIMESTAMPDIFF (2 instances)
```sql
TIMESTAMPDIFF(MINUTE, ba.start_time, ba.end_time)
TIMESTAMPDIFF(MINUTE, ba.start_time, CONCAT(...))
```

### 5. date_add (2 instances)
```sql
date_add(assign_time, interval 1 day)
date_add(now(), interval -1 day)
```

## Value Conversions Needed
1. Status values to strings:
   - `status = '2'` (already string)
   - `wechat_status = '1'` (already string)
   - `phone_status = '1'` (already string)
   - `email_status = '1'` (already string)

2. Add explicit AS for aliases:
   - `id` → `AS id`
   - `title` → `AS title`
   - `count` → `AS count`
   - etc.

3. No backticks to remove (none present)
4. No BETWEEN conditions to convert

## Structure Changes Needed
1. No multi-table UPDATEs present
2. No HAVING conditions present
3. No REPLACE INTO usage
4. No ON DUPLICATE KEY UPDATE present

## XML Considerations
- No XML entities present in SQL
- Original formatting to be preserved
- No CDATA sections in SQL portion

## Conversion Order
1. Inner functions first:
   a) DATE_FORMAT in CONCAT operations
   b) IF conditions in CONCAT
   c) TIMESTAMPDIFF calculations
   d) date_add operations
2. Outer functions:
   a) IF conditions in GROUP_CONCAT
   b) GROUP_CONCAT with separators
3. Value and structure changes:
   - Add explicit AS for all aliases

## Test Cases Needed
1. Test date calculations across day boundaries
2. Test GROUP_CONCAT with NULL values
3. Test conditional aggregations
4. Test workday calculations
5. Test time range handling
