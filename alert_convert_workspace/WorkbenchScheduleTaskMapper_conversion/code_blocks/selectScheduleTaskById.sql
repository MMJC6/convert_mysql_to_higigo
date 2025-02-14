select
    	  task.id,
        task.title ,
        task.description,
        task.begain_time  ,
        task.end_time  task_end_time,
        task.level task_level,
        task.status task_status,
        task.detail_report_id,
        task.detail_report_name,
        task.task_group ,
        task.type task_type,
        task.cycle_type,
        task.cycle_user_defined_type,
        task.cycle_interval,
        task.create_time task_create_time,
        task.cycle_status,
        task.is_workday
    	   from  workbench_schedule_task task
          where task.id=#{id}