# 🛒 Retail Sales Analysis Using SQL (PostgreSQL)

## 📌 Project Overview

This project focuses on analyzing retail sales data using PostgreSQL to identify sales trends, understand customer purchasing behavior, evaluate product category performance, and uncover valuable business insights.

The project involves data cleaning, exploratory data analysis (EDA), and SQL-based business analysis to transform raw retail transaction data into meaningful insights that can support data-driven business decisions.

## 🎯 Project Objectives

- Analyze overall retail sales performance.
- Identify top-performing product categories.
- Understand customer purchasing behavior and frequency.
- Segment customers based on their spending patterns.
- Analyze monthly sales trends and identify the best-performing months.
- Compare weekday and weekend sales performance.
- Identify high-value customers.
- Explore purchasing behavior across gender and age groups.
- Generate actionable business insights and recommendations.

## 🛠️ Tools & Technologies

- **Database:** PostgreSQL
- **Query Language:** SQL
- **Database Management Tool:** pgAdmin 4
- **Version Control:** Git & GitHub

## 📂 Dataset Information

The dataset contains retail transaction records, including customer information, product categories, transaction dates, quantities, and sales-related financial details.

### Table: `retail_sales`

| Column Name | Description |
|---|---|
| transactions_id | Unique transaction identifier |
| sale_date | Date of the transaction |
| sale_time | Time of the transaction |
| customer_id | Unique customer identifier |
| gender | Customer gender |
| age | Customer age |
| category | Product category |
| quantity | Number of items purchased |
| price_per_unit | Price of each unit |
| cogs | Cost of goods sold |
| total_sale | Total transaction amount |

---

# 🗄️ 1. Database & Table Creation

Created a retail_sales table in PostgreSQL with appropriate data types and a primary key constraint.

### SQL Code

```sql
-- Create Retail Sales Table

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

# 🧹 2. Data Cleaning

Performed data quality checks to identify missing values and improve the reliability of the dataset before conducting further analysis.

### Data Cleaning Activities

- Checked for NULL values across important columns.
- Identified missing customer age values.
- Replaced missing age values using the average age.
- Removed records containing NULL values in critical transaction fields.
- Verified the dataset after cleaning.

### SQL Code

**Step 1: Identify Missing Values**

```sql
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
```

**Step 2: Handle Missing Age Values**

```sql
update retail_sales
set age = (
             select 
             round(avg(age)) 
             from retail_sales
)
where age is null
```

**Step 3: Remove Records with Critical Missing Values**

```sql
delete from retail_sales
where transactions_id is null 
   or sale_date is null
   or sale_time is null 
   or customer_id is null
   or category is null
   or quantity is null
   or price_per_unit is null
   or cogs is null
   or total_sale is null
```

**Step 4: Verify Cleaned Dataset**

```sql
select * from retail_sales
```

---

# 🔍 3. Data Exploration

Performed initial exploratory analysis to understand the dataset structure, transaction volume, customer base, and available product categories.

### Exploration Activities

- Calculated the total number of transactions.
- Identified the total number of unique customers.
- Retrieved all available product categories.
- Reviewed the overall dataset.

### SQL Code

**1. View the Dataset**

```sql
SELECT *
FROM retail_sales;
```

**2. Total Number of Transactions**

```sql
select count(*) from retail_sales
```

**3. Total Unique Customers**

```sql
select count(distinct customer_id) from retail_sales
```

**4. Available Product Categories**

```sql
select distinct category from retail_sales

```

---

# 📊 4. Data Analysis & Business Questions

This section presents 15 business questions solved using SQL to analyze retail sales performance and customer purchasing behavior.

## Q1. Daily Sales Transaction Analysis

**Business Question:**

Retrieve all transaction records for November 5, 2022.

**SQL Query:**

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

**Query Output:**

![Q1 Output](<./All Output Image/Image 1.png>)

**Finding:**

This query identifies all transactions recorded on a specific date, allowing the business to examine daily sales activities and transaction details.

---

## Q2. Clothing Sales Analysis – November 2022

**Business Question:**

Retrieve all transactions where the product category is 'Clothing', the purchase quantity is at least 4 units, and the transaction occurred during November 2022.

**SQL Query:**

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

**Query Output:**

![Q2 Output](<./All Output Image/Image 2.png>)

**Finding:**

This analysis identifies customers purchasing larger quantities of clothing products during November. These transactions can help the business understand bulk purchasing patterns and evaluate seasonal sales opportunities.

---

## Q3. Category-Wise Sales Analysis

**Business Question:**

Calculate the total sales revenue generated by each product category.

**SQL Query:**

```sql
SELECT
    category,
    SUM(total_sale) AS "Category_Wise_Total_Sales"
