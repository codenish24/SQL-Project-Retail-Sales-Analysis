-- Create TABLE
create table retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);
-- Data Cleaning

select * from retail_sales
where transactions_id isnull;

select * from retail_sales
where sale_date isnull;

select * from retail_sales
where sale_time isnull;

select * from retail_sales
where customer_id isnull;

select * from retail_sales
where gender isnull;

select * from retail_sales
where 
age isnull
or
category isnull
or
quantiy isnull
or 
price_per_unit isnull
or
cogs isnull
or
total_sale isnull;

delete from retail_sales
where 
age isnull
or
category isnull
or
quantiy isnull
or 
price_per_unit isnull
or
cogs isnull
or
total_sale isnull;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sales from retail_sales

-- How many uniuque customers we have ?
select count(distinct customer_id) as customer 
from retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where category = 'Clothing'
and
quantiy >= 4 
and 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales, count(*) as total_order
from retail_sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age
from retail_sales
where category =  'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(transactions_id) as total_num_trasaction,
gender,category
from retail_sales
group by gender, category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
       year,
       month,
    avg_sale
from 
(    
select 
    extract(year from sale_date) as year,
    extract(month from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
count(distinct customer_id) as unique_cutomer
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(select *,
 case
 when extract(hour from sale_time) < 12 then 'Morning'
 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
 else 'Evening'
 end AS shift
 from retail_sales
)
select shift,
count(*) as total_orders
from hourly_sale
group by shift