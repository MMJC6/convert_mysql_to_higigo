select
			t.id, t.alert_no, t.title, t.priority, t.dev_ip, t.dev_name, t.dev_type, t.alert_src, t.status, t.stage,
			t.create_time, t.important_level, t.num, t.description, t.is_night, t.csrcip, t.cdstip, t.idstport, t.domain,
			t.create_time2, t.create_time3, t.create_time4, COALESCE(t.threat_score, 0) as threat_score, COALESCE(t.categories, '') as categories,
			COALESCE(t.reverse_domains, '') as reverse_domains, COALESCE(t.location, '') as location, COALESCE(t.reason, '') as reason, COALESCE(t.score, 0) as score, t.get_time
		from workbench_alert_info t
		where t.is_close = '0' and t.is_night = '0' and t.status <> '0' and t.is_del = '0'
