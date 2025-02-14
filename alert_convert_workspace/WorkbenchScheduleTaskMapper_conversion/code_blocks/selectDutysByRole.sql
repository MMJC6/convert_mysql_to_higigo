SELECT
            t.id,
            t.title,
            t.begain_time,
            t.end_time,
            DATE_FORMAT(t.begain_time, '%Y-%m-%d %T') begainTimeStr,
            DATE_FORMAT(t.end_time, '%Y-%m-%d %T') endTimeStr
        FROM
            workbench_schedule_task t
        WHERE
        t.type = '1'
        AND t.`status` = '1'
        AND EXISTS (
            SELECT
            1
            FROM
            sys_user_role uf,
            sys_role r
            WHERE
            uf.role_id = r.role_id
            AND t.executor_id = uf.user_id
            AND