
create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);


/* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.
*/

-- (YT : https://youtu.be/4MLVfsQEGl0?si=Ll8ZtqFPTii6g9u-)

select 
    spend_date,
    count(distinct user_id) as number_of_users,
    SUM(CASE WHEN platform = 'mobile' THEN amount ELSE 0 END) as mobile_spend,
    SUM(CASE WHEN platform = 'desktop' THEN amount ELSE 0 END) as desktop_spend,
    SUM(amount) as total_amount_spend
 from spending
    GROUP BY spend_date
