insert into workbench_notice_send_batch (id, batch_no, collect_status,
                                                 collect_time, call_status, remarks, notice_type)
        values (#{id,jdbcType=VARCHAR}, DATE_FORMAT(now(),'%Y%m%d%H%i%s'), #{collectStatus,jdbcType=CHAR},
                now(), #{callStatus,jdbcType=CHAR}, #{remarks,jdbcType=VARCHAR}, #{noticeType,jdbcType=CHAR})