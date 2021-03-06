# MooMy

MooMy is a marketplace app that people can shop for local used goods. The business model is such that for every transaction that occurs on the app, MooMy takes 1%. For example, if a used bike is sold at $100 then MooMy makes $1 on the transaction. The transaction that occurs is similar to how Venmo does it (using APIs to speak to financial institutions).

*Source: [one01 R package](https://github.com/JonWayland/one01)*

## Answering Questions with SQL
Using the `createDB()` function from this package generates the `moomy` database connection while also creating a vector of business questions that can be answered using SQL as shown below:

```
# [1] "What is the average age of users who bought furniture?"                             
# [2] "How many distinct males sold video games?"                                          
# [3] "How many distinct females bought jewelry?"                                          
# [4] "What is the MM_ID of the user who was apart of the most transactions (buy or sell)?"
# [5] "What is the highest costing transaction ID?"                                        
# [6] "How many users apparently sold a product to themselves?"                            
# [7] "How many transactions are in our database?"
```

I went ahead and solved each question and verified it's accuracy using the `qa()` function that also exists within this package. Below are my results (which can also be found in the MooMy_QA.R script).

### What is the average age of users who bought furniture?

```
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
```

### How many distinct males sold video games?

```
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
```

### How many distinct females bought jewelry?

```
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
```

### What is the MM_ID of the user who was apart of the most transactions (buy or sell)?

```
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
```

### What is the highest costing transaction ID?

```
SELECT TRANID FROM TRANSACTION_COSTS WHERE COST = (SELECT MAX(COST) FROM TRANSACTION_COSTS)
```

### How many users apparently sold a product to themselves?

```
SELECT COUNT(*) AS COUNT FROM TRANSACTION_DETAILS WHERE SELLER_MM_ID = BUYER_MM_ID
```

### How many transactions are in our database?

```
SELECT COUNT(*) AS COUNT FROM TRANSACTION_DETAILS WHERE SELLER_MM_ID = BUYER_MM_ID
```

## Exploratory Data Analysis
In addition to answering the provided business questions, I explored the MooMy dataset using visualizations.

![Transactions Histogram](https://github.com/Josh-Wayland/MooMy/blob/main/images/Trans_Histogram.PNG)




