SELECT t.id, o.status, o.stage, o.id recurrent_id,
			   (select au.user_id from workbench_alert_user au where au.alert_id = o.id order by au.assign_time desc limit 0,1) user_id
		from
			(SELECT * from workbench_alert_info n where n.status = '0' and n.is_new = '1') t
				INNER JOIN (
					SELECT * from workbench_alert_info i
					where (i.recurrent_id is null or i.recurrent_id = '')
					and i.is_close = '1'
					and i.id NOT IN (
					SELECT r.recurrent_id from workbench_alert_info r
					where r.`status` != '0'
					and r.`is_close` = '0'
				)
			) o on t.title = o.title and t.description = o.description and t.dev_ip = o.dev_ip
			    and t.priority = o.priority and t.csrcip = o.csrcip and t.cdstip = o.cdstip