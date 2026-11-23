create table retail_sales(
transactions_id int primary key,
sale_date  date,
sale_time  time,
customer_id int,
gender varchar(10),
age int,
category varchar(20),
quantiy int,
price_per_unit float,
cogs float,
total_sale float

)

select *
from retail_sales


select * 
from retail_sales
where transactions_id is null 
   or sale_date is null
   or sale_time is null 
   or customer_id is null
   or age is null
   or category is null
   or quantity is null
   or price_per_unit is null
   or cogs is null
   or total_sale is null


update retail_sales
set age = (
             select 
             round(avg(age)) 
             from retail_sales
)
where age is null


 
delete from retail_sales
where 
      transactions_id is null 
   or sale_date is null
   or sale_time is null 
   or customer_id is null
   or category is null
   or quantity is null
   or price_per_unit is null
   or cogs is null
   or total_sale is null

--Data Exploration----

select * from retail_sales
--How many sales we have
select count(*) from retail_sales
--How many customers we have
select count(distinct customer_id) from retail_sales
--Which categories we have
select distinct category
from retail_sales

---------------------Data Analysis & Finding------------------------
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select *
from retail_sales
where sale_date = '2022-11-05'
--2.Write a SQL query to retrieve all transactions where the category
    --is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select *
from retail_sales
where category ='Clothing' 
  and quantity >= 4 
  and sale_date between '2022-11-01' and '2022-11-30'
	
--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select 
category,
sum(total_sale) as "Category_Wise_Total_Sales"
from retail_sales
group by 1
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age)) as "Average Age"
from retail_sales
where category = 'Beauty'
--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select *
from retail_sales
where total_sale >=1000
--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select 
gender,
category,
count(transactions_id) as "Total Transactions"
from retail_sales
group by 1,2

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
with cte1 as(
SELECT
extract (year from sale_date) as "Year",
extract (month from sale_date) as "Month",
round(avg(total_sale)::numeric,2) as "AVG Sales",
dense_rank() over(partition by extract(year from sale_date) order by round(avg(total_sale)::numeric,2) desc) as rank
from retail_sales
group by 1,2
order by 1,2 asc
)
select 
"Year",
"Month",
"AVG Sales"
from cte1
where rank = 1

--8.Write a SQL query to find the top 5 customers based on the highest total sales

select 
"customer_id",
"Total_Sales"
from (
select 
customer_id,
sum(total_sale) as "Total_Sales",
dense_rank() over(order by sum(total_sale) desc) as "Rank"
from retail_sales
group by 1
)
where "Rank" <= 5

--9.Write a SQL query to find the number of unique customers who purchased items from each category.:
select
category,
count(distinct customer_id) as "Total_Customers"
from retail_sales
group by 1

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sale as (
select *,
case 
    when  sale_time < '12:00:00' then 'Morning'
	when  sale_time between '12:00:00' and '17:00:00' then 'Afternoon'
	else 'Evening' 
	end as "Shift"
from retail_sales
)
select
"Shift",
count(*) as "Total_Orders"
from hourly_sale
group by 1

--11.Write a SQL query to calculate the total sales by gender.
select 
gender,
sum(total_sale) as "Total_Sales"
from retail_sales
group by 1 
--12. Weekend vs Weekday Sales Analysis
select 
case 
    when extract (isodow from sale_date) in (6,7) then 'Weekend'
	else 'Weekdays'
	end as "weektype",
sum(total_sale) as "Total_Sales",
count(transactions_id) as "Total_Transactions",
round(avg(total_sale)) as "AVG_Sales"
from retail_sales
group by 1

--13.Write a SQL query to calculate total sales by age group.
    --(Under 18-> Teen Segment,18–25-> Youth Segment,26–35-> Young Adult Segment, 36–50->	Adult Segment,51+ ->Senior Segment)
select 
case 
    when age < 18 then 'Teen Segment'
	when age between 18 and 25 then 'Youth Segment'
	when age between 26 and 35 then 'Young Adult Segment'
	when age  between 36 and 50 then 'Adult Segment'
	else 'Senior Segment'
	end as "Age Group",
sum(total_sale) as "Total Sales"	
from retail_sales
group by 1


--14.Write a SQL query to analyze customer purchase frequency.(One-time Customer,
   --Occasional Customer (2–3 transactions),Regular Customer (4–6 transactions),Frequent Customer (7+ transactions))

select 
customer_id,
count(customer_id) as "Purchase Frequency",
case 
    when count(customer_id) = 1 then 'One Time Customer'
	when count(customer_id) <= 3 then 'Occasional Customer'
	when count(customer_id) between 4 and 6 then 'Regular Customer'
	else 'Frequent customer'
	end as "Customer Type"
from retail_sales
group by 1
order by 1

--15.Customer Spending Category Analysis
with cus_seg as (
select 
customer_id,
sum(total_sale) as "Total Sales",
ntile(3) over(order by sum(total_sale)) as "Spending Rank"
from retail_sales
group by 1
)
select *,
case 
    when "Spending Rank" = 1 then 'Low Spenders'
	when "Spending Rank" = 2 then 'Medium Spenders'
	else 'High Spenders'
	end as "Customer Spending Category" 
from cus_seg
order by 1





