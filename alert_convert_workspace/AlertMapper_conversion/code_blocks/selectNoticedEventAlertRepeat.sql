SELECT id, event_id eventId, title, priority, dev_ip devIp, description, DATE_FORMAT(create_time,'%Y-%m-%d %T') createTimeStr
		from event_alert_repeat_notice
		where title = #{title,jdbcType=VARCHAR}
		  and priority = #{priority,jdbcType=VARCHAR}
		  and dev_ip = #{devIp,jdbcType=VARCHAR}
		  and description = #{description,jdbcType=VARCHAR}