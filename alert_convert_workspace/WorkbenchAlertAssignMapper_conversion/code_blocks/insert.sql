insert into workbench_alert_assign (id, alert_id, assign_time,status)
        values (#{id,jdbcType=VARCHAR}, #{alertId,jdbcType=VARCHAR}, now(), '1')