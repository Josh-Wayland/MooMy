SELECT
COUNT(*) AS CNT

FROM (
SELECT DISTINCT TDM.MM_ID
FROM

TRANSACTION_PRODUCTS AS TP
INNER JOIN TRANSACTION_DETAILS AS TD
ON TD.TRANSACTION_ID = TP.TRANSACTION_ID
AND TP.PRODUCT_ID = '1' /* Video Games */


INNER JOIN TRANSACTION_DEMOG AS TDM
ON TD.SELLER_MM_ID = TDM.MM_ID

WHERE TDM.GENDER = 'M')