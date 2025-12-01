-- create and insert script for this problem. Do try yourself without using CTE.

create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

select * from sales;


WITH RECURSIVE cte AS (

    SELECT 
        product_id,
        average_daily_sales,
        period_start::date,
        period_end
    FROM sales  

    UNION ALL

    SELECT 
        product_id,
        average_daily_sales,
        (period_start + interval '1 day')::date as period_start,
        period_end
    FROM cte 
    WHERE period_start < period_end

)
SELECT product_id, extract(YEAR FROM period_start), sum(average_daily_sales) as total_sales FROM cte
 GROUP BY product_id, extract(YEAR FROM period_start);