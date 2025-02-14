select
			count(1)
		from alert_notice_record
		where id=#{_parameter,jdbcType=VARCHAR}