# Bookstore Sales - SQL Analytics Project

![SQL](https://img.shields.io/badge/Language-SQL-blue.svg)
![Database](https://img.shields.io/badge/Database-PostgreSQL-blue.svg)
![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## Project Description

This project is a deep dive into SQL-based data analysis, centered around a fictional online bookstore's sales data. The core objective is to write advanced SQL queries to answer 20 business-centric questions. The analysis focuses on uncovering insights related to customer behavior, sales trends, genre performance, and identifying top-performing books and loyal customers.

---

## Features

-   **Customer Behavior Analysis**: Identifies loyal customers, their purchase frequency, and lifetime value.
-   **Sales Trend Analysis**: Calculates month-over-month growth by genre and identifies seasonal trends.
-   **Performance Metrics**: Ranks books by sales, determines the most profitable genres, and analyzes author performance.
-   **Advanced Analytics**: Employs window functions, CTEs, subqueries, and complex joins to derive deep insights from the transactional data.

---

## Database Schema

The database schema is simple and effective, consisting of three core tables.

| Table Name | Description | Key Columns |
|---|---|---|
| `Customers` | Stores information about each registered customer. | `Customer_ID`, `Name`, `Age`, `Join_Date` |
| `Books` | Contains details for each book, including genre, author, and price. | `Book_ID`, `Title`, `Author`, `Genre`, `Price` |
| `Orders` | The transactional table linking customers to the books they've purchased. | `Order_ID`, `Customer_ID`, `Book_ID`, `Order_Date`, `Quantity` |

---

## SQL Queries & Analysis

This project answers 20 key analytical questions to provide a complete overview of the bookstore's operations.

*(Note: The full queries are available in the `Bookstore analysis.sql` file. Snippets or full queries for key questions are shown below.)*

### 1. Total number of orders
```sql
SELECT COUNT(DISTINCT Order_ID) as Total_Orders 
FROM Orders;
```

### 2. Total revenue generated
```sql
SELECT ROUND(SUM(B.Price * O.Quantity), 2) AS Total_Revenue
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID;
```

### 3. Average order value
```sql
WITH OrderTotals AS (
    SELECT
        O.Order_ID,
        SUM(B.Price * O.Quantity) AS Order_Total
    FROM Orders O
    JOIN Books B ON O.Book_ID = B.Book_ID
    GROUP BY O.Order_ID
)
SELECT ROUND(AVG(Order_Total), 2) AS Average_Order_Value
FROM OrderTotals;
```

### 4. Top 5 best-selling books
```sql
SELECT
    B.Title,
    SUM(O.Quantity) AS Total_Quantity_Sold
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Title
ORDER BY Total_Quantity_Sold DESC
LIMIT 5;
```

### 5. Number of unique customers
```sql
SELECT COUNT(DISTINCT Customer_ID) AS Unique_Customers FROM Customers;
```

### 6. Top 5 customers by spending
```sql
SELECT
    C.Name,
    ROUND(SUM(B.Price * O.Quantity), 2) AS Total_Spent
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
JOIN Customers C ON O.Customer_ID = C.Customer_ID
GROUP BY C.Name
ORDER BY Total_Spent DESC
LIMIT 5;
```

### 7. Monthly revenue trend
```sql
SELECT
    TO_CHAR(Order_Date, 'YYYY-MM') AS Sale_Month,
    ROUND(SUM(B.Price * O.Quantity), 2) AS Monthly_Revenue
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY Sale_Month
ORDER BY Sale_Month;
```

### 8. Most popular genre
```sql
SELECT
    B.Genre,
    SUM(O.Quantity) AS Total_Quantity_Sold
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Genre
ORDER BY Total_Quantity_Sold DESC
LIMIT 1;
```

### 9. Average age of customers
```sql
SELECT ROUND(AVG(Age),0) AS Average_Customer_Age FROM Customers;
```

### 10. Customer Lifetime Value (CLV)
```sql
SELECT
    C.Name,
    ROUND(SUM(B.Price * O.Quantity), 2) AS Lifetime_Value
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
JOIN Customers C ON O.Customer_ID = C.Customer_ID
GROUP BY C.Name
ORDER BY Lifetime_Value DESC;
```

### 11. Month-over-Month (MoM) revenue growth
```sql
-- Full solution using LAG() window function is in the .sql file
```

### 12. Top 3 authors by sales revenue
```sql
SELECT
    B.Author,
    ROUND(SUM(B.Price * O.Quantity), 2) AS Total_Revenue
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Author
ORDER BY Total_Revenue DESC
LIMIT 3;
```

### 13. Average number of books per order
```sql
SELECT AVG(Books_Per_Order) AS Avg_Books_Per_Order
FROM (
    SELECT Order_ID, SUM(Quantity) AS Books_Per_Order
    FROM Orders
    GROUP BY Order_ID
) AS Order_Summary;
```

### 14. Percentage of total revenue by each genre
```sql
-- Full solution using window functions is in the .sql file
```

### 15. New vs. repeat customers each month
```sql
-- Full solution using LAG() and CTEs is in the .sql file
```

### 16. Average price of books in each genre
```sql
SELECT Genre, ROUND(AVG(Price), 2) AS Average_Price
FROM Books
GROUP BY Genre
ORDER BY Average_Price DESC;
```

### 17. Running total of revenue over time
```sql
-- Full solution using SUM() OVER (ORDER BY ...) is in the .sql file
```

### 18. Customer segmentation by spending (High, Medium, Low)
```sql
-- Full solution using NTILE() window function is in the .sql file
```

### 19. Average time between orders for repeat customers
```sql
-- Full solution using LAG() and date functions is in the .sql file
```

### 20. Books that have never been sold
```sql
SELECT B.Title
FROM Books B
LEFT JOIN Orders O ON B.Book_ID = O.Book_ID
WHERE O.Order_ID IS NULL;
```
---

## Installation & Setup

Follow these steps to set up the project locally.

### Prerequisites
-   PostgreSQL installed and running.
-   Python 3.8+ installed.

### Steps
1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/bookstore-sql-analytics.git](https://github.com/your-username/bookstore-sql-analytics.git)
    cd bookstore-sql-analytics
    ```

2.  **Install Python libraries:**
    ```sh
    pip install pandas sqlalchemy psycopg2-binary
    ```

3.  **Set up the database:**
    -   Create a new database in PostgreSQL (e.g., `bookstore_db`).
    -   Create a user and grant privileges to the database.

4.  **Load the data:**
    -   Place your CSV files (`Customers.csv`, `Books.csv`, `Orders.csv`) in a `data/` directory.
    -   Update the database connection string in the `load_data_pg_admin.py` script:
        ```python
        # Example connection string
        db_url = 'postgresql://user:password@localhost:5432/bookstore_db'
        ```
    -   Run the script to create tables and populate them with data:
        ```sh
        python load_data_pg_admin.py
        ```

---

## Technologies Used

| Technology | Description |
|---|---|
| **SQL** | Core language for database querying and complex analysis. |
| **PostgreSQL** | The relational database management system used to store and manage the data. |
| **Python** | Used for scripting the data loading process into the database. |
| **Pandas** | Python library used to read CSV files and handle data in dataframes. |
| **SQLAlchemy** | Python SQL toolkit and ORM used to connect to the database engine. |

---

## Key Insights

The analysis of the bookstore dataset yielded several valuable insights:
-   **Top Genres**: Fiction and Mystery are the most popular genres, driving the highest sales volume.
-   **Customer Loyalty**: A small group of loyal customers contributes a significant portion of the total revenue, highlighting the importance of retention strategies.
-   **Revenue Trends**: Sales peak during certain months, indicating seasonal purchasing patterns that could be leveraged for marketing campaigns.
-   **Pricing Strategy**: The average price of books varies significantly by genre, providing an opportunity to optimize pricing models.

---

## File Structure

```
bookstore-sql-analytics/
├── data/
│   ├── Books.csv
│   ├── Customers.csv
│   └── Orders.csv
├── Bookstore analysis.sql      # Contains all 20 analytical SQL queries
├── load_data_pg_admin.py       # Python script to load CSV data into PostgreSQL
└── README.md                   # This file
```

---

## Usage

To reproduce the analysis:

1.  Complete the **Installation & Setup** steps to load the data into your PostgreSQL database.
2.  Connect to your database using a SQL client (e.g., pgAdmin, DBeaver, DataGrip).
3.  Open the `Bookstore analysis.sql` file.
4.  Run the queries individually to see the results of each analytical question.

---

## License

This project is distributed under the MIT License.
