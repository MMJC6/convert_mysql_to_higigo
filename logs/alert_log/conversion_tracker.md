# Alert Folder Conversion Tracker

## Files to Convert
- [ ] AlertMapper.xml
- [ ] WorkbenchAlertAssignMapper.xml
- [ ] WorkbenchAlertOperationLogMapper.xml
- [ ] WorkbenchAlertUserMapper.xml
- [ ] WorkbenchDutyNoticeCountMapper.xml
- [x] WorkbenchNoticeSendBatchMapper.xml
- [x] WorkbenchNoticeSendRecordMapper.xml
- [ ] WorkbenchScheduleTaskMapper.xml

## Conversion Progress
### AlertMapper.xml
Started: ${date}

Functions to convert:
- [x] DATE_FORMAT
- [x] IFNULL
- [x] GROUP_CONCAT
- [x] UUID
- [x] STR_TO_DATE
- [x] TIMESTAMPDIFF
- [x] DATE_ADD
- [x] FROM_UNIXTIME

Structure changes:
- [ ] Multi-table UPDATE splits
- [ ] HAVING conditions
- [ ] REPLACE INTO conversions
- [ ] Status value conversions
- [ ] BETWEEN string conversions
- [ ] Backtick removals
- [ ] Explicit AS additions
