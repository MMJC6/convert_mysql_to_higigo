select count(id) from workbench_alert_info
		where title = #{title,jdbcType=VARCHAR} and description = #{description,jdbcType=VARCHAR}
		  and dev_ip = #{devIp,jdbcType=VARCHAR} and priority = #{priority,jdbcType=VARCHAR}
		  and csrcip = #{csrcip,jdbcType=VARCHAR} and cdstip = #{cdstip,jdbcType=VARCHAR}
		  and stage >= 3