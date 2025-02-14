DELETE tem FROM workbench_alert_info_temporary tem WHERE EXISTS(
			SELECT '' FROM workbench_alert_info info WHERE tem.alert_no = info.alert_no
		)