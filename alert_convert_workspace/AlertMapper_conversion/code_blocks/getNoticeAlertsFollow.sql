SELECT t.userId,t.email,t.mobilePhoneNo,t.userName,t.userType,t.sendType,
		GROUP_CONCAT(t.id) id,
		GROUP_CONCAT(CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description) SEPARATOR '#_ssp_#') title,
		count(1) count,
		GROUP_CONCAT(IF(t.countType = '1',t.id,NULL)) id1,
		GROUP_CONCAT(IF(t.countType = '1',CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), NULL ) SEPARATOR '#_ssp_#' ) title1,
		SUM(IF(t.countType = '1',1,0)) count1,
		GROUP_CONCAT(IF(t.countType = '2',t.id,NULL)) id2,
		GROUP_CONCAT(IF(t.countType = '2',CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), NULL ) SEPARATOR '#_ssp_#' ) title2,
		SUM(IF(t.countType = '2',1,0)) count2,
		GROUP_CONCAT(IF(t.countType = '3',t.id,NULL)) id3,
		GROUP_CONCAT(IF(t.countType = '3',CONCAT_WS('@_ssp_@',t.title,t.priority,t.dev_ip,t.description), NULL ) SEPARATOR '#_ssp_#' ) title3,
		SUM(IF(t.countType = '3',1,0)) count3
		from (
		SELECT al.id,al.title,
		al.description,al.priority,al.dev_ip,
		al.email,al.userId,al.userName,al.notice_type,al.stage,al.mobilePhoneNo,al.sendType,al.userType,
		CASE when count <= ${secondInterval} then '1'
		when count > ${secondInterval} and count <= ${thirdInterval} then '2'
		when count > ${thirdInterval} then '3' else '' end as countType
		from (
		SELECT ba.id,a.title,
		a.description,sd.dict_label priority,a.dev_ip,
		u.email,u.user_type as userType,u.user_id as userId,u.nick_name as userName,u.phonenumber as mobilePhoneNo,ba.notice_type,ba.stage,
		CONCAT(IF(st.wechat_status = '1','1,',''),IF(st.phone_status = '1','2,',''),IF(st.email_status = '1','3,','')) sendType,
		case WHEN DATE_FORMAT(ba.start_time, '%Y-%m-%d') > DATE_FORMAT(ba.end_time, '%Y-%m-%d') then 0
		WHEN DATE_FORMAT(ba.start_time, '%Y-%m-%d') = DATE_FORMAT(ba.end_time, '%Y-%m-%d') then TIMESTAMPDIFF(MINUTE, ba.start_time, ba.end_time)
		ELSE TIMESTAMPDIFF(MINUTE, ba.start_time, CONCAT( DATE_FORMAT(ba.start_time, '%Y-%m-%d'), ' ', DATE_FORMAT(ba.end_time, '%T'))) +
		( SELECT COUNT(1) FROM s_workday WHERE CAST(workday as datetime) > ba.start_time AND CAST(workday as datetime) < ba.end_time ) * #{timeDifference} end count
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
		au.start_time_ start_time,
		au.end_time_ end_time
		from
		(SELECT *,
		CASE WHEN assign_time < CONCAT(DATE_FORMAT(assign_time, '%Y-%m-%d'),#{workBeginTime}) then CONCAT(DATE_FORMAT(assign_time, '%Y-%m-%d'),#{workBeginTime})
		WHEN  assign_time > CONCAT(DATE_FORMAT(assign_time, '%Y-%m-%d'),#{workEndTime}) then CONCAT(DATE_FORMAT(date_add(assign_time, interval 1 day), '%Y-%m-%d'),#{workBeginTime})
		ELSE assign_time END as start_time_,
		CASE WHEN now() < CONCAT(DATE_FORMAT(now(), '%Y-%m-%d'),#{workBeginTime}) then CONCAT(DATE_FORMAT(date_add(now(), interval -1 day), '%Y-%m-%d'),#{workEndTime})
		WHEN  now() > CONCAT(DATE_FORMAT(now(), '%Y-%m-%d'),#{workEndTime}) then CONCAT(DATE_FORMAT(now(), '%Y-%m-%d'),#{workEndTime})
		ELSE now() END as end_time_
		from workbench_alert_user
		where status = '2') au
		) ba
		INNER JOIN workbench_alert_info a on ba.alert_id = a.id and a.is_close = '0' and a.is_del = '0'