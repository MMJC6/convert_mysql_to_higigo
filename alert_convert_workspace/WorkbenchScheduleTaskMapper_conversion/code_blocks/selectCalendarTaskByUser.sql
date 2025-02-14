select count(*)
        from workbench_schedule_task
        where executor_id = #{executorId}
        and ( ( #{begainTimeStr} != end_time and #{begainTimeStr} BETWEEN begain_time and end_time )
        or ( #{endTimeStr} != begain_time and #{endTimeStr} BETWEEN begain_time and end_time ) or ( #{begainTimeStr} < begain_time and end_time < #{endTimeStr}) )
        and status = 1
        and  type='1'