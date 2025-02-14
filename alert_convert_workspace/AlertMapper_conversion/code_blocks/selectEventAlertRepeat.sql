SELECT COUNT(1) count,GROUP_CONCAT(e.id) eventId,GROUP_CONCAT(CONCAT('“#Case',e.event_no,'-',e.title,'”') separator '、') eventTitle,
			a.title,a.description,a.dev_ip devIp,a.priority
		FROM `event` e
			INNER JOIN (
				SELECT ea.event_id,ai.title,ai.description,ai.dev_ip,ai.priority,ai.csrcip,ai.cdstip from event_alerts ea ,workbench_alert_info ai
				where ea.`status` = '1' and ea.source_id = '1' and ai.is_close = '0' and ai.`status` != '0' and ea.alert_id = ai.id
			) a ON e.id = a.event_id
		where e.`status` = '1' and e.is_close = '0'
		GROUP BY a.title,a.description,a.dev_ip,a.priority,a.csrcip,a.cdstip
		HAVING count > 1