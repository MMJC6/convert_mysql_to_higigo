select count(1) from workbench_schedule_task_interval where task_group=#{taskGroup}
         and cycle_user_defined_type=#{cycleUserDefinedType} and intervals=#{intervals}