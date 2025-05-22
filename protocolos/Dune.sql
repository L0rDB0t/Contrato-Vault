-- Consulta para rastrear depósitos y retiros
SELECT
  date_trunc('day', evt_block_time) AS day,
  SUM(CASE WHEN evt_type = 'Deposit' THEN amount ELSE 0 END) AS deposits,
  SUM(CASE WHEN evt_type = 'Withdraw' THEN amount ELSE 0 END) AS withdrawals
FROM (
  SELECT evt_block_time, 'Deposit' AS evt_type, amount
  FROM sepolia.SecureVault_events_Deposit
  
  UNION ALL
  
  SELECT evt_block_time, 'Withdraw' AS evt_type, amount
  FROM sepolia.SecureVault_events_Withdraw
) AS events
GROUP BY day
ORDER BY day DESC;