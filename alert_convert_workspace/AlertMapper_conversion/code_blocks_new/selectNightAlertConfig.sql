SELECT
    id, alert_from, alert_title, alert_priority, alert_dev_ip, alert_dev_name, alert_dev_type,
    alert_csrcip, alert_cdstip, alert_idstport, alert_domain, defined_type, prescription, type, create_time,
    create_by, update_time, update_by, status, alert_description, expire_time, 
    to_char(expire_time, 'YYYY-MM-DD HH24:MI:SS') AS expireTimeStr,
    spare1, spare2, spare3, spare4, spare5
FROM alert_config
WHERE status = '1' AND type = '0'
