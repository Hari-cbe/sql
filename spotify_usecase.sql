
DROP TABLE activity;
CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

select * from activity;

-- Question 1 Find total active users each day

explain select event_date, count(distinct user_id)
from activity 
group by event_date;

-- Question 2 Find total active users each weak

select event_date,extract(week from event_date), date_part('week', event_date)
from activity

-- Question 3 date wise total number of users who made the purchase same day they installed the app 

with users_purchased as (
    select 
        user_id
        , event_date as purchase_date
    from activity
    where event_name  = 'app-purchase'
)
, users_installed as (
        select 
        user_id
        , event_date as installed_date
    from activity
    where event_name  = 'app-installed'
)
, checking as (
select 
    up.purchase_date as event_date, COUNT(up.user_id) as users
    from users_purchased up inner join users_installed ui ON up.user_id = ui.user_id AND up.purchase_date = ui.installed_date
    GROUP BY up.purchase_date
)
select act.event_date, COALESCE(MAX(users),0)
    from activity act left join checking ON act.event_date = checking.event_date 
    GROUP BY act.event_date
    ORDER BY act.event_date ;

--- Question 4 : Percentage of paid users in India, USA and any other country should be marked as Others

select 
    CASE WHEN country IN ('India','USA') then country else 'others' end as countries
   , round((sum(case when event_name = 'app-purchase' then 1 else 0 end)::decimal /  (select count(distinct user_id) from activity)) * 100,2) as percentage_of_paid_customers
 from activity
 group by CASE WHEN country IN ('India','USA') then country else 'others' end



 -- Question 5: date wise total number of users who made the purchase next day they installed the app 

 explain with users_purchased as (
    select 
        user_id
        , event_date as purchase_date
    from activity
    where event_name  = 'app-purchase'
)
, users_installed as (
        select 
        user_id
        , event_date as installed_date
    from activity
    where event_name  = 'app-installed'
)
, checking as (
select 
    up.purchase_date as event_date, COUNT(up.user_id) as users
    from users_purchased up inner join users_installed ui ON up.user_id = ui.user_id AND  ui.installed_date + 1 =  up.purchase_date 
    GROUP BY up.purchase_date
)
select act.event_date, COALESCE(MAX(users),0)
    from activity act left join checking ON act.event_date = checking.event_date 
    GROUP BY act.event_date
    ORDER BY act.event_date ;