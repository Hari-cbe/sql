
create table tasks (
date_value date,
state varchar(10)
);


insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');


select * from tasks;

with prev_state_cte as (
select 
    date_value,
    state,
    lag(state) over (order by date_value) as prev_state
from tasks
)
, grp_state as (
select 
    date_value,
    state ,
    prev_state,
    case when state = prev_state then 0 else 1 end as grp_state
from
    prev_state_cte
)
, result as (
    select 
        date_value,
        state ,
        prev_state,
        grp_state,
        sum(grp_state) over (order by date_value) as grp
from grp_state
) 
select
 min(date_value) as start_date,
 max(date_value) as end_date,
 max(state) as state
from result 
group by grp
order by 1