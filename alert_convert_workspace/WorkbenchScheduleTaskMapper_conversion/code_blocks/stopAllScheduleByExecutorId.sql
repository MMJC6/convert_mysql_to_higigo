update   workbench_schedule_task set cycle_status = '0' where
      id  in (
      select id from (
          select st.id
       from workbench_schedule_task st
       where st.executor_id = #{executorId}  and st.id=st.task_group and cycle_status =1
       )t
       )
       and type !='2'