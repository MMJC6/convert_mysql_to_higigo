-- Test case 1: Basic aggregation
SELECT t.userId,t.email,t.mobilePhoneNo,t.userName,t.userType,t.sendType,
		string_agg(t.id, ',') AS id,
		string_agg(CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), '#_ssp_#') AS title,
		count(1) AS count
FROM test_data t
GROUP BY t.userId,t.email,t.mobilePhoneNo,t.userName,t.userType,t.sendType;

-- Test case 2: Conditional aggregation
SELECT string_agg(CASE WHEN t.countType = '1' THEN t.id ELSE NULL END, ',') AS id1,
       string_agg(CASE WHEN t.countType = '1' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') AS title1,
       SUM(CASE WHEN t.countType = '1' THEN 1 ELSE 0 END) AS count1
FROM test_data t;

-- Test case 3: Date calculations
SELECT 
    CASE 
        WHEN to_char(start_time, 'YYYY-MM-DD') > to_char(end_time, 'YYYY-MM-DD') THEN 0
        WHEN to_char(start_time, 'YYYY-MM-DD') = to_char(end_time, 'YYYY-MM-DD') THEN 
            floor(extract(epoch from (end_time - start_time)) / 60)
        ELSE 
            floor(extract(epoch from (to_timestamp(to_char(start_time, 'YYYY-MM-DD') || ' ' || to_char(end_time, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') - start_time)) / 60)
    END AS minutes_diff
FROM test_data;

-- Test case 4: Status handling
SELECT 
    CASE WHEN wechat_status = '1' THEN '1,' ELSE '' END ||
    CASE WHEN phone_status = '1' THEN '2,' ELSE '' END ||
    CASE WHEN email_status = '1' THEN '3,' ELSE '' END AS status_concat
FROM test_data;

-- Test case 5: Workday calculations
SELECT COUNT(1) * 480 -- #{timeDifference} = 480 minutes (8 hours)
FROM s_workday 
WHERE CAST(workday AS timestamp) > '2025-02-14 09:00:00'::timestamp 
AND CAST(workday AS timestamp) < '2025-02-15 17:00:00'::timestamp;
