-- Task: Write a SQL query to find the Name and City of all customers who are from the country 'Denmark'.

SELECT name, city
FROM customers
WHERE country = 'Denmark'

-- Task: Write a SQL query to find the total quantity of books each customer has ordered. Your result should display the customer's Name and the Total Quantity they have ordered. List the customers who have ordered the most books first

SELECT C.name, SUM(O.quantity) AS total_quantity
FROM customers AS C
INNER JOIN orders AS O ON
C.customer_id = O.customer_id
WHERE O.order_id IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC

-- Task: Write a SQL query to find the total revenue generated from each book genre in the year 2023. The results should show the Genre and the Total Revenue. Only include genres that generated more than $5000 in total revenue.

SELECT B.genre, SUM(O.total_amount) AS total_revenue
FROM books AS B
INNER JOIN orders AS O ON
B.book_id = O.book_id
WHERE EXTRACT(YEAR FROM O.order_date :: DATE) = '2023'
GROUP BY 1
HAVING SUM(O.total_amount) > 5000
ORDER BY 2 DESC

-- Task: Write a SQL query to find the second most recent order for each customer. Your result should display the Customer_ID, Order_ID, and Order_Date. If a customer has only one order, they should not appear in the result.

WITH T1 AS (SELECT customer_id, order_id, order_date,
			ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS rnk
			FROM orders)
			
SELECT customer_id, order_id, order_date
FROM T1
WHERE rnk = 2

-- Task: Write a SQL query to analyze sales performance by genre. Your query should calculate two things for each book genre:

-- The total number of distinct books ordered.

-- A sales performance category based on the total quantity of all books sold in that genre.

-- The performance categories are:

-- 'High': More than 150 books sold in total.

-- 'Medium': Between 50 and 150 books sold in total (inclusive).

-- 'Low': Fewer than 50 books sold in total.

SELECT B.genre, 
COUNT(DISTINCT O.book_id) AS distinct_book_count,
CASE
WHEN SUM(O.quantity) > 150 THEN 'High'
WHEN SUM(O.quantity) BETWEEN 50 AND 150 THEN 'Medium'
ELSE 'Low'
END AS sales_performance
FROM books AS B
INNER JOIN orders AS O ON
B.book_id = O.book_id
GROUP BY 1
ORDER BY 2 DESC

-- Task: Write a SQL query to find the names of all customers who have never ordered a book from the 'Fantasy' genre. This will require you to first find all customers who have ordered a fantasy book and then exclude them from your final list

SELECT name
FROM customers 
WHERE customer_id NOT IN(SELECT DISTINCT O.customer_id
						FROM orders AS O
						INNER JOIN books AS B ON
						O.book_id = B.book_id
						WHERE B.genre = 'Fantasy')

-- Task: Write a SQL query to identify the top-spending customer in each country. If there's a tie in spending, include all customers with the top amount.

WITH T1 AS (SELECT C.name, C.country,
			SUM(O.total_amount) AS total_amount
			FROM customers AS C
			INNER JOIN orders AS O ON
			C.customer_id = O.customer_id
			GROUP BY 1,2),

T2 AS(SELECT name, country, total_amount,
	DENSE_RANK() OVER(PARTITION BY country ORDER BY total_amount DESC) AS rnk
	FROM T1)
	
SELECT country, name, total_amount
FROM T2
WHERE rnk = 1
ORDER BY 1


-- Write a SQL query to calculate the number of days between each customer's consecutive orders.

WITH T1 AS (SELECT customer_id, order_id, order_date,
			LAG(order_date,1) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
			FROM orders)

SELECT customer_id, order_id, order_date,
(order_date - previous_order_date) AS days_since_last_order
FROM T1
WHERE previous_order_date IS NOT NULL
ORDER BY 1

-- Task: Write a SQL query to find all pairs of books that share the same Genre and were published in the same Published_Year

SELECT B1.title AS book_1, 
B2.title AS book_2, B1.genre, B1.published_year
FROM books AS B1
INNER JOIN books AS B2 ON
B1.genre = B2.genre
AND B1.published_year = B2.published_year
WHERE B1.book_id < B2.book_id
ORDER BY 4

-- Task: Write a SQL query to calculate a running total of each customer's spending over time.

SELECT C.name, O.order_date, O.total_amount,
SUM(O.total_amount) OVER(PARTITION BY C.customer_id ORDER BY O.total_amount) AS running_total
FROM customers AS C
INNER JOIN orders AS O ON
C.customer_id = O.customer_id
ORDER BY 1

-- Task: Write a single SQL query to create a customer spending summary. The report should show each customer's Name, followed by their total spending for each year on record (2022, 2023, and 2024), with each year's total in its own separate column. Finally, include a Grand_Total column showing their total spending across all years.

-- For the final report, only include customers whose grand total spending is more than $500. Order the results by the grand total in descending order.

