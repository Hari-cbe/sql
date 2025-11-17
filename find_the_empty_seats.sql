CREATE TABLE movie(seat VARCHAR, occupancy INT);

INSERT INTO movie VALUES
('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);


SELECT * from movie;

with rn_ as (
    select  *, 
        lead(occupancy,1) over (PARTITION BY substring(seat,1,1)) as next_seat_occ,
        lead(occupancy,2) over (PARTITION BY substring(seat,1,1)) as second_seat_occ,
        lead(occupancy,3) over (PARTITION BY substring(seat,1,1)) as third_next_seat_occ
    from movie
)
select seat
     from rn_
     where occupancy = 0 and occupancy = next_seat_occ and  next_seat_occ = second_seat_occ and second_seat_occ = third_next_seat_occ