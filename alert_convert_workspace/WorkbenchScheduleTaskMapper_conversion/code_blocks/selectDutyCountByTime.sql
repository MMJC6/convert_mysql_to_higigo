SELECT
            c.time,
            DATE_FORMAT(c.time, '%Y-%m-%d %T') timeStr,
            COUNT(DISTINCT d.executor_id) count
        FROM
            workbench_duty_time_count c
            LEFT JOIN (
                SELECT
                t.id,
                t.executor_id,
                t.begain_time,
                t.end_time
                FROM
                workbench_schedule_task t
                INNER JOIN sys_user_role uf ON t.executor_id = uf.user_id
                INNER JOIN sys_role r ON uf.role_id = r.role_id
                WHERE
                t.`status` = '1'
                AND t.type = '1'
                AND r.role_key = #{permission,jdbcType=VARCHAR}
            ) d ON c.time BETWEEN d.begain_time
            AND d.end_time
        GROUP BY c.time
        ORDER BY c.time