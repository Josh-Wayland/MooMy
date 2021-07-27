### Exploratory Data Analysis ###
library(tidyverse)

trans <- DBI::dbGetQuery(moomy, 
"WITH MM_BUY AS (
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
GROUP BY MM_ID")

trans %>% 
  ggplot(aes(x = SUM_CNT))+
  geom_histogram(alpha = 0.55, color = "green")


