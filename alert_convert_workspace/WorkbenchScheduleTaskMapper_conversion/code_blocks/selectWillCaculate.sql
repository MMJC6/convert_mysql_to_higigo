select
	  task.task_group,
	  max(task.begain_time) begain_time,
	  DATE_FORMAT( MAX(task.begain_time) ,'%Y-%m-%d %H:%i:%s') begainTimeStr,
	  task.cycle_user_defined_type,
	  (SELECT
              t.new_time
             FROM workbench_schedule_task t
             WHERE t.id = t.task_group
                 and t.task_group = task.task_group
                 AND t.cycle_status = 1
                 AND t.cycle_type != '0')create_time,
    (SELECT
      t.new_leave_time
     FROM workbench_schedule_task t
     WHERE t.id = t.task_group
         and t.task_group = task.task_group
         AND t.cycle_status = 1
         AND t.cycle_type != '0')new_leave_time
	from workbench_schedule_task task
	where exists(SELECT
	               ''
	             FROM workbench_schedule_task t
	             WHERE t.id = t.task_group
	                 and t.task_group = task.task_group
	                 AND t.cycle_status = 1
	                 AND t.cycle_type != '0')
	    and (task.status = 1 OR task.status = 2)
	group by task.task_group
	having date_add(now(), interval 30 day) > MAX(task.begain_time)