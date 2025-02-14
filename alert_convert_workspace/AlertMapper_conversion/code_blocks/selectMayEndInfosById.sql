SELECT ai.id,ai.title,ai.stage,ai.is_epicycle_end,ai.is_reappear
		FROM workbench_alert_info ai
		LEFT JOIN workbench_alert_user wu ON ai.id = wu.alert_id AND ai.stage = wu.stage
		WHERE
		ai.id in