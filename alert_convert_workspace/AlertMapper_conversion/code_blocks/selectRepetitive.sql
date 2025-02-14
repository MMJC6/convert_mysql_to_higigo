SELECT
			t.id, t.alert_no, t.title, t.priority, t.dev_ip, t.dev_name, t.dev_type, t.alert_src, t.status, t.stage,t.space1,
			t.create_time, t.important_level, t.num, t.description,t.is_night,t.csrcip,t.cdstip,t.idstport,t.domain,
			t.create_time2,t.create_time3,t.create_time4,IFNULL(t.threat_score,0) threat_score,IFNULL(t.categories,'') categories,
			IFNULL(t.reverse_domains,'') reverse_domains,IFNULL(t.location,'') location,IFNULL(t.reason,'') reason,IFNULL(t.score,0) score,t.get_time,i.alert_no mergeAlertNo
		from workbench_alert_info t,workbench_alert_info i  where t.status = '0' and t.is_new = '1'
															  and i.`status` != '0' and i.is_close = '0' and i.is_del = '0'
		and t.title = i.title and t.description = i.description and t.dev_ip = i.dev_ip and t.priority = i.priority
		and t.csrcip = i.csrcip and t.cdstip = i.cdstip