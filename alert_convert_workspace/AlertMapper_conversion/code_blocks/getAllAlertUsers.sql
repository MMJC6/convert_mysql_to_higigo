SELECT u.user_id,u.nick_name,u.phonenumber,u.email,au.count `rows` ,date_format(wt.begain_time,'%Y-%m-%d %T') begainTimeStr, date_format(wt.end_time,'%Y-%m-%d %T') endTimeStr,
		IFNULL((SELECT IFNULL(COUNT(1),0) from workbench_alert_user wau where wau.status BETWEEN 3 and 4 and u.user_id = wau.user_id),0)/au.num*8 as num
		from sys_user u
		LEFT JOIN (SELECT w.user_id ,COUNT(1) count ,(TIMESTAMPDIFF(HOUR, MIN(w.assign_time), NOW())) num from workbench_alert_user w inner join workbench_alert_info a ON a.id = w.alert_id and a.is_del = '0' and a.`status` = '2' where w.`status` = '2' GROUP BY w.user_id ) au on u.user_id = au.user_id
		INNER JOIN workbench_schedule_task wt ON u.user_id = wt.executor_id AND wt.type = 1 AND wt.`status` = 1
		where u.status = '1'
		  AND (NOW() BETWEEN wt.begain_time AND wt.end_time)
		  and EXISTS(
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
		  and uf.user_id = u.user_id)
		order by `rows`, num desc,u.nick_name