-- =====================		SAFARIRIDE CTE PRACTICE QUESTIONS		==============================
-- =====================		Section A								==============================


/* 	A1. Busy Drivers
	Write a CTE that counts each driver's total trips. 
	Show only drivers with 5 or more trips, ordered from most to fewest.
 */

with trip_count as (
	select
		t.driver_id,
		count(trip_id) as no_of_trips
	from safari.trips t 
	group by t.driver_id 
)
select 
	t.driver_id,
	d.driver_name, 
	t.no_of_trips 
from trip_count t
inner join safari.drivers d 
on t.driver_id = d.driver_id
where t.no_of_trips  >= 5
order by no_of_trips desc;


-- =====================================================================================================

/* A2. Big Spenders
 	Write a CTE that calculates each rider's total spend across all their trips. 
	Show only riders who have spent more than 3,000 in total, ordered highest spend first.
*/ 	

with rider_fare as (
	select 
		rider_id,
		sum(fare) as total_fare_spent
	from safari.trips t 
	group by rider_id
	having sum(fare) > 3000
	order by total_fare_spent desc
)
select 
	rf.rider_id, 
	r.rider_name,
	rf.total_fare_spent 
from rider_fare rf
inner join safari.riders r 
on rf.rider_id = r.rider_id;

-- =====================================================================================================

/*	A3. Above-Average Earners
	Write a CTE that calculates each driver's average fare per trip. 
	Show only drivers whose average fare is above the overall average fare across ALL trips, ordered highest average first.
	Hint: you'll need to know the overall average fare first - either as a separate simple query, 
	or hard-code the value once you've checked it.
 */	

-- Using a cross join
with avg_fare as (
	select avg(fare) as fare_avg
	from safari.trips 
),
driver_avg_fare as (
	select 
		driver_id, 
		round(avg(fare), 2) as avg_driver_fare
	from safari.trips
	group by driver_id
)
select 
	df.driver_id, 
	d.driver_name, 
	df.avg_driver_fare
from driver_avg_fare df
cross join avg_fare f
inner join safari.drivers d 
on d.driver_id = df.driver_id 
where df.avg_driver_fare > f.fare_avg
group by df.driver_id, d.driver_name, df.avg_driver_fare 
order by df.avg_driver_fare desc;


/*
 *-- Using a subquery
Step 1 Find the overall average fare
Step 2 Build the CTE for each drivers average: GROUP BY driver_id, avg(fare)
Step 3 Filter the outer query to avg_fare > 955.225
Step 4 ORDER BY avg_fare
Step 5 JOIN drivers table to show names for reference
*/
 
with driver_avg_fare as (
	select
		driver_id, 
		round(avg(fare),2) as avg_fare
	from safari.trips
	group by driver_id
)
select 
	daf.driver_id, 
	d.driver_name,
	daf.avg_fare
from driver_avg_fare daf
join safari.drivers d on d.driver_id = daf.driver_id
where daf.avg_fare > (select AVG(fare) as averallavg_
from safari.trips)
order by avg_fare desc;


-- =====================================================================================================

/*	A4. Popular Payment Methods
	Write a CTE that counts trips per payment_method. 
	Show only payment methods used in more than 12 trips,
	 ordered most used first.
 */

 with payment_method_count as ( 
 	select
 		payment_method, 
 		count(trip_id) as no_of_trips_used
	from safari.trips
	group by payment_method
 )
select 
	payment_method, 
	no_of_trips_used
from payment_method_count 
where no_of_trips_used > 12
order by no_of_trips_used desc;


-- =====================================================================================================

/* 	A5. Top 3 Busiest Drivers
	Write a CTE that counts each driver's total trips, 
	then use ORDER BY and LIMIT on the outer query to show only the top 3 busiest drivers. 
	(Tip: add a second ORDER BY column to break ties consistently.)
 */

with driver_trips as ( 
	select 
		driver_id, 
		count(*) as no_of_trips
	from safari.trips t
	group by driver_id 
)
select
	dt.driver_id, 
	d.driver_name, 
	dt.no_of_trips
from driver_trips dt
inner join drivers d 
on d.driver_id = dt.driver_id 
order by no_of_trips desc
limit 3;


-- =====================================================================================================

/* 	A6. Riders Who Need a Check-In Call
	Write a CTE that counts each rider's trips 
	- including riders with ZERO trips
	 (think about which JOIN type keeps rows with no match).
	  Show only riders with fewer than 2 trips.
*/


with rider_trip_count as (  
	select
		rider_id, 
		count(*) as no_of_trips
	from safari.trips t
	group by rider_id  
)
select
	rt.rider_id, 
	r.rider_name,
	rt.no_of_trips
from rider_trip_count rt
inner join riders r 
on r.rider_id = rt.rider_id 
where no_of_trips < 2
order by no_of_trips desc;


-- =====================================================================================================