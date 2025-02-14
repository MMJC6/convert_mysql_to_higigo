SELECT COUNT(DISTINCT u.user_id) FROM sys_user u WHERE u.status = '1' and
			EXISTS (SELECT 1 FROM sys_user_role uf, sys_role_menu fm, sys_menu m
					WHERE uf.role_id = fm.role_id AND fm.menu_id = m.menu_id
					AND m.`status` = '1' AND m.perms = 'workflow:alert' AND uf.user_id = u.user_id )
			AND EXISTS (
				SELECT '' FROM workbench_schedule_task wt WHERE wt.status = '1' and wt.executor_id = u.user_id AND (NOW() BETWEEN wt.begain_time AND wt.end_time)
			)
			AND NOT EXISTS (
				SELECT 1 FROM workbench_alert_user au WHERE au.user_id = u.user_id AND au.alert_id = #{id,jdbcType=VARCHAR}
				and au.stage = (SELECT ai.stage FROM workbench_alert_info ai WHERE ai.id = #{id,jdbcType=VARCHAR})
			)