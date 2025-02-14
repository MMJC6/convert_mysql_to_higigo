SELECT
            t.id,
            t.title,
            t.executor_id,
            t.begain_time,
            t.end_time,
            DATE_FORMAT(t.begain_time, '%Y-%m-%d %T') begainTimeStr,
            DATE_FORMAT(t.end_time, '%Y-%m-%d %T') endTimeStr
        FROM
            workbench_schedule_task t
        WHERE
            t.type = '1'
          AND t.`status` = '1'
          AND t.begain_time >= #{beginTime,jdbcType=TIMESTAMP}
          AND t.end_time <= #{endTime,jdbcType=TIMESTAMP}
          AND t.executor_id in