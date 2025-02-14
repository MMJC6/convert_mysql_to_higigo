SELECT ai.id,ai.title,COUNT(wu.user_id) count, GROUP_CONCAT(wu.user_id) user_id FROM workbench_alert_info ai
			LEFT JOIN workbench_alert_user wu ON ai.id = wu.alert_id AND ai.stage = wu.stage
		WHERE ai.`status` in (3,6,8) AND wu.`status` in (3,6) and ai.is_del = '0' and ai.is_epicycle_end = '0'
		GROUP BY ai.id