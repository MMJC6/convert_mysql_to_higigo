-- Test case for UUID to uuid_generate_v4
SELECT MD5(uuid_generate_v4() || '') AS generated_id;

-- Test case for status value conversion
SELECT * FROM workbench_alert_user WHERE status = '1';

-- Test case for date formatting
SELECT to_char(assign_time, 'YYYY-MM-DD HH24:MI:SS') AS formatted_time,
       to_char(end_time, 'YYYY-MM-DD HH24:MI:SS') AS end_time_formatted
FROM workbench_alert_user;

-- Test case for TIMESTAMPDIFF to extract epoch conversion
SELECT floor(extract(epoch from (end_time - assign_time)) / 3600) AS hours_diff
FROM workbench_alert_user;
