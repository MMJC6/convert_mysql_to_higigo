SELECT alert_no, title, priority, dev_ip, dev_name, dev_type, alert_src,`status`,stage,csrcip,
			   cdstip,idstport,domain,create_time, description, count(1) num,is_night,source,alert_id,cus_name,cruleid,ceventdigest
		FROM workbench_alert_info_temporary
		GROUP BY title, description, dev_ip, priority,csrcip,cdstip;