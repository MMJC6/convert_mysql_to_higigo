SELECT t.userId,t.email,t.mobilePhoneNo,t.userName,t.userType,t.sendType,
		string_agg(t.id, ',') AS id,
		string_agg(CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), '#_ssp_#') AS title,
		count(1) AS count,
		string_agg(CASE WHEN t.countType = '1' THEN t.id ELSE NULL END, ',') AS id1,
		string_agg(CASE WHEN t.countType = '1' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') AS title1,
		SUM(CASE WHEN t.countType = '1' THEN 1 ELSE 0 END) AS count1,
		string_agg(CASE WHEN t.countType = '2' THEN t.id ELSE NULL END, ',') AS id2,
		string_agg(CASE WHEN t.countType = '2' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') AS title2,
		SUM(CASE WHEN t.countType = '2' THEN 1 ELSE 0 END) AS count2,
		string_agg(CASE WHEN t.countType = '3' THEN t.id ELSE NULL END, ',') AS id3,
		string_agg(CASE WHEN t.countType = '3' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') AS title3,
		SUM(CASE WHEN t.countType = '3' THEN 1 ELSE 0 END) AS count3
		from (
		SELECT al.id,al.title,
		al.description,al.priority,al.dev_ip,
		al.email,al.userId,al.userName,al.notice_type,al.stage,al.mobilePhoneNo,al.sendType,al.userType,
		CASE 
		    WHEN count <= ${secondInterval} THEN '1'
		    WHEN count > ${secondInterval} AND count <= ${thirdInterval} THEN '2'
		    WHEN count > ${thirdInterval} THEN '3' 
		    ELSE '' 
		END AS countType
		from (
		SELECT ba.id,a.title,
		a.description,sd.dict_label AS priority,a.dev_ip,
		u.email,u.user_type AS userType,u.user_id AS userId,u.nick_name AS userName,u.phonenumber AS mobilePhoneNo,ba.notice_type,ba.stage,
		CONCAT(
		    CASE WHEN st.wechat_status = '1' THEN '1,' ELSE '' END,
		    CASE WHEN st.phone_status = '1' THEN '2,' ELSE '' END,
		    CASE WHEN st.email_status = '1' THEN '3,' ELSE '' END
		) AS sendType,
		CASE 
		    WHEN to_char(ba.start_time, 'YYYY-MM-DD') > to_char(ba.end_time, 'YYYY-MM-DD') THEN 0
		    WHEN to_char(ba.start_time, 'YYYY-MM-DD') = to_char(ba.end_time, 'YYYY-MM-DD') THEN 
		        floor(extract(epoch from (ba.end_time - ba.start_time)) / 60)
		    ELSE 
		        floor(extract(epoch from (to_timestamp(to_char(ba.start_time, 'YYYY-MM-DD') || ' ' || to_char(ba.end_time, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') - ba.start_time)) / 60) +
		        (SELECT COUNT(1) FROM s_workday WHERE CAST(workday AS timestamp) > ba.start_time AND CAST(workday AS timestamp) < ba.end_time) * #{timeDifference}
		END AS count
		from (
		SELECT
		au.id,
		au.alert_id,
		au.user_id,
		au.assign_time,
		au.status,
		au.stage,
		au.assign_id,
		au.notice_type,
		CASE WHEN w1.id is NULL THEN 
		    (SELECT to_timestamp(MIN(workday) || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS') from s_workday WHERE workday > au.start_time_)
		ELSE au.start_time_ END AS start_time,
		CASE WHEN w2.id is NULL THEN 
		    (SELECT to_timestamp(MAX(workday) || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS') from s_workday WHERE workday < au.end_time_)
		ELSE au.end_time_ END AS end_time
		from
		(SELECT *,
		CASE 
		    WHEN assign_time < to_timestamp(to_char(assign_time, 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS') 
		        THEN to_timestamp(to_char(assign_time, 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS')
		    WHEN assign_time > to_timestamp(to_char(assign_time, 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		        THEN to_timestamp(to_char(date_add('day', 1, assign_time), 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS')
		    ELSE assign_time 
		END AS start_time_,
		CASE 
		    WHEN now() < to_timestamp(to_char(now(), 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS')
		        THEN to_timestamp(to_char(date_add('day', -1, now()), 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		    WHEN now() > to_timestamp(to_char(now(), 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		        THEN to_timestamp(to_char(now(), 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		    ELSE now() 
		END AS end_time_
		from workbench_alert_user
		where status = '2') au
		LEFT JOIN s_workday w1 on w1.workday = to_char(au.start_time_, 'YYYY-MM-DD')
		LEFT JOIN s_workday w2 on w2.workday = to_char(au.end_time_, 'YYYY-MM-DD')
		) ba
		INNER JOIN workbench_alert_info a on ba.alert_id = a.id and a.is_close = '0' and a.is_del = '0'
