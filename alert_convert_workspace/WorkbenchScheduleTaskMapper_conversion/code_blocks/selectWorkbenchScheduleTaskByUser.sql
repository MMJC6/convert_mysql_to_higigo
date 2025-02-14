select id,type,cycle_type,begain_time,end_time  from workbench_schedule_task t
         where not (#{beTime}>t.end_time or t.begain_time>#{enTime})
         and t.executor_id=#{userId} and t.status='1'