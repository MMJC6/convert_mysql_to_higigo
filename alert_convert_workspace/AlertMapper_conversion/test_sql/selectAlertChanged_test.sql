-- Test case 1: Basic query test
SELECT value
FROM tbl_sequence
WHERE sequence_name = 'alert_rule_change';

-- Test case 2: Test with sample data
-- Insert test data
INSERT INTO tbl_sequence (sequence_name, value) 
VALUES ('alert_rule_change', '123');

-- Run query
SELECT value
FROM tbl_sequence
WHERE sequence_name = 'alert_rule_change';

-- Cleanup
DELETE FROM tbl_sequence 
WHERE sequence_name = 'alert_rule_change';
