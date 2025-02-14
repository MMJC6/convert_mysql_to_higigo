SELECT COUNT(wu.user_id) count
		FROM workbench_alert_info ai
		LEFT JOIN workbench_alert_user wu ON ai.id = wu.alert_id AND ai.stage = wu.stage
		WHERE ai.id = #{id,jdbcType=VARCHAR}