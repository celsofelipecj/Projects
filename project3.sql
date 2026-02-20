-- Product table
CREATE TABLE Dim_Products (
    ProductKey INT PRIMARY KEY,
    ProductSubcategoryKey INT,
    ProductSKU VARCHAR(50),
    ProductName VARCHAR(100),
    ModelName VARCHAR(100),
    ProductDescription TEXT,
    ProductColor VARCHAR(20),
    ProductSize VARCHAR(20),
    ProductStyle VARCHAR(5),
    ProductCost DECIMAL(10, 4),
    ProductPrice DECIMAL(10, 4)
);

-- territory table

CREATE TABLE Dim_territory (
SalesTerritoryKey INT PRIMARY KEY,
Region VARCHAR(50),
Country VARCHAR(50),
Continent VARCHAR(15)
);

-- Customers Table
CREATE TABLE Dim_customers(
Customer_Key INT PRIMARY KEY,
Prefix VARCHAR(50),
First_name VARCHAR (50),
Last_name VARCHAR(50),
Birth_date DATE,
Marital_status VARCHAR(50),
Gender VARCHAR(50),
Email_address VARCHAR(50),
Annual_income DECIMAL(15,2),
Total_children INT,
Education_level VARCHAR(100),
Occupation VARCHAR(100)
);

-- Sales table
CREATE TABLE Fact_sales (
    Order_date DATE,
    Stock_date DATE,
    Order_number VARCHAR(20),
    Product_key INT,
    Customer_key INT,
    Territory_key INT,
    Order_line_item INT,
    Order_quantity INT,
    PRIMARY KEY (Order_number, Order_line_item)
);

-- Subcategories
CREATE TABLE Dim_subcategories(
ProductSubcategoryKey INT,
Subcategory_name CHAR(20),
ProductCategoryKey int
);

-- Categories
CREATE TABLE Dim_Categories(
ProductCategoryKey INT,
Category_name CHAR(20)
);


-- Sales
CREATE VIEW actual_sales AS
SELECT
sales.Order_number, customers.First_name, products.ProductName
FROM Fact_sales AS sales
INNER JOIN dim_customers AS customers ON sales.Customer_key = customers.Customer_key
INNER JOIN dim_products AS products ON sales.Product_key = products.Productkey;

-- Sales per territory
CREATE VIEW territory_sales AS
SELECT sales.Order_date, sales.Order_quantity, territory.Country
FROM fact_sales AS sales
INNER JOIN dim_territory AS territory ON sales.Territory_key = territory.SalesTerritoryKey;

-- Sales_master

CREATE VIEW Master_sales AS
SELECT sales.Order_date, sales.Order_number, customer.First_name, products.ProductName, country.country, sales.Order_quantity, products.ProductPrice, (sales.Order_quantity * products.ProductPrice) AS total_sales
FROM fact_sales AS sales
INNER JOIN dim_customers AS customer ON sales.Customer_key = customer.Customer_key
INNER JOIN dim_products AS products ON sales.Product_key = products.Productkey
INNER JOIN dim_territory AS country ON sales.Territory_key = country.SalesTerritoryKey;

SELECT ProductName, country, SUM(order_quantity) AS total_sales FROM Sales_master
WHERE country = 'Australia'
GROUP BY ProductName, country
ORDER BY total_sales DESC
LIMIT 5;

SELECT country, ROUND(SUM(total_sales) / COUNT(DISTINCT order_number),2) AS ticket FROM master_sales
GROUP BY country
ORDER BY ticket DESC
;

-- Revenue per country

SELECT country, SUM(total_sales) AS revenue FROM master_sales
GROUP BY country
ORDER BY revenue DESC
Limit 5
;

-- Revenue per product 

SELECT ProductName, SUM(total_sales) AS revenue FROM master_sales
GROUP BY ProductName
ORDER BY revenue DESC
LIMIT 5
;

