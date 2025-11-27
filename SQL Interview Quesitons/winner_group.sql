create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

drop table matches;
create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

-- Question 1
/* Write a SQl query to find the winner in each group 

-- The winner in each group is the player how scored the maximum total points within the group, 
-- In case of tie, the lowest player_id wins */

select * from matches;

select * from players;

WITH combine_cte as (
select first_player as player,first_score as score from matches 
UNION ALL 
select second_player as player,second_score as score from matches 
)
,agg_result as (
select player,sum(score) as total_points from combine_cte group by player
)
, result as (
select group_id, player,rank() over (partition by group_id order by total_points desc, player) as ranking
    from agg_result
    inner join players on agg_result.player = players.player_id
)
select group_id, player as player_id from result where ranking = 1