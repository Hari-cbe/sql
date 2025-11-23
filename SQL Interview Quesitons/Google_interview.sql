
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date TIMESTAMP
);

delete from Transactions;
INSERT INTO Transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO Transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');


SELECT * FROM transactions;

with cte as (
SElECT 
    *,
    row_number() over (partition by amount, tran_date order by transaction_id) as row_number
FROM transactions
)
, combination_result as (
select 
    MAX(case when row_number = 1 then customer_id end) as seller_id
    , MAX(case when row_number = 2 then customer_id end) as buyer_id
      from cte
    GROUP BY amount, tran_date
)
select 
    seller_id, buyer_id, COUNT(*)
    FROM combination_result
    WHERE seller_id not in (select distinct buyer_id from combination_result)
        AND buyer_id not in (select distinct seller_id from combination_result)
    GROUP BY seller_id, buyer_id 