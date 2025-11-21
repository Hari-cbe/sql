
/* A company has various depts and its employees and clients. Find the best client and best emp based on their sales based on the dept */
-- (YT : https://youtu.be/TgFL2Wd9CQA?si=fstqRE6jZq-08VqJ)

-- Create tables
CREATE TABLE department (
    dep_id INT,
    dep_name VARCHAR(50)
);

CREATE TABLE empdetails (
    emp_id INT,
    first_name VARCHAR(50),
    gender VARCHAR(1),
    dep_id INT
);

CREATE TABLE client (
    client_id INT,
    client_name VARCHAR(50)
);

CREATE TABLE empsales (
    emp_id INT,
    client_id INT,
    sales INT
);

-- Insert data
INSERT INTO department (dep_id, dep_name) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing');

INSERT INTO empdetails (emp_id, first_name, gender, dep_id) VALUES
(101, 'Alice', 'F', 1),
(102, 'Bob', 'M', 1),
(103, 'Charlie', 'M', 2),
(104, 'Diana', 'F', 2),
(105, 'Ethan', 'M', 3),
(106, 'Fiona', 'F', 3);

INSERT INTO client (client_id, client_name) VALUES
(1, 'Amazon'),
(2, 'Walmart'),
(3, 'Costco'),
(4, 'Target'),
(5, 'BestBuy');

INSERT INTO empsales (emp_id, client_id, sales) VALUES
(101, 1, 5000),
(101, 2, 3000),
(102, 1, 7000),
(102, 3, 2000),
(103, 2, 4000),
(103, 4, 3000),
(104, 4, 6000),
(105, 5, 8000),
(106, 3, 5000),
(106, 5, 2000);

WITH CTE AS (
    select empsales.emp_id, empsales.client_id, empsales.sales , empdetails.dep_id as dept_id
    FROM empdetails 
    LEFT JOIN empsales ON empsales.emp_id = empdetails.emp_id
)
, best_emp as (
    SELECT 
        dept_id, emp_id, rank() over (partition by dept_id order by emp_total_sales desc ) emp_rank
        FROM (
    select 
        dept_id
        , emp_id
        , sum(sales) as emp_total_sales
        from cte
        GROUP BY dept_id, emp_id
    ) a
)
, best_client as (
    SELECT 
        dept_id, client_id, rank() over (partition by dept_id order by client_total_sales desc ) client_rank
        FROM (
    select 
        dept_id
        , client_id
        , sum(sales) as client_total_sales
        from cte
        GROUP BY dept_id, client_id
    ) a
)
select dep_id,dep_name,be.emp_id, bc.client_id
    from department dpt
    LEFT JOIN best_emp be ON be.dept_id = dpt.dep_id AND emp_rank = 1
    LEFT JOIN best_client bc ON bc.dept_id = dpt.dep_id AND client_rank = 1

/*
OUTPUT : 
1	Electronics	102	1
2	Furniture	103	4
3	Clothing	105	5
*/
