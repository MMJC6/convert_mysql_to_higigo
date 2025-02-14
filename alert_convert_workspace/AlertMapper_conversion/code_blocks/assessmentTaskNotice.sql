SELECT
			ROUND(SUM(CASE WHEN i.`status` = '1' THEN 1 WHEN i.`status` = '2' THEN 0.5 ELSE 0 END)) as notFinish,
			ROUND(IFNULL((SELECT COUNT(1)/COUNT(DISTINCT u.user_id) from workbench_alert_user u where u.end_time >= STR_TO_DATE(#{workBeginTime,jdbcType=VARCHAR},'%Y-%m-%d %T') and u.end_time <= STR_TO_DATE(#{noticeTime,jdbcType=VARCHAR},'%Y-%m-%d %T') and u.`status` != '2'),0)) finish,
			TIMESTAMPDIFF(MINUTE, STR_TO_DATE(#{workBeginTime,jdbcType=VARCHAR},'%Y-%m-%d %T'), STR_TO_DATE(#{noticeTime,jdbcType=VARCHAR},'%Y-%m-%d %T')) previousTime,
			TIMESTAMPDIFF(MINUTE, STR_TO_DATE(#{noticeTime,jdbcType=VARCHAR},'%Y-%m-%d %T'), STR_TO_DATE(#{workEndTime,jdbcType=VARCHAR},'%Y-%m-%d %T')) afterTime
		FROM
			workbench_alert_info i