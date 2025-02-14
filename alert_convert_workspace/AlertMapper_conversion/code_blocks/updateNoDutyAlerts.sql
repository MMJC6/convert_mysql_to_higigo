UPDATE workbench_alert_info t,workbench_alert_user wu SET t.`status` = 8 , wu.`status` = 8
		WHERE t.id = wu.alert_id AND t.`status` = 2 AND wu.`status` = 2 AND NOT EXISTS (
			SELECT '' FROM workbench_schedule_task wt WHERE wu.user_id = wt.executor_id AND (wu.assign_time BETWEEN wt.begain_time AND wt.end_time)
		  and wt.status = 1 and wt.type = 1
			)