WITH ranks AS (SELECT user_id,spend,transaction_date,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) AS transaction_number
FROM transactions)
SELECT user_id,spend,transaction_date
FROM ranks
WHERE transaction_number = 3;