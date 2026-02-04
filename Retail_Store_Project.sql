--DATA PREPARATION AND UNDERSTANDING

SELECT TOP 1* FROM Customer
SELECT TOP 1* FROM prod_cat_info
SELECT TOP 1* FROM Transactions

--1)
SELECT COUNT(*) AS cnt FROM Customer
UNION
SELECT COUNT(*) AS cnt FROM prod_cat_info
UNION
SELECT COUNT(*) AS cnt FROM Transactions

--2)
SELECT COUNT(DISTINCT(transaction_id)) AS Total_Transaction_returned
FROM Transactions AS A
WHERE A.total_amt<0

--3)
SELECT CONVERT(date,tran_date,105) AS tran_dates FROM Transactions

--4)
SELECT DATEDIFF(DAY,MIN(CONVERT(date,tran_date,105)),MAX(CONVERT(date,tran_date,105))) AS DIFF_DAY,
DATEDIFF(MONTH,MIN(CONVERT(date,tran_date,105)),MAX(CONVERT(date,tran_date,105))) DIFF_MONTH,
DATEDIFF(YEAR,MIN(CONVERT(date,tran_date,105)),MAX(CONVERT(date,tran_date,105))) DIFF_YEAR
FROM Transactions

--5)
SELECT prod_cat,prod_subcat FROM prod_cat_info
WHERE prod_subcat='DIY'

--6)


--DATA ANALYSIS
SELECT TOP 1* FROM Customer
SELECT TOP 1* FROM prod_cat_info
SELECT TOP 1* FROM Transactions

--1)
SELECT TOP 1 Store_type,COUNT(transaction_id) AS Cnt_Tran FROM Transactions
GROUP BY Store_type
ORDER BY Cnt_Tran DESC

--2)
SELECT Gender,COUNT(*) AS Cnt_ FROM Customer
GROUP BY Gender
HAVING Gender IN ('M','F')

--3)
SELECT TOP 1 city_code,COUNT(*) AS Total_Cnt FROM Customer
GROUP BY city_code
ORDER BY Total_Cnt DESC

--4)
SELECT prod_cat,prod_subcat FROM prod_cat_info
WHERE prod_cat='Books'

--5)
SELECT prod_cat_code,MAX(Qty) Max_pod FROM Transactions
GROUP BY prod_cat_code

--6)
SELECT SUM(CAST(B.total_amt AS float)) AS Total_revenue FROM prod_cat_info AS A
INNER JOIN Transactions AS B
ON A.prod_cat_code=B.prod_cat_code AND A.prod_sub_cat_code=B.prod_subcat_code
WHERE A.prod_cat='Books' OR A.prod_cat='Electronics'

--7)
SELECT COUNT(*) AS Total_cnt FROM(
SELECT cust_id,COUNT(DISTINCT(transaction_id)) AS Cnt_tran FROM Transactions
WHERE Qty > 0
GROUP BY cust_id
HAVING COUNT(DISTINCT(transaction_id)) > 10
) AS T

--8)
SELECT SUM(cast(B.total_amt AS float)) AS Combined_revenue FROM prod_cat_info AS A
INNER JOIN Transactions AS B
ON A.prod_cat_code=B.prod_cat_code AND A.prod_sub_cat_code=B.prod_subcat_code
WHERE A.prod_cat IN ('Electronics','Clothing') AND B.Store_type='Flagship store' AND B.Qty>0

--9)
SELECT A.prod_subcat,SUM(CAST(B.total_amt AS float)) AS Total_revenue FROM prod_cat_info AS A
INNER JOIN Transactions AS B
ON A.prod_cat_code=B.prod_cat_code AND A.prod_sub_cat_code=B.prod_subcat_code
INNER JOIN Customer AS C
ON B.cust_id=C.customer_Id
WHERE C.Gender='M' AND A.prod_cat='Electronics'
GROUP BY A.prod_subcat

