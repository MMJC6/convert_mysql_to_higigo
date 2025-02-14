SELECT COUNT(u.id) FROM workbench_alert_user u
		INNER JOIN workbench_alert_info i ON u.alert_id = i.id
		WHERE i.title = #{title,jdbcType=VARCHAR} and i.description = #{description,jdbcType=VARCHAR}
		  and i.dev_ip = #{devIp,jdbcType=VARCHAR} and i.priority = #{priority,jdbcType=VARCHAR}
		  and i.csrcip = #{csrcip,jdbcType=VARCHAR} and i.cdstip = #{cdstip,jdbcType=VARCHAR}