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
WHERE t.is_close = '0' AND t.is_night = '0' AND t.status <![CDATA[<>]]> 0 AND t.is_del = '0'