FROM retail_sales
GROUP BY 1;
```

**Query Output:**

![Q3 Output](<./All Output Image/Image 3.png>)

**Finding:**

This analysis reveals the revenue contribution of each product category. It helps identify the categories generating the highest and lowest sales revenue, supporting product assortment and marketing decisions.

---

## Q4. Average Customer Age – Beauty Category

**Business Question:**

Calculate the average age of customers who purchased products from the Beauty category.

**SQL Query:**

```sql
SELECT
    ROUND(AVG(age)) AS "Average Age"
FROM retail_sales
WHERE category = 'Beauty';
```

**Query Output:**

![Q4 Output](<./All Output Image/Image 4.png>)

**Finding:**

This analysis provides an overview of the average customer age associated with Beauty purchases. It can help the business understand the customer demographics of this product category and plan relevant marketing campaigns.

---

## Q5. High-Value Transaction Analysis

**Business Question:**

Retrieve all transactions where the total sales amount exceeds 1,000.

**SQL Query:**

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

**Query Output:**

![Q5 Output](<./All Output Image/Image 5.png>)

**Finding:**

This analysis identifies high-value transactions and helps the business understand larger purchasing activities. These transactions can be further examined to identify valuable customer segments and high-revenue product categories.

---

## Q6. Gender-Based Transaction Analysis

**Business Question:**

Calculate the total number of transactions made by each gender across different product categories.

**SQL Query:**

```sql
SELECT
    gender,
    category,
    COUNT(transactions_id) AS "Total Transactions"
FROM retail_sales
GROUP BY 1, 2;
```

**Query Output:**

![Q6 Output](<./All Output Image/Image 6.png>)

**Finding:**

This analysis compares transaction volumes across gender and product categories. It helps identify differences in purchasing activity and understand which categories receive more transactions from each gender.

---

## Q7. Best-Selling Month Analysis

**Business Question:**

Calculate the average monthly sales and identify the best-performing month in each year based on average transaction value.

**SQL Query:**

```sql
WITH cte1 AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS "Year",
        EXTRACT(MONTH FROM sale_date) AS "Month",
        ROUND(AVG(total_sale)::NUMERIC, 2) AS "AVG Sales",
        DENSE_RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
)
SELECT
    "Year",
    "Month",
    "AVG Sales"
FROM cte1
WHERE rank = 1;
```

**Query Output:**

![Q7 Output](<./All Output Image/Image 7.png>)

**Finding:**

This analysis identifies the month with the highest average transaction value in each year. It helps the business recognize periods when customers tend to spend more per transaction and plan promotional activities accordingly.

---

## Q8. Top 5 Customers by Total Sales

**Business Question:**

Identify the top 5 customers based on their highest total purchase amount.

**SQL Query:**

```sql
SELECT
    customer_id,
    "Total_Sales"
FROM (
    SELECT
        customer_id,
        SUM(total_sale) AS "Total_Sales",
        DENSE_RANK() OVER (
            ORDER BY SUM(total_sale) DESC
        ) AS "Rank"
    FROM retail_sales
    GROUP BY 1
) AS customer_sales
WHERE "Rank" <= 5;
```

**Query Output:**

![Q8 Output](<./All Output Image/Image 8.png>)

**Finding:**

This analysis identifies the customers contributing the highest sales revenue. These customers represent valuable segments that the business can target through loyalty programs, personalized offers, and customer retention strategies.

---

## Q9. Category-Wise Unique Customer Analysis

**Business Question:**

Calculate the number of unique customers who purchased products from each category.

**SQL Query:**

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS "Total_Customers"
FROM retail_sales
GROUP BY 1;
```

