select GROUP_CONCAT(a.id) id, GROUP_CONCAT(a.title separator '、') title, count(1) count,GROUP_CONCAT(CONCAT_WS('@_ssp_@',a.title,a.priority,a.dev_ip,a.description) SEPARATOR '#_ssp_#' ) Space1
		from (
			SELECT ai.id,ai.title,ai.priority,ai.dev_ip,ai.description,if(
			(
				SELECT COUNT(1)
				FROM sys_user u
				WHERE u.status = '1' and
				EXISTS (
					SELECT 1 FROM sys_user_role uf, sys_role_menu fm, sys_menu m WHERE uf.role_id = fm.role_id AND fm.menu_id = m.menu_id
					AND m.`status` = '1' AND m.perms = 'workflow:alert' AND uf.user_id = u.user_id
				)
				/*AND EXISTS(
					SELECT '' FROM workbench_schedule_task wt WHERE wt.status = '1' and wt.executor_id = u.user_id AND (NOW() BETWEEN wt.begain_time AND wt.end_time)
				)*/
				AND EXISTS (
					SELECT 1 FROM workbench_alert_user au1 WHERE au1.user_id = u.user_id AND au1.alert_id = ai.id and au1.stage = ai.stage
				)
			) >= #{num,jdbcType=INTEGER},'Y','N') flg
			from workbench_alert_user au
			INNER JOIN workbench_alert_info ai ON ai.id = au.alert_id
			where au.id in