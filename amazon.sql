SELECT * FROM ORDERS;


-- What is the total revenue generated?
SELECT ROUND(SUM(TOTALAMOUNT),2) AS TOTAL_REVENUE
FROM ORDERS;

-- How many total orders were placed?
SELECT COUNT(ORDERID)
FROM ORDERS;

-- What is the average order value?
SELECT ROUND(AVG(TOTALAMOUNT),2)
FROM ORDERS;

-- Which payment method is used most frequently? 
SELECT DISTINCT PAYMENTMETHOD, COUNT(PAYMENTMETHOD) AS PAYMENT
FROM ORDERS
GROUP BY PAYMENTMETHOD
ORDER BY COUNT(PAYMENTMETHOD) DESC LIMIT 1 ;

-- What is the total quantity sold?
SELECT SUM(QUANTITY) 
FROM ORDERS;

-- Which order status appears most?
SELECT DISTINCT ORDERSTATUS, COUNT(ORDERSTATUS)
FROM ORDERS
GROUP BY ORDERSTATUS 
ORDER BY COUNT(ORDERSTATUS) DESC ;


-- Which product generated the highest revenue?
SELECT DISTINCT PRODUCTNAME , COUNT(PRODUCTNAME) 
FROM ORDERS
GROUP BY PRODUCTNAME 
ORDER BY COUNT(PRODUCTNAME) DESC ;

SELECT ProductName, SUM(TotalAmount) AS Total_Revenue
FROM ORDERS
GROUP BY ProductName
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Which category has the highest sales?
SELECT  DISTINCT CATEGORY , SUM(TOTALAMOUNT) AS TOTAL_REVENUE
FROM ORDERS 
GROUP BY CATEGORY
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;


-- Which brand sells the most units?
SELECT  DISTINCT BRAND , SUM(TOTALAMOUNT) AS TOTAL_REVENUE
FROM ORDERS 
GROUP BY BRAND
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;

-- Which city generates the highest revenue?
SELECT  CITY ,COUNTRY, SUM(TOTALAMOUNT) AS TOTAL_REVENUE 
FROM ORDERS 
GROUP BY CITY,  COUNTRY 
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;

-- Which state has the most orders? 
SELECT STATE ,COUNT(ORDERID) AS TOTAL_ORDERS
FROM ORDERS 
GROUP BY STATE 
ORDER BY TOTAL_ORDERS DESC 
LIMIT 1;

-- What is the monthly revenue trend? 
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS Year__Month,
    SUM(TotalAmount) AS Monthly_Revenue
FROM Orders
GROUP BY Year__Month
ORDER BY Year__Month;

-- What is the average discount per order?
SELECT AVG(DISCOUNT) 
FROM ORDERS ; 

-- Which seller generated the highest sales?
SELECT   SELLERID ,SUM(TOTALAMOUNT) AS TOTAL_REVENUE 
FROM ORDERS 
GROUP BY SELLERID
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;

-- Which product has the highest average discount?
SELECT   PRODUCTNAME ,ROUND(AVG(TOTALAMOUNT),2) AS TOTAL_REVENUE 
FROM ORDERS 
GROUP BY PRODUCTNAME
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;

-- What is revenue after discount? 
SELECT 
    SUM((Quantity * UnitPrice) - Discount) AS Revenue_After_Discount
FROM Orders;

-- What is average tax per order?
SELECT   TAX ,ROUND(AVG(TAX),2) AS AVG_TAX
FROM ORDERS 
GROUP BY TAX 
ORDER BY DESC;

SELECT ROUND(AVG(Order_Tax), 2) AS AVG_TAX_PER_ORDER
FROM (
    SELECT OrderID, SUM(Tax) AS Order_Tax
    FROM ORDERS
    GROUP BY OrderID
) AS OrderLevel;


-- What is total shipping cost by state?
SELECT STATE ,COUNTRY, SUM(SHIPPINGCOST) AS TOTAL_SHIPPINGCOST 
FROM ORDERS 
GROUP BY STATE , COUNTRY
ORDER BY TOTAL_SHIPPINGCOST;


-- Which category gives highest average order value? 
SELECT CATEGORY, ROUND(AVG(TOTALAMOUNT),2) AS AVG_ORDER_VALUE 
FROM ORDERS 
GROUP BY CATEGORY
ORDER BY AVG_ORDER_VALUE DESC
LIMIT 1;

-- What percentage of orders are delivered?
SELECT 
    ROUND(
        (COUNT(CASE WHEN OrderStatus = 'Delivered' THEN 1 END) 
        * 100.0) / COUNT(*), 
    2) AS Delivered_Percentage
