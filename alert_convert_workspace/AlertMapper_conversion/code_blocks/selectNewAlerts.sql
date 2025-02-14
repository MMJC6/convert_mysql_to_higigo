select t.id,t.title,t.description,t.dev_ip,t.priority from workbench_alert_info t
		where t.status = '0'
		  and t.is_new = '1'
		  and not EXISTS (
				SELECT 1 from (SELECT title, description, dev_ip, priority,csrcip,cdstip from workbench_alert_info where `status` != '0' and is_close = '0') i
				where t.title = i.title and t.description = i.description and t.dev_ip = i.dev_ip and t.priority = i.priority
				  and t.csrcip = i.csrcip and t.cdstip = i.cdstip
			)