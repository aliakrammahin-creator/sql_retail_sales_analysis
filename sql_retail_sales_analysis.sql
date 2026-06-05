use retail_sales;
select * from sales_analysis;

-- Data Cleaning
SELECT * FROM sales_analysis
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
  
set sql_safe_updates = 0;
DELETE FROM sales_analysis
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- Data Exploration
select count(*) from sales_analysis;
SELECT COUNT(DISTINCT customer_id) FROM sales_analysis;
SELECT DISTINCT category FROM sales_analysis;
    
-- Data analysis and Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) and total_orders for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from sales_analysis
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
select * 
from sales_analysis
where 
     category = 'Clothing'
     and 
     quantity >= 4
     and 
     year(sale_date) = 2022
     AND month(sale_date) = 11;
     
-- Q.3 Write a SQL query to calculate the total sales (total_sale) and total_orders for each category.
select
      category,
      sum(total_sale) as Total,
      count(*) as total_orders
from sales_analysis
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
      round(avg(age),2) as avg_age
from sales_analysis
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from sales_analysis
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
      gender,
      category,
      count(`ï»¿transactions_id`) as total_transaction
from sales_analysis
group by 1, 2
order by gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
with monthly_sales as
(
    select
        year(sale_date) as sales_year,
        month(sale_date) as sales_month,
        avg(total_sale) as avg_sale
    from sales_analysis
    group by 1,2
),
ranked_months as
(
    select *,
           row_number() over(
               partition by sales_year
               order by avg_sale desc
           ) as rn
    from monthly_sales
)
select *
from ranked_months
where rn = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
      customer_id,
      sum(total_sale) as Total_sales
from sales_analysis
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
      category,
      count(distinct customer_id) as unique_cust
from sales_analysis
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
select *,
    case
        when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
    end as shift
from sales_analysis
)
select 
      shift,
      count(*) as total_orders
from hourly_sale
group by shift;