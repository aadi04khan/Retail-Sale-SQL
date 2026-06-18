---create table
DROP TABLE IF EXISTS REAIL_SALES;

CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

SELECT
	*
FROM
	RETAIL_SALES
LIMIT
	10;

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

-- Data Cleaning
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL;

----
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE IS NULL;

----
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_TIME IS NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

----
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

---- Data Expolaration
-- How many sales are we have..?
SELECT
	COUNT(*) AS TOTAL_SALE
FROM
	RETAIL_SALES;

-- How many customer we have 
SELECT DISTINCT
	CUSTOMER_ID AS TOTAL_CUSTOMER
FROM
	RETAIL_SALES;

SELECT DISTINCT
	CATEGORY AS TOTAL_CUSTOMER
FROM
	RETAIL_SALES;

-- Data Analysis & business key problems and answer
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
---Q1) Write a SQL query to retrive all columns fr sales made  on '2022-11-05'
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'yyyy-mm') = '2022-11'
	AND QUANTIY >= 3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_WORTH,
	COUNT(*) AS TOTAL_ORDER
FROM
	RETAIL_SALES
GROUP BY
	1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(AGE), 2) AS AVG_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000
	-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY,
	GENDER
ORDER BY
	1
	-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
	YEAR,
	MONTH,
	AVG_SALES
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			AVG(TOTAL_SALE) AS AVG_SALES,
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						MONTH
						FROM
							SALE_DATE
					)
				ORDER BY
					AVG(TOTAL_SALE) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			1,
			2
			--order by 1, 3 desc
	) AS T1
WHERE
	RANK = 1
	-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE)
FROM
	RETAIL_SALES
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5
	-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID)
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY
	-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH
	HOURLY_SALE AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) < 12 THEN 'Morning'
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'Evening'
			END AS SHIFT_ROUTINE
		FROM
			RETAIL_SALES
	)
SELECT
	SHIFT_ROUTINE,
	COUNT(*) AS TOTAL_ORDER
FROM
	HOURLY_SALE
GROUP BY
	SHIFT_ROUTINE