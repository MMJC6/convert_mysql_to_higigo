select sum(count)  count from (
			select  count(1) count from (
				select alert_id,stage,min(assign_time)  assign_time from   workbench_alert_user wau
				group by alert_id,stage
			)t where  assign_time > #{startTime,jdbcType=TIMESTAMP} and assign_time <= #{endTime,jdbcType=TIMESTAMP}
			union all
			select count(1) count from workbench_alert_info
			where get_time > #{startTime,jdbcType=TIMESTAMP} and get_time <= #{endTime,jdbcType=TIMESTAMP}
			and status='1'
		)t