**Query Output:**

![Q9 Output](<./All Output Image/Image 9.png>)

**Finding:**

This analysis reveals how many individual customers purchase from each product category. It helps identify categories with broader customer reach and those that may require additional promotional efforts.

---

## Q10. Sales Shift Analysis

**Business Question:**

Categorize sales transactions into Morning, Afternoon, and Evening shifts and calculate the total number of transactions in each shift.

**Shift Classification:**

- Morning: Before 12:00 PM
- Afternoon: 12:00 PM to 5:00 PM
- Evening: After 5:00 PM

**SQL Query:**

```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN sale_time < '12:00:00' THEN 'Morning'
            WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
            ELSE 'Evening'
        END AS "Shift"
    FROM retail_sales
)
SELECT
    "Shift",
    COUNT(*) AS "Total_Orders"
FROM hourly_sale
GROUP BY 1;
```

**Query Output:**

![Q10 Output](<./All Output Image/Image 10.png>)

**Finding:**

This analysis identifies the time periods with the highest transaction volume. It can help businesses optimize staff scheduling, manage operational resources, and plan time-based promotional activities.

---

## Q11. Gender-Wise Sales Analysis

**Business Question:**

Calculate the total sales revenue generated by each gender.

**SQL Query:**

```sql
SELECT
    gender,
    SUM(total_sale) AS "Total_Sales"
FROM retail_sales
GROUP BY 1;
```

**Query Output:**

![Q11 Output](<./All Output Image/Image 11.png>)

**Finding:**

This analysis compares total revenue generated by each gender. It helps the business understand revenue distribution across customer groups and evaluate opportunities for targeted marketing strategies.

---

## Q12. Weekday vs. Weekend Sales Analysis

**Business Question:**

Compare total sales revenue, transaction counts, and average transaction values between weekdays and weekends.

**SQL Query:**

```sql
SELECT
    CASE
        WHEN EXTRACT(ISODOW FROM sale_date) IN (6, 7)
            THEN 'Weekend'
        ELSE 'Weekdays'
    END AS "Weektype",
    SUM(total_sale) AS "Total_Sales",
    COUNT(transactions_id) AS "Total_Transactions",
    ROUND(AVG(total_sale)) AS "AVG_Sales"
FROM retail_sales
GROUP BY 1;
```

**Query Output:**

![Q12 Output](<./All Output Image/Image 12.png>)

**Finding:**

This analysis compares customer purchasing activity between weekdays and weekends. It helps identify differences in sales revenue, transaction volume, and average transaction value, supporting better promotional and operational planning.

---

## Q13. Age Group-Based Sales Analysis

**Business Question:**

Calculate total sales revenue across different customer age groups.

**Customer Segmentation:**

| Age Range | Customer Segment |
|---|---|
| Below 18 | Teen Segment |
| 18–25 | Youth Segment |
| 26–35 | Young Adult Segment |
| 36–50 | Adult Segment |
| 51+ | Senior Segment |

**SQL Query:**

```sql
SELECT
    CASE
        WHEN age < 18 THEN 'Teen Segment'
        WHEN age BETWEEN 18 AND 25 THEN 'Youth Segment'
        WHEN age BETWEEN 26 AND 35 THEN 'Young Adult Segment'
        WHEN age BETWEEN 36 AND 50 THEN 'Adult Segment'
        ELSE 'Senior Segment'
    END AS "Age Group",
    SUM(total_sale) AS "Total Sales"
FROM retail_sales
GROUP BY 1;
```

**Query Output:**

![Q13 Output](<./All Output Image/Image 13.png>)

**Finding:**

This analysis identifies which age groups contribute the most sales revenue. It helps the business understand customer demographics and develop age-based marketing campaigns and product offers.

---

## Q14. Customer Purchase Frequency Analysis

**Business Question:**

Analyze customer purchase frequency and classify customers based on their total number of transactions.

**Customer Segmentation:**

| Transactions | Customer Type |
|---|---|
| 1 | One-Time Customer |
| 2–3 | Occasional Customer |
| 4–6 | Regular Customer |
| 7+ | Frequent Customer |

