library(one01)
#creates DB
createDB()
#list tables from moomy
DBI::dbListTables(moomy)
#list questions
questions
# [1] "What is the average age of users who bought furniture?"                             
# [2] "How many distinct males sold video games?"                                          
# [3] "How many distinct females bought jewelry?"                                          
# [4] "What is the MM_ID of the user who was apart of the most transactions (buy or sell)?"
# [5] "What is the highest costing transaction ID?"                                        
# [6] "How many users apparently sold a product to themselves?"                            
# [7] "How many transactions are in our database?"

DBI::dbGetQuery(moomy, "select * from PRODUCT_MAP limit 10")
DBI::dbGetQuery(moomy, "select * from TRANSACTION_COSTS limit 10")
DBI::dbGetQuery(moomy, "select * from TRANSACTION_DEMOG limit 10")
DBI::dbGetQuery(moomy, "select * from TRANSACTION_DETAILS limit 10")
DBI::dbGetQuery(moomy, "select * from TRANSACTION_PRODUCTS limit 10")

#7
qry <- "
SELECT COUNT(*) AS COUNT FROM TRANSACTION_DETAILS
"
#6
qry <- "
SELECT COUNT(*) AS COUNT FROM TRANSACTION_DETAILS WHERE SELLER_MM_ID = BUYER_MM_ID
"
#5
qry <- "
SELECT TRANID FROM TRANSACTION_COSTS WHERE COST = (SELECT MAX(COST) FROM TRANSACTION_COSTS)

"
#4
qry <- "
WITH MM_BUY AS (
SELECT TDM.MM_ID, COUNT(*) AS CNT
FROM TRANSACTION_DEMOG AS TDM
INNER JOIN TRANSACTION_DETAILS AS TD
ON TD.BUYER_MM_ID = TDM.MM_ID
GROUP BY TDM.MM_ID
)
, MM_SELL AS (
SELECT TDM.MM_ID, COUNT(*) AS CNT
FROM TRANSACTION_DEMOG AS TDM
INNER JOIN TRANSACTION_DETAILS AS TD
ON TD.SELLER_MM_ID = TDM.MM_ID
GROUP BY TDM.MM_ID
)
SELECT MM_ID, SUM(CNT) SUM_CNT FROM
(SELECT * FROM MM_BUY MB
UNION 
SELECT * FROM MM_SELL MS
)
GROUP BY MM_ID ORDER BY SUM_CNT DESC
LIMIT 1
"
#3
qry <- "
SELECT
COUNT(*) AS CNT

FROM (
SELECT DISTINCT TDM.MM_ID
FROM

TRANSACTION_PRODUCTS AS TP
INNER JOIN TRANSACTION_DETAILS AS TD
ON TD.TRANSACTION_ID = TP.TRANSACTION_ID
AND TP.PRODUCT_ID = '6' /* Jewelry */


INNER JOIN TRANSACTION_DEMOG AS TDM
ON TD.BUYER_MM_ID = TDM.MM_ID


WHERE TDM.GENDER = 'F')
"
#2
qry <- "
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
"
#1
qry <- "
select  

AVG(TDM.AGE) as AVG_AGE

FROM TRANSACTION_PRODUCTS AS TP

INNER JOIN TRANSACTION_DETAILS AS TD
ON TP.TRANSACTION_ID = TD.TRANSACTION_ID

INNER JOIN TRANSACTION_DEMOG AS TDM
ON TD.BUYER_MM_ID = TDM.MM_ID

INNER JOIN PRODUCT_MAP AS PM
ON TP.PRODUCT_ID = PM.PID
AND PM.CATEGORY = 'Furniture'

"

DBI::dbGetQuery(moomy,qry)


  qa(qry,Q=4)