FROM ORDERS;

-- Who are the top 10 customers by revenue?
SELECT CUSTOMERNAME , SUM(TOTALAMOUNT) AS TOTAL_SPENDING 
FROM ORDERS 
GROUP BY CUSTOMERNAME 
ORDER BY TOTAL_SPENDING DESC 
LIMIT 10;

-- Which customer ordered the most quantity? 
SELECT CUSTOMERNAME , COUNT(TOTALAMOUNT) AS TOTAL_ORDERS
FROM ORDERS 
GROUP BY CUSTOMERNAME 
ORDER BY TOTAL_ORDERS DESC 
LIMIT 10;

-- What is the repeat purchase rate?
SELECT 
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT CustomerID) FROM ORDERS),
    2) AS Repeat_Purchase_Rate
FROM (
    SELECT CustomerID
    FROM ORDERS
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 1
) AS RepeatCustomers;


-- What is average spending per customer?
SELECT ORDERID ,  AVG(TOTALAMOUNT) 
FROM ORDERS 
GROUP BY ORDERID 
ORDER BY TOTALAMOUNT
DESC LIMIT 1;

SELECT 
    ROUND(SUM(TotalAmount) / COUNT(DISTINCT CustomerID), 2) 
    AS Avg_Spending_Per_Customer
FROM ORDERS;

-- Which city has highest unique customers?
SELECT 
    City,
    COUNT(DISTINCT CustomerID) AS Unique_Customers
FROM ORDERS
GROUP BY City
ORDER BY Unique_Customers DESC
LIMIT 1;

-- Rank products by revenue (use RANK). 
SELECT PRODUCTNAME, PRODUCTID , SUM(TOTALAMOUNT) AS TOTAL_REVENUE_BY_PRODUCT,
RANK() OVER( ORDER BY SUM(TOTALAMOUNT) DESC ) AS REVENUE_RANK 
FROM ORDERS 
GROUP BY PRODUCTID, PRODUCTNAME ;

SELECT 
    ProductID,
    ProductName,
    SUM(TotalAmount) AS Total_Revenue_By_Product,
    RANK() OVER (ORDER BY SUM(TotalAmount) DESC) AS Revenue_Rank
FROM ORDERS
GROUP BY ProductID, ProductName;


-- Find top 3 products in each category. 
SELECT *
FROM (
    SELECT 
        Category,
        ProductID,
        ProductName,
        SUM(TotalAmount) AS Total_Revenue,
        RANK() OVER (
            PARTITION BY Category 
            ORDER BY SUM(TotalAmount) DESC
        ) AS Product_Rank
    FROM ORDERS
    GROUP BY Category, ProductID, ProductName
) AS RankedProducts
WHERE Product_Rank <= 3;


-- Calculate month-over-month revenue growth.
SELECT 
    OrderDate,
    Monthly_Revenue,
    ROUND(
        (Monthly_Revenue - LAG(Monthly_Revenue) OVER (ORDER BY OrderDate)) 
        * 100.0 /
        LAG(Monthly_Revenue) OVER (ORDER BY OrderDate),
    2) AS MoM_Growth_Percentage
FROM (
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS OrderDate,
        SUM(TotalAmount) AS Monthly_Revenue
    FROM ORDERS
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
) AS MonthlyData;


-- Identify high discount but low revenue products.
SELECT 
    ProductID,
    ProductName,
    ROUND(AVG(Discount), 2) AS Avg_Discount,
    SUM(TotalAmount) AS Total_Revenue
FROM ORDERS
GROUP BY ProductID, ProductName
HAVING 
    AVG(Discount) > 0.30      -- High Discount (Above 30%)
    AND
    SUM(TotalAmount) < 5000   -- Low Revenue (Adjust as per dataset)
ORDER BY Avg_Discount DESC;

-- Detect potential fraud (high discount + high quantity). 
SELECT 
    OrderID,
    CustomerID,
    ProductID,
    Quantity,
    Discount,
    TotalAmount
FROM ORDERS
WHERE 
    Discount > 0.40      
    AND 
    Quantity > 10       
ORDER BY Discount DESC, Quantity DESC;



-- Which seller generated the highest overall sales?
SELECT 
    SellerID,
    SUM(TotalAmount) AS Total_Sales
FROM ORDERS
GROUP BY SellerID
ORDER BY Total_Sales DESC
LIMIT 1;

-- What is the total revenue generated from all orders?
SELECT 
    COUNT(DISTINCT ORDERID) AS TOTAL_ORDERS
FROM
    ORDERS;










