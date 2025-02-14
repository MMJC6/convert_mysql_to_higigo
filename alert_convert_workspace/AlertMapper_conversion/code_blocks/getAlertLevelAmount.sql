select priority,sum(count) count from (
			select  case when priority=1 or priority=2 then  '低危'
			when priority=3 then  '中危' when priority=4 then  '高危' when priority=5 then  '紧急' else priority end priority,
			count(1) count,t.priority `level`
			from (
			select wai.title,wai.priority,wau.alert_id,wau.stage,min(wau.assign_time)  assign_time from   workbench_alert_user wau
			inner join workbench_alert_info wai on wau.alert_id = wai.id
			group by wau.alert_id,wau.stage
			)t
			where  t.assign_time > #{startTime,jdbcType=TIMESTAMP} and t.assign_time <= #{endTime,jdbcType=TIMESTAMP}
			group by case when priority=1 or priority=2 then  '低危'
			when priority=3 then  '中危' when priority=4 then  '高危' when priority=5 then  '紧急' else priority end

			union all

			select
			case when priority=1 or priority=2 then  '低危'
			when priority=3 then  '中危' when priority=4 then  '高危' when priority=5 then  '紧急' else priority end priority ,count(1) count,priority `level`
			from workbench_alert_info
			where get_time > #{startTime,jdbcType=TIMESTAMP} and get_time <= #{endTime,jdbcType=TIMESTAMP}
			and status='1'
			group by case when priority=1 or priority=2 then  '低危'
			when priority=3 then  '中危' when priority=4 then  '高危' when priority=5 then  '紧急' else priority end
			) t
		group by priority
		ORDER BY `level` desc