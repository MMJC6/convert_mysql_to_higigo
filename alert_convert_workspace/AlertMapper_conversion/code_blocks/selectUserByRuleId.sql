SELECT
			u.user_id,
			u.user_type,
			u.nick_name,
			u.email,
			u.phonenumber,
			CONCAT(IF(send.wechat_status = '1','1,',''),IF(send.phone_status = '1','2,',''),IF(send.email_status = '1','3,','')) sendType
		FROM alert_notice_list li
		INNER JOIN sys_user u ON li.user_id = u.user_id AND u.status = '1'
		INNER JOIN s_user_send_type send ON u.user_id = send.user_id
		WHERE li.type = 0
		  and li.rule_id=#{_parameter,jdbcType=VARCHAR}
		UNION
		SELECT
			'' id,
			'2' user_type,
			''  `name`,
			li.email,
			li.mobile_phone_no,
			'' sendType
		FROM alert_notice_list li
		WHERE li.type = 1
		  and li.rule_id=#{_parameter,jdbcType=VARCHAR}