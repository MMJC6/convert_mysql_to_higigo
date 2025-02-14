select
            task.id,
            task.task_group,
            task.begain_time,
            task.end_time,
            task.cycle_type,
            task.cycle_interval,
            task.cycle_user_defined_type,
            intervals.intervals,
            task.is_workday,
            task.executor_id,
            task.type
        from workbench_schedule_task task
        left join workbench_schedule_task_interval intervals on task.task_group = intervals.task_group
        where  task.status = '1'
          and task.cycle_type > 0
          and task.begain_time=#{begainTimeStr}
          and task.task_group =#{taskGroup}
        order by task.id,intervals.intervals