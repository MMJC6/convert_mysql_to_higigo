SELECT COUNT(DISTINCT wt.executor_id) FROM workbench_schedule_task wt
		WHERE (NOW() BETWEEN wt.begain_time AND wt.end_time) and wt.status = '1' and wt.type = '1'
		AND EXISTS(
			SELECT
				*
			FROM
				sys_user_role uf,
				sys_role_menu fm,
				sys_menu m
			WHERE
				uf.role_id = fm.role_id
			  AND fm.menu_id = m.menu_id
			  and m.`status` = '1'
			  AND m.perms = 'workflow:alert'
			  and uf.user_id = wt.executor_id
		)