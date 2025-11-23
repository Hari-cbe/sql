create table booking_table (
    booking_id varchar(10),
    booking_date date,
    user_id varchar(10),
    line_of_business varchar(20)
);

insert into booking_table (booking_id, booking_date, user_id, line_of_business) values
('b1',  '2022-03-23', 'u1', 'Flight'),
('b2',  '2022-03-27', 'u2', 'Flight'),
('b3',  '2022-03-28', 'u1', 'Hotel'),
('b4',  '2022-03-31', 'u4', 'Flight'),
('b5',  '2022-04-02', 'u1', 'Hotel'),
('b6',  '2022-04-02', 'u2', 'Flight'),
('b7',  '2022-04-06', 'u5', 'Flight'),
('b8',  '2022-04-06', 'u6', 'Hotel'),
('b9',  '2022-04-06', 'u2', 'Flight'),
('b10', '2022-04-10', 'u1', 'Flight'),
('b11', '2022-04-12', 'u4', 'Flight'),
('b12', '2022-04-16', 'u1', 'Flight'),
('b13', '2022-04-19', 'u2', 'Flight'),
('b14', '2022-04-20', 'u5', 'Hotel'),
('b15', '2022-04-22', 'u6', 'Flight'),
('b16', '2022-04-26', 'u4', 'Hotel'),
('b17', '2022-04-28', 'u2', 'Hotel'),
('b18', '2022-04-30', 'u1', 'Hotel'),
('b19', '2022-05-04', 'u4', 'Hotel'),
('b20', '2022-05-06', 'u1', 'Flight');

create table user_table (
    user_id varchar(10),
    segment varchar(10)
);

insert into user_table (user_id, segment) values
('u1', 's1'),
('u2', 's1'),
('u3', 's1'),
('u4', 's2'),
('u5', 's2'),
('u6', 's3'),
('u7', 's3'),
('u8', 's3'),
('u9', 's3'),
('u10', 's3');

Select * from booking_table;
select * from user_table;

-- Question 1 : In Each segment find the total number of users booked flights in apr2022


select 
    user_table.segment,
    COUNT(DISTINCT user_table.user_id) as total_users,
    COUNT(DISTINCT CASE WHEN (booking_date between '2022-04-01' AND '2022-04-30') AND Booking.line_of_business = 'Flight'  THEN user_table.user_id END) as flights_booked_in_apr2022
    FROM user_table LEFT JOIN Booking_table booking ON booking.user_id = user_table.user_id 
    GROUP BY user_table.segment



-- Question 2 : find For-Each Segment, the users, who made the earlist booking in Apr,2022 and also return how many total bookings the user made in April 2022


SELECT a.segment,a.user_id,a.booking_date,a.cnt
FROM(
Select 
    user_table.segment, booking_table.user_id,booking_table.booking_date,
    row_number() OVER (partition by user_table.segment ORDER BY booking_table.booking_date asc) as min_booking_date ,
    COUNT(booking_table.user_id) OVER (partition by user_table.segment, booking_table.user_id) as cnt
    FROM booking_table
    JOIN user_table ON booking_table.user_id = user_table.user_id
WHERE booking_table.booking_date BETWEEN '2022-04-01' AND '2022-04-30'
) a 
WHERE a.min_booking_date = 1



-- Question 3: Identify Users how's first booking was a hotel
with cte as (
Select
    user_id,
    line_of_business,
    row_number() over (partition by user_id order by booking_date) as first_booking_id
FROM booking_table
)
select user_id
    from cte 
    where first_booking_id = 1 and line_of_business = 'Hotel';


-- Question 4 : Write a query to calculate the days between first and last booking of the user with user_id = 1

SELECT 
     MAX(booking_date) - MIN(booking_date) as days_between_first_&_last_booking -- DATE_DIFF()
FROM booking_table
WHERE user_id = 'u1';

-- Question 5 : Write a Query to count the number of flights and hotel booking in each of the user segments for the year 2022

SELECT 
    user_table.segment,
    COUNT( CASE WHEN line_of_business = 'Hotel' THEN booking_table.user_id END) as no_of_hotel_bookings,
    COUNT( CASE WHEN line_of_business = 'Flight' THEN booking_table.user_id END) as no_of_flight_bookings
    FROM booking_table
    JOIN user_table ON booking_table.user_id = user_table.user_id
    WHERE EXTRACT(Year from booking_table.booking_date) = '2022'
    GROUP BY user_table.segment

