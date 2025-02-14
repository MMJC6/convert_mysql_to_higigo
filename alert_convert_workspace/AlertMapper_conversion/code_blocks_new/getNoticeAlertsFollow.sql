SELECT t.userId,t.email,t.mobilePhoneNo,t.userName,t.userType,t.sendType,
		string_agg(t.id, ',') as id,
		string_agg(CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), '#_ssp_#') as title,
		count(1) as count,
		string_agg(CASE WHEN t.countType = '1' THEN t.id ELSE NULL END, ',') as id1,
		string_agg(CASE WHEN t.countType = '1' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') as title1,
		SUM(CASE WHEN t.countType = '1' THEN 1 ELSE 0 END) as count1,
		string_agg(CASE WHEN t.countType = '2' THEN t.id ELSE NULL END, ',') as id2,
		string_agg(CASE WHEN t.countType = '2' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') as title2,
		SUM(CASE WHEN t.countType = '2' THEN 1 ELSE 0 END) as count2,
		string_agg(CASE WHEN t.countType = '3' THEN t.id ELSE NULL END, ',') as id3,
		string_agg(CASE WHEN t.countType = '3' THEN CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) ELSE NULL END, '#_ssp_#') as title3,
		SUM(CASE WHEN t.countType = '3' THEN 1 ELSE 0 END) as count3
		from (
		SELECT al.id,al.title,
		al.description,al.priority,al.dev_ip,
		al.email,al.userId,al.userName,al.notice_type,al.stage,al.mobilePhoneNo,al.sendType,al.userType,
		CASE 
		    WHEN count <= ${secondInterval} THEN '1'
		    WHEN count > ${secondInterval} AND count <= ${thirdInterval} THEN '2'
		    WHEN count > ${thirdInterval} THEN '3' 
		    ELSE '' 
		END as countType
		from (
		SELECT ba.id,a.title,
		a.description,sd.dict_label as priority,a.dev_ip,
		u.email,u.user_type as userType,u.user_id as userId,u.nick_name as userName,u.phonenumber as mobilePhoneNo,ba.notice_type,ba.stage,
		CONCAT(
		    CASE WHEN st.wechat_status = '1' THEN '1,' ELSE '' END,
		    CASE WHEN st.phone_status = '1' THEN '2,' ELSE '' END,
		    CASE WHEN st.email_status = '1' THEN '3,' ELSE '' END
		) as sendType,
		CASE 
		    WHEN to_char(ba.start_time, 'YYYY-MM-DD') > to_char(ba.end_time, 'YYYY-MM-DD') THEN 0
		    WHEN to_char(ba.start_time, 'YYYY-MM-DD') = to_char(ba.end_time, 'YYYY-MM-DD') THEN 
		        floor(extract(epoch from (ba.end_time - ba.start_time)) / 60)
		    ELSE 
		        floor(extract(epoch from (to_timestamp(to_char(ba.start_time, 'YYYY-MM-DD') || ' ' || to_char(ba.end_time, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') - ba.start_time)) / 60) +
		        (SELECT COUNT(1) FROM s_workday WHERE CAST(workday as timestamp) > ba.start_time AND CAST(workday as timestamp) < ba.end_time) * #{timeDifference}
		END as count
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
		au.start_time_ as start_time,
		au.end_time_ as end_time
		from
		(SELECT *,
		CASE 
		    WHEN assign_time < to_timestamp(to_char(assign_time, 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS') 
		        THEN to_timestamp(to_char(assign_time, 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS')
		    WHEN assign_time > to_timestamp(to_char(assign_time, 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		        THEN to_timestamp(to_char(date_add('day', 1, assign_time), 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS')
		    ELSE assign_time 
		END as start_time_,
		CASE 
		    WHEN now() < to_timestamp(to_char(now(), 'YYYY-MM-DD') || #{workBeginTime}, 'YYYY-MM-DD HH24:MI:SS')
		        THEN to_timestamp(to_char(date_add('day', -1, now()), 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		    WHEN now() > to_timestamp(to_char(now(), 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		        THEN to_timestamp(to_char(now(), 'YYYY-MM-DD') || #{workEndTime}, 'YYYY-MM-DD HH24:MI:SS')
		    ELSE now() 
		END as end_time_
		from workbench_alert_user
		where status = '2') au
		) ba
		INNER JOIN workbench_alert_info a on ba.alert_id = a.id and a.is_close = '0' and a.is_del = '0'
