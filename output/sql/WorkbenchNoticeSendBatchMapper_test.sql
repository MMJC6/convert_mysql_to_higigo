-- Test case for UUID to uuid_generate_v4
SELECT MD5(uuid_generate_v4() || '') AS generated_id;

-- Test case for status value conversion
SELECT * FROM workbench_notice_send_batch WHERE status = '1';

-- Test case for date formatting
SELECT to_char(create_time, 'YYYY-MM-DD HH24:MI:SS') AS formatted_time
FROM workbench_notice_send_batch;
