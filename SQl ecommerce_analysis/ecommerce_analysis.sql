CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE IF NOT EXISTS ecom (
    `Transaction ID` INT PRIMARY KEY,
    `Date` DATETIME,
    `Product Category` VARCHAR(100),
    `Product Name` VARCHAR(150),
    `Unit Sold` INT,
    `Unit Price` DECIMAL(10,2),
    `Total Revenue` DECIMAL(10,3),
    `Region` VARCHAR(100),
    `Payment Method` VARCHAR(100)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online Sales Data.csv"
INTO TABLE ecom
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

-- Fetching all records from ecom table
select * from ecom;

-- Calculating the total revenue
select sum(Total_Revenue) as Total_Revnue from ecom;

-- Number of Transaction per payment method
select Payment_Method, count(Transaction_ID) as Payment_Method_count from ecom group by Payment_Method;

-- Most sold Product Category
select Product_Category, sum(Unit_Sold) as unit_sold from ecom group by Product_Category order by unit_sold DESC limit 1;

-- Best Selling Product by revenue
select Product_Name, sum(Unit_Sold * Unit_Price) as Total_revenue from ecom group by Product_Name order by Total_revenue DESC LIMIT 1;

-- Monthly Sales Trends
Select extract(Year from `Date`) as Year,extract(Month from `Date`) AS Month, sum(`Total_Revenue`) AS Total_Revenue from ecom Group By Year,Month Order By Year DESC, Month DESC;

-- Most Popular Payment Method By Region
Select count(Payment_Method) as Payment_Method_Count, Payment_Method, Region from ecom group by Region,Payment_Method order by `Payment_Method_Count` DESC;

-- Calculate the average revenue per trascation
Select Avg(Total_Revenue) as Average_Revenue from ecom;

-- Customer purchase behaviour - Identify which reigon spends the most on average per order.
select Region, avg(Total_Revenue) Average from ecom group by Region order by Average DESC LIMIT 1;

-- Find the best selling product categories in each region.
select P.Product_Category, P.Region, P.Total_Sales from (Select `Region`, `Product_Category`,sum(Total_Revenue) as Total_Sales, rank() over (partition by `Region` order by sum(`Total_Revenue`) DESC) AS rnk
from ecom group by Region, Product_Category)P where P.rnk=1;

-- Discount Effectiveness Analsis - Find out if discounted products higher sales volume than non-discounted products.

-- Identify the date with the highest total revenue 
select d.date, d.sum_Total_revenue from (select date, sum(Total_Revenue) as sum_Total_revenue from ecom Group by Date order by sum_total_revenue DESC LIMIT 5) as d;

-- Find the which region has the most transactions.
select region, count(Transaction_ID) as Count_Transaction_ID from ecom Group by region order by Count_Transaction_ID DESC limit 1;

-- Identify products that has the most variations in unit price.
select Product_Name, Max(`Unit_Price`) - Min(`Unit_Price`) as Price_Variation from ecom group by Product_name order by Price_Variation DESC LIMIT 5;

-- Calculate what percentage of total transactions comes from each payment method
select Payment_Method, (count(Payment_Method)/ (select count(*) from ecom)) * 100 as Count_Payment_Method from ecom Group by Payment_Method;

-- Printing the unique Payment Method
select distinct(Payment_Method) from ecom;

-- Determine what percenatge of total revenue each product category contributes.
select Product_Category, (sum(Total_Revenue)/(select sum(Total_Revenue) from ecom)) * 100 as sum_total_revenue from ecom group by Product_Category; 



-- Print Region only
select region from ecom group by region;

describe ecom;
