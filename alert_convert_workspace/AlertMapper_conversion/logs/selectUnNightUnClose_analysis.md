# Preprocessing Analysis - selectUnNightUnClose.sql

## File Information
- Priority: high
- Line Count: 7
- Source: AlertMapper.xml
- Functions to Convert: IFNULL

## Function Conversions Needed

### 1. IFNULL
- Convert to COALESCE
- Multiple instances:
  ```sql
  IFNULL(t.threat_score,0) threat_score
  IFNULL(t.categories,'') categories
  IFNULL(t.reverse_domains,'') reverse_domains
  IFNULL(t.location,'') location
  IFNULL(t.reason,'') reason
  IFNULL(t.score,0) score
  ```
- Context: Used for NULL value handling in SELECT clause
- Default values: 0 for numeric fields, '' for text fields

## Value Conversions
1. Status Values (Already in String Format)
   ```sql
   t.is_close = '0' and t.is_night = '0' and t.status <![CDATA[<>]]> 0
   ```
   - No conversion needed for '0' values
   - Note: status comparison uses numeric 0

2. Aliases
   - Add explicit AS for all COALESCE results

## XML Considerations
- Preserve CDATA section for <> operator
- Maintain original formatting
- Keep XML entities intact

## Test Cases Needed
1. COALESCE Function Tests
   - Test with NULL values
   - Test with non-NULL values
   - Verify default values (0 vs '')

2. Status Comparison Tests
   - Test is_close = '0'
   - Test is_night = '0'
   - Test status <> 0

## Validation Requirements
1. Function Conversion
   - Verify IFNULL → COALESCE conversion
   - Check default value types

2. Value Handling
   - Verify status comparisons work correctly
   - Check CDATA section preservation

3. XML Structure
   - Ensure XML mapper structure remains valid
   - Verify no unintended changes to surrounding XML
