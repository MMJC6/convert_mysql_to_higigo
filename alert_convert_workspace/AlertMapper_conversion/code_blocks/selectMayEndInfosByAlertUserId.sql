SELECT DISTINCT ai.id,ai.title,ai.priority,ai.dev_ip,ai.description,ai.stage,ai.is_epicycle_end,ai.is_reappear,wu.id workbenchAlertUserId
		FROM workbench_alert_info ai
		LEFT JOIN workbench_alert_user wu ON ai.id = wu.alert_id AND ai.stage = wu.stage
		WHERE
			wu.id in (${_parameter})
		GROUP BY ai.id