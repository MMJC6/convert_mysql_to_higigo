update workbench_alert_info t
		set t.important_level = t.important_level + (
			case when t.important_level = 4 then 1
				 when (t.important_level = 3 and FLOOR(TIMESTAMPDIFF(HOUR, t.level_update_time, NOW())/3) > 2) then 2
				 when (t.important_level = 2 and FLOOR(TIMESTAMPDIFF(HOUR, t.level_update_time, NOW())/3) > 3) then 3
				 when (t.important_level = 1 and FLOOR(TIMESTAMPDIFF(HOUR, t.level_update_time, NOW())/3) > 4) then 4
				 else FLOOR(TIMESTAMPDIFF(HOUR, t.level_update_time, NOW())/3) end
			),
			t.level_update_time = date_add(t.level_update_time, interval FLOOR(TIMESTAMPDIFF(HOUR, t.level_update_time, NOW())/3)*3 hour)
		where
			t.`status` = '1'
		  and t.stage = ''
		  and t.important_level < 5
		  and t.level_update_time <= DATE_SUB(NOW(), INTERVAL 3 HOUR)