select
			t.id, t.alert_no, t.title, t.priority, t.dev_ip, t.dev_name, t.dev_type, t.alert_src, t.status, t.stage,
			t.create_time, t.important_level, t.num, t.description,t.is_night,t.csrcip,t.cdstip,t.idstport,t.domain,
			t.create_time2,t.create_time3,t.create_time4,IFNULL(t.threat_score,0) threat_score,IFNULL(t.categories,'') categories,
			IFNULL(t.reverse_domains,'') reverse_domains,IFNULL(t.location,'') location,IFNULL(t.reason,'') reason,IFNULL(t.score,0) score,t.get_time
		,t.is_epicycle_end,t.is_reappear,t.alert_id
		from workbench_alert_info t
		where t.is_matching_mul = '0' and t.status <> '0'