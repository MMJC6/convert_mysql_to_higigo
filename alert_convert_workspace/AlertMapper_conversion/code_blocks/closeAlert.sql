update workbench_alert_info
		set is_close = '1'
		where is_epicycle_end = '1'
		  and is_close = '0'