# 📊 SQL Project: Amazon E-Commerce Sales Analysis

<br>

## 📝 Objectives

* **Database Setup**: Create and manage an Amazon e-commerce sales database using MySQL.
* **Data Cleaning**: Validate records and ensure data consistency for accurate analysis.
* **Exploratory Data Analysis (EDA)**: Analyze sales, customers, products, and seller performance.
* **Business Analysis**: Use SQL queries to answer real-world business questions and generate actionable insights.

<br>
<br>

## 🗂️ Project Structure

### 1. 📦 Database Setup

#### -Database Creation

```sql
CREATE DATABASE amazon_sales;
```

#### -Table Creation

Single table: `orders`, structured as follows:

```sql
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(100),
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2),
    Tax DECIMAL(10,2),
    ShippingCost DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(50),
    SellerID INT,
    OrderDate DATE,
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50)
);
```

<br>

### 2. 🧹 Data Exploration & Cleaning

#### -Record Count

```sql
SELECT COUNT(*)
FROM Orders;
```

#### -Unique Customers

```sql
SELECT COUNT(DISTINCT CustomerID)
FROM Orders;
```

#### -Unique Categories

```sql
SELECT COUNT(DISTINCT Category)
FROM Orders;
```

#### -Null Value Check

```sql
SELECT *
FROM Orders
WHERE CustomerID IS NULL
   OR ProductID IS NULL
   OR ProductName IS NULL
   OR Category IS NULL
   OR TotalAmount IS NULL;
```

#### -Duplicate Order Check

```sql
SELECT OrderID, COUNT(*)
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;
```

<br>

### 3. 📊 Data Analysis & Insights

The following SQL queries address 30+ business-focused questions using Amazon sales data.

<br>

#### 📌 Sample Questions:

**- What is the total revenue generated?**

```sql
SELECT ROUND(SUM(TotalAmount),2) AS Total_Revenue
FROM Orders;
```

<br>

**- What is the average order value?**

```sql
SELECT ROUND(AVG(TotalAmount),2)
FROM Orders;
```

<br>

**- Which payment method is used most frequently?**

```sql
SELECT PaymentMethod,
       COUNT(*) AS Total_Orders
FROM Orders
GROUP BY PaymentMethod
ORDER BY Total_Orders DESC
LIMIT 1;
```

<br>

**- Which product generated the highest revenue?**

```sql
SELECT ProductName,
       SUM(TotalAmount) AS Total_Revenue
FROM Orders
GROUP BY ProductName
ORDER BY Total_Revenue DESC
LIMIT 1;
```

<br>

**- Top 10 customers by revenue**

```sql
SELECT CustomerName,
       SUM(TotalAmount) AS Total_Spending
FROM Orders
GROUP BY CustomerName
ORDER BY Total_Spending DESC
LIMIT 10;
```

<br>

**- Rank products by revenue**

```sql
SELECT ProductID,
       ProductName,
       SUM(TotalAmount) AS Total_Revenue,
       RANK() OVER(
           ORDER BY SUM(TotalAmount) DESC
       ) AS Revenue_Rank
FROM Orders
GROUP BY ProductID, ProductName;
```

<br>

#### Customer, Product, Revenue, and Seller Analysis Includes:

<br>

* Total revenue and order analysis

* Monthly revenue trends
* Month-over-month revenue growth
* Product and category performance
* Brand-wise sales analysis
* Top 10 customers by spending
* Repeat purchase rate
* City and state performance
* Seller performance analysis
* Delivered order percentage
* High discount and low revenue product detection
* Fraud detection using discount and quantity patterns

#### ✔️ All queries are well-structured and use core SQL concepts such as GROUP BY, HAVING, WINDOW FUNCTIONS, RANK(), LAG(), SUBQUERIES, AGGREGATE FUNCTIONS, and DATE FUNCTIONS.

<br>

## 📈 Conclusion

**This project provides a practical understanding of SQL in an e-commerce business environment. It covers:**

<br>

* Database design and management
* Data validation and cleaning
* Exploratory data analysis
* Customer behavior analysis
* Revenue and profitability analysis
* Advanced SQL querying techniques

**The insights generated help businesses understand:**

<br>

* Customer purchasing patterns
* Product and category performance
* Revenue growth trends
* Seller effectiveness
* Regional sales performance
* Opportunities for business optimization


## 💻 Tools & Technologies

* SQL (MySQL)

* MySQL Workbench

* Power BI


## 👨‍💻 Author

**Mauzzam**

* **GitHub:**[ Github Profile](https://github.com/MAUZZAM123)
* **LinkedIn:[**inkedIn Profile](https://www.linkedin.com/in/mauzzamshaikh1104/)

## 🌟 Feedback & Support

Feel free to share suggestions or improvements.

If you found this project useful, please consider giving it a ⭐️ on GitHub.
