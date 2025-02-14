SELECT
		t.id, t.alert_no, t.title, t.priority, t.dev_ip, t.dev_name, t.dev_type, t.alert_src, t.status, t.stage,
		t.create_time, t.important_level, t.num, t.description,t.is_night,t.csrcip,t.cdstip,t.idstport,t.domain,
		t.create_time2,t.create_time3,t.create_time4,IFNULL(t.threat_score,0) threat_score,IFNULL(t.categories,'') categories,
		IFNULL(t.reverse_domains,'') reverse_domains,IFNULL(t.location,'') location,IFNULL(t.reason,'') reason,IFNULL(t.score,0) score,t.get_time,
		GROUP_CONCAT(u.user_id) user_id,COUNT(u.user_id) count,u2.user_id old_user_id,su.nick_name old_user_name
		from workbench_alert_info t
		LEFT JOIN workbench_alert_user u on u.alert_id = t.id and t.stage = u.stage and u.status <> 8
		LEFT JOIN workbench_alert_user u2 on u2.id = t.alert_user_id
		LEFT JOIN sys_user su on su.user_id = u2.user_id
		where t.is_close = '0' and t.is_del = '0'