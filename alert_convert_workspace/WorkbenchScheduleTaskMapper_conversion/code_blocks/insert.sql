insert into  workbench_schedule_task_interval
            (id, task_group, cycle_user_defined_type, intervals)
            values (#{id,jdbcType=VARCHAR}, #{taskGroup,jdbcType=VARCHAR}, #{cycleUserDefinedType,jdbcType=CHAR}, #{intervals,jdbcType=INTEGER});