-- Test case for DATE_FORMAT to to_char conversion
SELECT expire_time, to_char(expire_time, 'YYYY-MM-DD HH24:MI:SS') AS expireTimeStr
FROM alert_config
WHERE status = '1' AND type = '0';

-- Test case for IFNULL to COALESCE conversion
SELECT 
  COALESCE(threat_score, 0) AS threat_score,
  COALESCE(categories, '') AS categories,
  COALESCE(reverse_domains, '') AS reverse_domains,
  COALESCE(location, '') AS location,
  COALESCE(reason, '') AS reason,
  COALESCE(score, 0) AS score,
  get_time
FROM workbench_alert_info;

-- Test case for TIMESTAMPDIFF to extract epoch conversion
SELECT 
  floor(extract(epoch from (now() - last_time)) / 86400) AS days_diff,
  floor(extract(epoch from (now() - assign_time)) / 3600) AS hours_diff,
  floor(extract(epoch from (end_time - start_time)) / 60) AS minutes_diff
FROM workbench_alert_info;

-- Test case for STR_TO_DATE to to_timestamp conversion
SELECT to_timestamp(#{param}, 'YYYY-MM-DD HH24:MI:SS') AS converted_time;

-- Test case for GROUP_CONCAT to string_agg conversion
SELECT 
  string_agg(user_id, ',') AS user_ids,
  string_agg(DISTINCT column, ',') AS distinct_columns
FROM workbench_alert_user;
