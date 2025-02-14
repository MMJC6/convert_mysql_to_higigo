DELETE p,wt FROM  workbench_schedule_task_partake p inner join workbench_schedule_task wt on p.workbench_schedule_task_id=wt.id and type ='2'
      and wt.executor_id=#{executorId}  and wt.begain_time>DATE_SUB( CURDATE( ), INTERVAL #{day} DAY );

       DELETE  FROM  workbench_schedule_task
        where type ='2' and   executor_id=#{executorId}  and begain_time>DATE_SUB( CURDATE( ), INTERVAL #{day} DAY );