**SQL Query:**

```sql
SELECT
    customer_id,
    COUNT(customer_id) AS "Purchase Frequency",
    CASE
        WHEN COUNT(customer_id) = 1
            THEN 'One-Time Customer'
        WHEN COUNT(customer_id) <= 3
            THEN 'Occasional Customer'
        WHEN COUNT(customer_id) BETWEEN 4 AND 6
            THEN 'Regular Customer'
        ELSE 'Frequent Customer'
    END AS "Customer Type"
FROM retail_sales
GROUP BY 1
order BY 1
```

**Query Output:**

![Q14 Output](<./All Output Image/Image 14.png>)

**Finding:**

This analysis categorizes customers based on their purchasing frequency. It helps identify one-time buyers, occasional shoppers, regular customers, and frequent buyers. The business can use these segments to improve customer retention and encourage repeat purchases.

---

## Q15. Customer Spending Category Analysis

**Business Question:**

Segment customers into Low, Medium, and High Spenders based on their total purchase amount.

**Customer Segmentation:**

- Low Spenders
- Medium Spenders
- High Spenders

**SQL Query:**

```sql
WITH cus_seg AS (
    SELECT
        customer_id,
        SUM(total_sale) AS "Total Sales",
        NTILE(3) OVER (
            ORDER BY SUM(total_sale)
        ) AS "Spending Rank"
    FROM retail_sales
    GROUP BY 1
)
SELECT *,
    CASE
        WHEN "Spending Rank" = 1 THEN 'Low Spenders'
        WHEN "Spending Rank" = 2 THEN 'Medium Spenders'
        ELSE 'High Spenders'
    END AS "Customer Spending Category"
FROM cus_seg
ORDER BY 1;
```

**Query Output:**

![Q15 Output](<./All Output Image/Image 15.png>)

**Finding:**

This analysis divides customers into three spending segments based on their total purchase amounts. It helps identify high-value customers, moderate spenders, and low spenders, allowing the business to design differentiated customer engagement and retention strategies.

---

# 📌 5. Overall Key Findings

Based on the 15 SQL analyses, the following areas of business performance and customer behavior can be evaluated:

1. **Category Performance:** Category-wise sales analysis highlights the contribution of different product categories to overall revenue.
2. **Customer Value:** Top customer analysis identifies customers with the highest total purchase amounts.
3. **Customer Demographics:** Gender-wise and age group-based analysis provides insights into customer purchasing patterns.
4. **Purchase Frequency:** Customer segmentation reveals different levels of purchasing engagement.
5. **Spending Behavior:** Spending segmentation helps distinguish customers based on their contribution to sales.
6. **Sales Timing:** Monthly and shift-based analyses help identify important sales periods.
7. **Purchase Patterns:** Weekday and weekend comparisons reveal differences in customer purchasing activities.


# 🎓 6. Key Learnings

Through this project, I strengthened my practical SQL skills in:

- Database and table creation.
- Data cleaning and quality checking.
- Data exploration and aggregation.
- Filtering and conditional logic.
- Date and time-based analysis.
- GROUP BY and aggregate functions.
- Common Table Expressions (CTEs).
- Subqueries.
- Window Functions (DENSE_RANK and NTILE).
- Customer segmentation.
- Translating business requirements into SQL queries.

# 📝 7. Conclusion

This Retail Sales Analysis project demonstrates how SQL can be used to transform raw transaction data into meaningful business insights.

By performing data cleaning, exploratory analysis, and solving 15 business-driven questions, the project provides a structured approach to understanding sales performance, customer behavior, and purchasing patterns.

The insights generated from this analysis can support better business decisions related to customer retention, marketing strategies, product performance, and sales optimization.

## 👨‍💻 Author

**Md Jahidul Islam Rakib**

B.Sc. in Computer Science & Engineering

Aspiring Data Analyst | SQL | Excel | Power BI | Python

- **GitHub:** [Visit My GitHub Profile](https://github.com/Rakib2316?tab=repositories)
- **LinkedIn:** [Connect with Me on LinkedIn](https://www.linkedin.com/in/md-jahidul-islam-rakib-67093336b/)