SELECT C.name,
SUM(CASE WHEN EXTRACT(YEAR FROM O.order_date:: date) = '2022' THEN O.total_amount END)AS spending_2022,
SUM(CASE WHEN EXTRACT(YEAR FROM O.order_date:: date) = '2023' THEN O.total_amount END)AS spending_2023,
SUM(CASE WHEN EXTRACT(YEAR FROM O.order_date:: date) = '2024' THEN O.total_amount END)AS spending_2024,
SUM(O.total_amount) AS grand_total
FROM customers AS C
INNER JOIN orders AS O ON
C.customer_id = O.customer_id
GROUP BY 1
HAVING SUM(O.total_amount) > 500
ORDER BY 5 DESC


-- Task: Write a SQL query to calculate the 3-day rolling average of total daily sales revenue.

WITH T1 AS (SELECT order_date, SUM(total_amount) AS total_revenue
			FROM orders
			GROUP BY 1)

SELECT order_date,
ROUND(AVG(total_revenue) OVER(ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_3_day_avg
FROM T1
ORDER BY 1 ASC

-- Task: Write a SQL query to find the first-ever order date and last order date for each customer and display that date next to every order that the customer has made.

SELECT C.name, O.order_id, O.order_date,
FIRST_VALUE(O.order_date) OVER(PARTITION BY O.customer_id ORDER BY O.order_date) AS first_order_date,
LAST_VALUE(O.order_date) OVER(PARTITION BY O.customer_id ORDER BY O.order_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_order_date
FROM customers AS C
INNER JOIN orders AS O ON
C.customer_id = O.customer_id
ORDER BY 1

-- Task: Write a SQL query to segment customers into four spending quartiles based on their total lifetime spending

WITH T1 AS(SELECT C.name, 
			SUM(O.total_amount) AS total_spending
			FROM customers AS C
			INNER JOIN orders AS O ON
			C.customer_id = O.customer_id
			GROUP BY 1)

SELECT *,
NTILE(4) OVER(ORDER BY total_spending DESC) AS spending_quartile
FROM T1
ORDER BY spending_quartile, total_spending DESC

-- Task: Write a SQL query to count the number of unique customers who placed an order in each month of the year 2023.

SELECT TO_CHAR(Order_date, 'YYYY-MM') AS months,
COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE EXTRACT(YEAR FROM order_date :: DATE) = '2023'
GROUP BY 1
ORDER BY 1 ASC

-- Task: Write a SQL query to find all customers who have purchased at least one book that costs more than $49.00.

SELECT C.customer_id,
C.name
FROM customers AS C
WHERE EXISTS(SELECT 1 FROM orders AS O 
				INNER JOIN books AS B
				ON B.book_id = O.book_id
				WHERE O.customer_id = C.customer_id
				AND B.price > 49)
ORDER BY 2

-- Task: Write a SQL query to calculate the percentage growth in the number of unique books sold for each genre, month-over-month.

WITH T1 AS(SELECT TO_CHAR(O.order_date, 'YYYY-MM') AS sales_month,
		COUNT(O.book_id) AS unique_book_sold,
		B.genre
		FROM orders AS O
		INNER JOIN books AS B ON
		O.book_id = B.book_id
		GROUP BY 1, 3),

T2 AS(SELECT genre, sales_month, unique_book_sold,
	LAG(unique_book_sold,1,0) OVER(PARTITION BY genre ORDER BY sales_month) AS previous_month_sale
	FROM T1)

SELECT genre, sales_month, unique_book_sold,
CASE
WHEN previous_month_sale = 0 THEN NULL
ELSE ROUND(((CAST(unique_book_sold AS REAL) - previous_month_sale)/previous_month_sale) * 100,2)
END AS mom_growth
FROM  T2

-- Task: Write a SQL query to identify the top 5 most common email service providers used by your customers.

SELECT SPLIT_PART(email,'@',2) AS email_provider,
COUNT(email) AS customer_count
FROM customers
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Task: Write a SQL query to calculate what percentage of the total revenue each book genre contributes

WITH T1 AS(SELECT B.genre,
		SUM(O.total_amount) AS genre_revenue
		FROM books AS B
		INNER JOIN orders AS O 
		ON B.book_id = O.book_id
		GROUP BY 1)

SELECT genre, genre_revenue,
ROUND(genre_revenue * 100/ SUM(genre_revenue) OVER(),2) AS percentage_total
FROM T1
ORDER BY 3 DESC

-- Identify "loyal customers" (those who made purchases in at least 3 different months)
-- and then calculate their average number of days between consecutive orders.

WITH LoyalCustomers AS (
    SELECT
        Customer_ID
    FROM
        Orders
    GROUP BY
        Customer_ID
    HAVING
        COUNT(DISTINCT DATE_TRUNC('month',Order_Date)) >= 3
),
CustomerOrderGaps AS (
    SELECT
        Customer_ID,
        Order_Date - LAG(Order_Date, 1) OVER (
            PARTITION BY Customer_ID ORDER BY Order_Date
        ) AS Days_Between_Orders
    FROM
        Orders
)
SELECT
    C.Name,
    ROUND(AVG(G.Days_Between_Orders), 2) AS Avg_Days_Between_Orders
FROM
    CustomerOrderGaps AS G
INNER JOIN
    LoyalCustomers AS L ON G.Customer_ID = L.Customer_ID
INNER JOIN
    Customers AS C ON G.Customer_ID = C.Customer_ID
GROUP BY
    C.Name
ORDER BY
    Avg_Days_Between_Orders;























