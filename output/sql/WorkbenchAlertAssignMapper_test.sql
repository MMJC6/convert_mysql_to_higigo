-- Test case for date formatting
SELECT to_char(assign_time, 'YYYY-MM-DD HH24:MI:SS') AS formatted_time
FROM workbench_alert_assign;

-- Test case for status value conversion
SELECT * FROM workbench_alert_assign WHERE status = '1';

-- Test case for COALESCE
SELECT COALESCE(remarks, '') AS remarks
FROM workbench_alert_assign;
