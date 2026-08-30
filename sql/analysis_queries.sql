CREATE TABLE "Superstore" ( "Row ID" integer, "Order ID" text, "Order Date" text, "Ship Date" text, "Ship Mode" text, "Customer ID" text, "Customer Name" text, "Segment" text, "Country/Region" text, "City" text, "State/Province" text, "Postal Code" text, "Region" text, "Product ID" text, "Category" text, "Sub-Category" text, "Product Name" text, "Sales" numeric, "Quantity" integer, "Discount" numeric, "Profit" numeric );

COPY "Superstore" ("Row ID", "Order ID", "Order Date", "Ship Date", "Ship Mode", "Customer ID", "Customer Name", "Segment", "Country/Region", "City", "State/Province", "Postal Code", "Region", "Product ID", "Category", "Sub-Category", "Product Name", "Sales", "Quantity", "Discount", "Profit") FROM 'D:/SQL/Project Simulation/samplesuperstore.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', QUOTE '"', ESCAPE '"');

ALTER TABLE "Superstore" RENAME TO superstore;

SELECT *
FROM superstore; 

----- Q 1 --------

SELECT SUM(Sales) AS total_sales, SUM(Profit) AS total_profit
FROM superstore;

------ Q 2 --------

SELECT 
   TO_CHAR(order_date::date, 'Month') AS month,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY month
order by month; 



------ Q 3 -------

SELECT Region, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_profit DESC;

-- Q 4 --
SELECT Product_name, Product_ID, SUM(Sales) as total_sales
FROM superstore
GROUP BY Product_name, Product_ID
Order BY total_sales DESC
LIMIT 10;

-- Q 5 --
SELECT Customer_name, Customer_ID, SUM(Profit) as total_profit
FROM superstore
GROUP BY Customer_name, Customer_ID
Order BY total_profit DESC
LIMIT 10;

---- Q 6 -----

SELECT Product_name, Product_ID, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Product_name, Product_ID
HAVING  SUM(Profit) < 0
ORDER BY total_profit ASC;

---- Q 7 -----

SELECT Order_ID, AVG(Quantity) AS average_order_value
FROM superstore
GROUP BY Order_ID
ORDER BY average_order_value;

------ Q 8 ---------

SELECT 
    region,
    SUM(sales) AS region_sales,
    ROUND(
        SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 
        2
    ) AS "percent_of_total (%)"
FROM superstore
GROUP BY region
ORDER BY "percent_of_total (%)" DESC;


----- Q 9 -----

WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date::date) AS sales_year,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY EXTRACT(YEAR FROM order_date::date)
)
SELECT 
    sales_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_year) AS prev_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY sales_year)) 
        * 100.0 / LAG(total_sales) OVER (ORDER BY sales_year), 
        2
    ) AS pct_growth
FROM yearly_sales
ORDER BY sales_year;

------- Q 10 --------

SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category
Order BY total_sales ASC;


SELECT COUNT(DISTINCT sub_category) 
FROM superstore;