SELECT 
ROUND(100.0 * SUM( CASE WHEN
c.country_id <> r.country_id THEN 1 ELSE NULL END)/COUNT(*),1) AS international_call_pct
FROM phone_calls calls
LEFT JOIN phone_info c ON c.caller_id = calls.caller_id
LEFT JOIN phone_info r ON r.caller_id = calls.receiver_id;



