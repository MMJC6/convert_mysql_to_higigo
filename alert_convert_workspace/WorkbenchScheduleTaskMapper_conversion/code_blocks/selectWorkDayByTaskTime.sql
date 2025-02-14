select
            DATE_FORMAT(workday,'%Y-%m-%d') workday,datediff(workday,#{begainTimeStr}) diff
        from s_workday t
        where t.workDay>#{begainTimeStr}
          and #{endTimeStr}>=t.workDay
          and datediff(workday,#{begainTimeStr})>0