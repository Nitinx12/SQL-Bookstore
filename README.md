# Bookstore Data Analysis

![License](https://img.shields.io/badge/license-MIT-blue) ![Version](https://img.shields.io/badge/version-1.0.0-green)

A comprehensive analysis of bookstore sales data to uncover trends, patterns, and actionable insights.

## 📖 About The Project

This project provides a deep dive into a bookstore's sales and customer data. The primary goal is to analyze transactional data to understand customer behavior, identify popular book genres, and discover sales patterns over time. By leveraging SQL for data querying and Python for in-depth analysis and visualization, this project transforms raw data into a clear narrative that can help a bookstore optimize its operations, marketing efforts, and inventory management.

### ✨ Built With
* Python
* SQL (PostgreSQL)
* Pandas
* Jupyter Notebook
* Matplotlib & Seaborn

## 🚀 Features

- **Data Loading:** Includes a Python script to efficiently load CSV data into a PostgreSQL database.
- **In-depth SQL Analysis:** Features a collection of complex SQL queries to explore customer demographics, order history, and genre performance.
- **Visual Analytics:** Utilizes a Jupyter Notebook for data cleaning, exploration, and creating insightful visualizations to identify key business metrics and trends.
- **Actionable Insights:** Provides clear, data-driven recommendations to improve sales and customer engagement.

## 💻 Getting Started

This section will guide you through setting up the project locally.

### Prerequisites
* Python 3.8+
* PostgreSQL installed and running.
* An IDE or text editor (e.g., VS Code).

### Installation
1.  **Clone the repo**
    ```bash
    git clone [https://github.com/Nitinx12/Bookstore-Data-Analysis.git](https://github.com/Nitinx12/Bookstore-Data-Analysis.git)
    ```
2.  **Navigate to the project directory**
    ```bash
    cd Bookstore-Data-Analysis
    ```
3.  **Install dependencies**
    Create a `requirements.txt` file with the following content:
    ```
    pandas
    sqlalchemy
    psycopg2-binary
    matplotlib
    seaborn
    jupyter
    ```
    Then, run the installation command:
    ```bash
    pip install -r requirements.txt
    ```
4. **Database Setup**
    - Create a new database in PostgreSQL (e.g., `bookstore`).
    - Update the connection string in `load_data_pg_admin.py` with your database credentials.
    - Run the script to load the data:
      ```bash
      python load_data_pg_admin.py
      ```

## 📚 Usage

The primary analysis is conducted within the Jupyter Notebook.

1.  **Start Jupyter Notebook:**
    ```bash
    jupyter notebook
    ```
2.  Open the `Bookstore_Notebook_Growth.ipynb` file to view the step-by-step data analysis, visualizations, and insights.

You can also run the queries found in `Bookstore analysis.sql` directly against your PostgreSQL database using a SQL client of your choice.

## ⚙️ Configuration

Before running the data loader script (`load_data_pg_admin.py`), you must update the database connection string with your local PostgreSQL credentials:

-   `conn_string = 'postgresql://YOUR_USERNAME:YOUR_PASSWORD@localhost/YOUR_DATABASE_NAME'`

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

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

-   Fork the repo
-   Create your feature branch (`git checkout -b feature/AmazingFeature`)
-   Commit your changes (`git commit -m 'Add some AmazingFeature'`)
-   Push to the branch (`git push origin feature/AmazingFeature`)
-   Open a Pull Request

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Contact

Nitin K - Nitin321x@gmail.com

Project Link: [https://github.com/Nitinx12/Bookstore-Data-Analysis](https://github.com/Nitinx12/Bookstore-Data-Analysis)

LinkedIn: [https://www.linkedin.com/in/nitin-k-220651351/](https://www.linkedin.com/in/nitin-k-220651351/)
