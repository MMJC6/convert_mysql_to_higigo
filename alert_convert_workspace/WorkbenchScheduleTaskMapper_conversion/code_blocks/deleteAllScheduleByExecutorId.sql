DELETE p,wt FROM  workbench_schedule_task_partake p inner join workbench_schedule_task wt on p.workbench_schedule_task_id=wt.id and type !='2'
      and wt.executor_id=#{executorId}  and DATE_FORMAT(wt.begain_time,'%Y-%m-%d')>=DATE_FORMAT(now(),'%Y-%m-%d');
     DELETE  FROM  workbench_schedule_task
        where type !='2' and   executor_id=#{executorId}  and DATE_FORMAT(begain_time,'%Y-%m-%d')>=DATE_FORMAT(now(),'%Y-%m-%d');