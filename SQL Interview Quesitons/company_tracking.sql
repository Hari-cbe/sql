--(Youtube: https://youtu.be/P6kNMyqKD0A?si=tL9r9SFqB7aJbaB6)


create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');


with cte as(
    SELECT name, floor FROM (
                select name, floor, count(1) as cnt ,rank() over (partition by name order by count(1) desc) as rn
                from entries
                GROUP BY name, floor
            ) a
    WHERE rn = 1
)
, main_table as (
Select 
    name,
    count(*) as total_visits,
    string_agg(distinct resources,',') as grp_str
     from entries
     GROUP BY name
)
select 
    main_table.name, main_table.total_visits, cte.floor, main_table.grp_str
FROM main_table join cte on main_table.name = cte.name