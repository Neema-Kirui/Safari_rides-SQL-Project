-- =====================		SAFARI RIDE CTE PRACTICE QUESTIONS		==============================
-- =====================		Section 	C							==============================

/* 	C1. Underperforming Drivers
	Write two chained CTEs: the first computes each driver's total_trips and average rider_rating. 
	The second filters to drivers with total_trips >= 4 AND average rating below 3.0. 
	JOIN to drivers and show driver_name, total_trips, and avg_rating, ordered worst rating first. 
 */


with driver_trip_count as (
	select 
		driver_id, 
		count(*) as driver_trips
	from safari.trips t
	group by driver_id
),
	avg_driver_rating as (
	select 
		driver_id,
		round(avg(rider_rating), 2) as driver_avg_rating
	from safari.trips t 
	group by driver_id
)
select 
	dtc.driver_id, 
	d.driver_name, 
	dtc.driver_trips, 
	adr.driver_avg_rating 
from driver_trip_count dtc
inner join avg_driver_rating adr 
on dtc.driver_id = adr.driver_id 
inner join safari.drivers d 
on d.driver_id = dtc.driver_id 
where dtc.driver_trips >= 4 and adr.driver_avg_rating < 3.0
order by adr.driver_avg_rating asc;

-- =====================================================================================================


/*	C2. Above-Average Spenders - Subquery, Then CTE
	Part 1: Solve this using a correlated subquery - 
	"which riders have spent more than the average total spend across all riders who've taken at least one trip?"
	Part 2: Rewrite your answer using one or more CTEs instead. 
	Show rider_name and total_spent for both versions, and be ready to explain which one you'd rather maintain.
*/

-- 		C2:part 1


select 
	rider_id, 
	count(*) as rider_trip_count, 
	sum(fare) as rider_total
from safari.trips t 
group by rider_id
having sum(fare) > (select avg(fare) from safari.trips t)
order by rider_total desc;


-- 		C2:part 2

with avg_fare as (
	select avg(fare) as fare_avg from safari.trips t
),
rider_avg as (
	select 
		rider_id, 
		count(*) as rider_trip_count, 
		sum(fare) as rider_total
	from safari.trips t 
	group by rider_id
)
select 
	rv.rider_id, 
	r.rider_name, 
	rv.rider_trip_count,
	rv.rider_total
from rider_avg rv
cross join avg_fare af
inner join safari.riders r 
on rv.rider_id = r.rider_id 
where rider_total > fare_avg
order by rv.rider_total desc;


-- ==================================================================================================


/*	 C3. Riders Who Pay More Per Trip Than Average
	Write a CTE that computes each rider's average fare per trip. 
	Separately, work out the overall average fare across all 40 trips. 
	Show riders whose personal average fare is above that overall average, ordered highest first.
*/


with avg_fare as (
	select avg(fare) as fare_avg from safari.trips t
),
rider_fare_avg as (
	select rider_id, round(avg(fare), 2) as avg_rider_fare
	from safari.trips
	group by rider_id
)
select
	rfa.rider_id,
	r.rider_name, 
	rfa.avg_rider_fare 
from rider_fare_avg rfa
cross join avg_fare af
inner join safari.riders r
on rfa.rider_id = r.rider_id 
where avg_rider_fare > fare_avg 
order by rfa.avg_rider_fare desc;
	
-- ==================================================================================================


/* 	C4. Top 3 Riders - Window Function Preview
	Write a CTE that ranks riders by total_spent using RANK() OVER (ORDER BY total_spent DESC), 
	then filter the outer query to rank <= 3. 
	(This is a preview of next session - give it a try using what we covered about filtering on window functions.)
*/


with fare_spent_ranked as (
	select rider_id, 
	sum(fare) as total_spent,
	rank() over (order by sum(fare) desc) as rider_rank
	from safari.trips t 
	group by rider_id
)
select 
	fsr.rider_id,
	r.rider_name, 
	fsr.total_spent, 
	fsr.rider_rank  
from fare_spent_ranked fsr
inner join safari.riders r 
on fsr.rider_id = r.rider_id 
where fsr.rider_rank <= 3
order by fsr.rider_rank ;


-- ==================================================================================================


/* 	C5. Best Rating Among the Busiest Drivers
	Write two chained CTEs: the first computes each driver's total_trips and avg_rating. 
	The second keeps only drivers whose total_trips is ABOVE the average trips-per-driver. 
	Show all qualifying drivers ordered by avg_rating, highest first.
*/


with driver_performance as (
	select driver_id, 
			count(*) as no_of_trips,
			round(avg(rider_rating), 2) as avg_driver_rating
	from safari.trips t 
	group by driver_id
),
trips_count as (
	select driver_id,
		   no_of_trips
	from driver_performance 
	where no_of_trips > 4
)
select 	dp.driver_id, 
		tc.no_of_trips, 
		dp.avg_driver_rating
from driver_performance dp
inner join trips_count tc
on dp.driver_id = tc.driver_id
order by dp.no_of_trips;

-- ==================================================================================================


/*	 C6. Challenge - Design Your Own
	Pick a business question of your own about SafariRide that needs at least two steps to answer 
	(for example: revenue earned per kilometre driven, or a loyalty score combining trip count and average rating). 
	Write it using chained CTEs. Be ready to explain your reasoning to the class.

 */


WITH driver_totals AS (
    -- CTE 1: Aggregate total fare and total distance per driver
    SELECT 
        driver_id,
        SUM(fare) AS total_fare,
        SUM(distance_km) AS total_km
    FROM safari.trips
    GROUP BY driver_id
),
efficiency AS (
    -- CTE 2: Calculate revenue efficiency (revenue per km)
    SELECT 
        driver_id, 
        total_fare, 
        total_km,
        ROUND(total_fare / total_km, 2) AS revenue_per_km
    FROM driver_totals
)
-- Final SELECT: Top 5 most efficient drivers
SELECT 
    d.driver_name, 
    e.revenue_per_km
FROM safari.drivers d
JOIN efficiency e 
    ON d.driver_id = e.driver_id
ORDER BY e.revenue_per_km DESC
LIMIT 5;

