# 📖 The Bookworm's Compass: A Deep Dive into Bookstore Analytics

Welcome to **The Bookworm's Compass**, a comprehensive data analytics project that explores a bookstore's sales, customer behavior, and inventory data. This project leverages SQL for powerful database querying and Python for in-depth analysis and visualization to uncover actionable insights that can help drive business growth.

---

## 🚀 Project Overview

This project simulates a real-world scenario where a bookstore wants to understand its performance better. By analyzing three core datasets—**Books**, **Customers**, and **Orders**—we answer critical business questions related to sales trends, customer segmentation, genre popularity, and revenue metrics. The goal is to transform raw data into a clear narrative that can inform strategic decisions.

### Key Objectives:
* **Analyze Sales Performance:** Investigate revenue by genre, track sales over time, and identify top-selling books.
* **Understand Customer Behavior:** Segment customers based on spending habits, identify loyal customers, and analyze purchasing patterns.
* **Optimize Inventory:** Determine which book genres are most popular and contribute the most to revenue.
* **Enhance Marketing Strategies:** Identify the most common email providers for targeted campaigns.

---

## 🛠️ Technologies Used

This project utilizes a combination of database and data analysis technologies:

* **Database:** PostgreSQL
* **Data Loading:** Python (with `pandas` and `SQLAlchemy`)
* **Data Querying:** SQL
* **Data Analysis & Visualization:** Python (with `pandas`, `matplotlib`, `seaborn` in a Jupyter Notebook)



---

## 📁 Project Structure

Here's a breakdown of the key files in this repository:

* `Bookstore Project Questions.pdf`: A PDF document outlining the 20 business questions that this analysis answers.
* `Bookstore analysis.sql`: Contains all the SQL queries used to extract and manipulate data to answer the project questions.
* `Bookstore growth.ipynb`: A Jupyter Notebook that performs further data analysis and visualization in Python, focusing on customer email providers.
* `load_data_pg_admin.py`: A Python script to automate the process of loading the CSV data into a PostgreSQL database.
* `/data/` (folder): Contains the raw datasets used for this project (`Books.csv`, `Customers.csv`, `Orders.csv`).

---

## ⚙️ Setup and Installation

To get this project up and running on your local machine, follow these steps:

**1. Clone the Repository:**
```bash
git clone [https://github.com/Nitinx12/Bookstore-Analytics.git](https://github.com/Nitinx12/Bookstore-Analytics.git)
cd Bookstore-Analytics
```

**2. Set up the PostgreSQL Database:**
* Make sure you have **PostgreSQL** installed and running.
* Create a new database. You can name it `bookstore`.
* Update the connection string in the `load_data_pg_admin.py` file with your PostgreSQL credentials (username, password, host, and database name).

**3. Install Python Dependencies:**
* It's recommended to use a virtual environment.
```bash
pip install pandas sqlalchemy psycopg2-binary matplotlib seaborn jupyter
```

**4. Load the Data:**
* Place the CSV files (`Books.csv`, `Customers.csv`, `Orders.csv`) in a directory.
* Update the `base_path` variable in `load_data_pg_admin.py` to point to the directory where your CSV files are located.
* Run the script to load the data into your PostgreSQL database:
```bash
python load_data_pg_admin.py
```
This will create and populate the `books`, `customers`, and `orders` tables.

---

## 📊 How to Use

Once the setup is complete, you can explore the analysis:

* **SQL Analysis:** Open the `Bookstore analysis.sql` file in your favorite SQL client (like DBeaver, pgAdmin, or VS Code with a SQL extension) connected to your `bookstore` database. Run the queries to see the results directly.

* **Python Analysis:** Launch Jupyter Notebook and open the `Bookstore growth.ipynb` file to see the visual analysis of customer email providers.
```bash
jupyter notebook
```

---

## ✨ Key Insights & Queries

This project answers 20 specific questions. Here are a few highlights:

### ❓ What percentage of total revenue does each genre contribute?
This query calculates the total revenue for each book genre and expresses it as a percentage of the overall total revenue, helping to identify the most financially significant genres.

**SQL Query:**
```sql
WITH T1 AS (
    SELECT 
        B.genre,
        SUM(O.total_amount) AS genre_revenue
    FROM books AS B
    INNER JOIN orders AS O ON B.book_id = O.book_id
    GROUP BY 1
)
SELECT 
    genre, 
    genre_revenue,
    ROUND(genre_revenue * 100 / SUM(genre_revenue) OVER(), 2) AS percentage_total
FROM T1
ORDER BY 3 DESC;
```

### ❓ Who are the loyal customers and how often do they purchase?
This query first identifies "loyal customers" (defined as those who made purchases in at least 3 different months) and then calculates their average number of days between consecutive orders. This is crucial for understanding the purchasing frequency of the most engaged customers.

**SQL Query:**
```sql
WITH LoyalCustomers AS (
    SELECT Customer_ID
    FROM Orders
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT DATE_TRUNC('month', Order_Date)) >= 3
),
CustomerOrderGaps AS (
    SELECT
        Customer_ID,
        Order_Date - LAG(Order_Date, 1) OVER (
            PARTITION BY Customer_ID ORDER BY Order_Date
        ) AS Days_Between_Orders
    FROM Orders
    WHERE Customer_ID IN (SELECT Customer_ID FROM LoyalCustomers)
)
SELECT
    C.Name,
    AVG(COG.Days_Between_Orders) AS Avg_Days_Between_Orders
FROM CustomerOrderGaps COG
JOIN Customers C ON COG.Customer_ID = C.Customer_ID
WHERE COG.Days_Between_Orders IS NOT NULL
GROUP BY C.Name
ORDER BY Avg_Days_Between_Orders;
```

### 📊 Visualization: Top 5 Email Providers
The Jupyter Notebook analysis visualizes the most common email service providers among customers. This insight shows that **Microsoft Live (Hotmail) and Gmail dominate the customer base**, which is valuable information for tailoring email marketing campaigns.



---

## 👨‍💻 Author

* **Nitin Kumar**
* **GitHub:** [Nitinx12](https://github.com/Nitinx12)

Feel free to reach out with any questions or feedback!
