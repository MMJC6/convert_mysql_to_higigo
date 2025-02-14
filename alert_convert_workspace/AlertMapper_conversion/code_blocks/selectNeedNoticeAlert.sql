SELECT GROUP_CONCAT(ba.id) id,GROUP_CONCAT(a.title) title
		from (
				 SELECT
					 au.id,
					 au.alert_id,
					 au.user_id,
					 au.assign_time,
					 au.status,
					 au.stage,
					 au.assign_id,
					 au.notice_type,
					 au.assign_time start_time,
					 now() end_time
				 from workbench_alert_user au
				 where au.status = '2'
				   and au.new_night_send = '0'
			 ) ba
				 INNER JOIN workbench_alert_info a on ba.alert_id = a.id and a.is_close = '0' and a.is_night = '1'