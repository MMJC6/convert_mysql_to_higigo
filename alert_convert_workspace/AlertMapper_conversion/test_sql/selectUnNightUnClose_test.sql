-- Test case 1: Basic COALESCE function test with NULL values
INSERT INTO workbench_alert_info (
    id, alert_no, title, priority, dev_ip, dev_name, dev_type, alert_src, status, stage,
    create_time, important_level, num, description, is_night, csrcip, cdstip, idstport, domain,
    create_time2, create_time3, create_time4, threat_score, categories, reverse_domains,
    location, reason, score, get_time, is_close, is_del
) VALUES (
    'test_id_1', '1001', 'Test Alert', '1', '192.168.1.1', 'test_dev', 'test_type', '1', '1', '1',
    NOW(), '1', 1, 'Test Description', '0', '10.0.0.1', '10.0.0.2', '80', 'test.domain',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NOW(), '0', '0'
);

-- Test the full query with NULL values
SELECT
    t.id, t.alert_no, t.title, t.priority, t.dev_ip, t.dev_name, t.dev_type, t.alert_src, t.status, t.stage,
    t.create_time, t.important_level, t.num, t.description, t.is_night, t.csrcip, t.cdstip, t.idstport, t.domain,
    t.create_time2, t.create_time3, t.create_time4,
    COALESCE(t.threat_score, 0) AS threat_score,
    COALESCE(t.categories, '') AS categories,
    COALESCE(t.reverse_domains, '') AS reverse_domains,
    COALESCE(t.location, '') AS location,
    COALESCE(t.reason, '') AS reason,
    COALESCE(t.score, 0) AS score,
    t.get_time
FROM workbench_alert_info t
WHERE t.is_close = '0' AND t.is_night = '0' AND t.status <> 0 AND t.is_del = '0'
AND t.id = 'test_id_1';

-- Test case 2: Test with non-NULL values
UPDATE workbench_alert_info
SET threat_score = 5,
    categories = 'test_cat',
    reverse_domains = 'test.domain',
    location = 'test_loc',
    reason = 'test_reason',
    score = 10
WHERE id = 'test_id_1';

-- Verify non-NULL values
SELECT
    t.id, t.alert_no, t.title, t.priority, t.dev_ip, t.dev_name, t.dev_type, t.alert_src, t.status, t.stage,
    t.create_time, t.important_level, t.num, t.description, t.is_night, t.csrcip, t.cdstip, t.idstport, t.domain,
    t.create_time2, t.create_time3, t.create_time4,
    COALESCE(t.threat_score, 0) AS threat_score,
    COALESCE(t.categories, '') AS categories,
    COALESCE(t.reverse_domains, '') AS reverse_domains,
    COALESCE(t.location, '') AS location,
    COALESCE(t.reason, '') AS reason,
    COALESCE(t.score, 0) AS score,
    t.get_time
FROM workbench_alert_info t
WHERE t.is_close = '0' AND t.is_night = '0' AND t.status <> 0 AND t.is_del = '0'
AND t.id = 'test_id_1';

-- Cleanup test data
DELETE FROM workbench_alert_info WHERE id = 'test_id_1';