--10)
--Percentage of Sales
SELECT T1.prod_subcat,T1.Percentage_sales,T2.Percentage_returns FROM(
SELECT TOP 5 A.prod_subcat,SUM(CAST(B.total_amt AS float))/( SELECT SUM(CAST(total_amt AS float)) FROM Transactions WHERE QTY>0) AS Percentage_sales
FROM prod_cat_info AS A
INNER JOIN Transactions AS B 
ON A.prod_cat_code=B.prod_cat_code AND A.prod_sub_cat_code=B.prod_subcat_code
WHERE B.Qty>0
GROUP BY A.prod_subcat) AS T1
INNER JOIN
--Percentage of Sales
(
SELECT A.prod_subcat,SUM(CAST(B.total_amt AS float))/( SELECT SUM(CAST(total_amt AS float)) FROM Transactions WHERE QTY<0) AS Percentage_returns
FROM prod_cat_info AS A
INNER JOIN Transactions AS B 
ON A.prod_cat_code=B.prod_cat_code AND A.prod_sub_cat_code=B.prod_subcat_code
WHERE B.Qty<0
GROUP BY A.prod_subcat) AS T2
ON T1.prod_subcat=T2.prod_subcat

--11)
--AGE OF CUSTOMER
SELECT * FROM(
SELECT * FROM (
SELECT cust_id,DATEDIFF(YEAR,DOB,Max_date) AS Age,revenue FROM(
SELECT B.cust_id,DOB,MAX(CONVERT(date,tran_date,105)) AS Max_date,SUM(CAST(total_amt AS float)) AS revenue FROM Customer AS A
INNER JOIN Transactions AS B
ON A.customer_Id=B.cust_id
WHERE QTY>0
GROUP BY B.cust_id,DOB
) AS T
     ) AS Q
WHERE Q.Age BETWEEN 25 AND 35
       ) AS C
INNER JOIN(

--LAST 30 DAYS OF Transactions
SELECT cust_id,CONVERT(date,tran_date,105) AS Tran_date FROM Transactions
GROUP BY cust_id,CONVERT(date,tran_date,105)
HAVING CONVERT(date,tran_date,105)>=(SELECT DATEADD(DAY,-30,MAX(CONVERT(date,tran_date,105))) AS Cutoff_date FROM Transactions)
) AS D
ON C.cust_id=D.cust_id

--12)
SELECT TOP 1 prod_cat_code,SUM(Returns) AS Total_returns FROM (
SELECT prod_cat_code,CONVERT(date,tran_date,105) AS Tran_date,SUM(Qty) AS Returns
FROM Transactions
WHERE Qty < 0
GROUP BY prod_cat_code,CONVERT(date,tran_date,105)
HAVING CONVERT(date,tran_date,105)>=(SELECT DATEADD(MONTH,-3,MAX(CONVERT(date,tran_date,105))) AS Cutoff_date FROM Transactions)
) AS A
GROUP BY prod_cat_code
ORDER BY Total_returns

--13)
SELECT Store_type,SUM(CAST(total_amt AS float)) AS Revenue,SUM(QTY) Total_qty FROM Transactions
WHERE Qty > 0
GROUP BY Store_type
ORDER BY Revenue DESC,Total_qty DESC

--14)
SELECT prod_cat_code,AVG(CAST(total_amt AS float)) AS AVG_revenue FROM Transactions
WHERE Qty > 0
GROUP BY prod_cat_code
HAVING AVG(CAST(total_amt AS float)) >= (SELECT AVG(CAST(total_amt AS float)) FROM Transactions WHERE QTY > 0)

--15)
SELECT prod_subcat_code,AVG(CAST(total_amt AS float)) AS avg_revenue,SUM(CAST(total_amt AS float)) AS revenue FROM Transactions
WHERE Qty > 0 AND prod_cat_code IN (SELECT TOP 5 prod_cat_code FROM Transactions
WHERE Qty > 0
GROUP BY prod_cat_code
ORDER BY SUM(Qty) DESC
)
GROUP BY prod_subcat_code

SELECT TOP 5 prod_cat_code,SUM(Qty) AS QTY_ FROM Transactions
WHERE Qty > 0
GROUP BY prod_cat_code
ORDER BY QTY_ DESC






























































































































































































































































