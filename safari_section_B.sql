-- =====================		SAFARIRIDE CTE PRACTICE QUESTIONS		==============================
-- =====================		Section B								==============================


/*  B1. Active Driver Leaderboard
	Write a CTE that computes each driver's total revenue, 
	then JOIN it to the drivers table so you can filter to only status = 'Active' drivers. 
	Show driver_name, car_model, and total_revenue, ordered highest revenue first.
 * */

with driver_revenue as ( 
	select 
		driver_id, 
		sum(fare) as driver_revenue
	from safari.trips t 
	group by driver_id
)
select 
	dr.driver_id, 
	d.driver_name,
	d.car_model, 
	dr.driver_revenue 
from driver_revenue dr
inner join drivers d 
on  dr.driver_id = d.driver_id
order by driver_revenue desc;


-- =====================================================================================================

/*  B2. Rating Breakdown
	Write a CTE with a CASE WHEN that labels each trip's rider_rating as 'Poor' (1–2), 'Good' (3), or 'Excellent' (4–5). 
	Then count how many trips fall into each label, ordered most common first.
*/ 

with ride_category as (
	select 
		case 
			when rider_rating <= 2 then 'Poor'
			when rider_rating = 3 then 'Good'
			else 'Excellent'
		end as ride_rating,
	count(*) as rating_count
	from safari.trips 
	group by
	    case
	        when rider_rating <= 2 then 'Poor'
	        when rider_rating = 3 then 'Good'
	        else 'Excellent'
	    end
)
select *
from ride_category 
order by rating_count desc;


-- =====================================================================================================

/*	 B3. Premium Rider Fares
	 Write a CTE that computes each rider's average fare per trip,
	 then JOIN it to riders and filter to only membership_tier = 'Premium'. 
	 Show rider_name, membership_tier, and avg_fare, ordered highest first.
 */


with avg_rider_fare as (
	select
		rider_id,
		round(avg(fare), 2) as rider_avg_fare
	from trips t 
	group by rider_id
)
select 
	arf.rider_id,
	r.membership_tier,
	arf.rider_avg_fare 
from avg_rider_fare arf
inner join riders r 
on arf.rider_id = r.rider_id 
where r.membership_tier = 'Premium'
order by rider_avg_fare desc;

-- =====================================================================================================

/* 	B4. The Inactive Driver's History
	Write a CTE that counts total trips per driver, then JOIN it to drivers filtering to status = 'Inactive'. 
	Show driver_name and total_trips - even inactive drivers have trip history worth checking.
*/ 


with driver_trip_count as ( 
	select 
		driver_id, 
		count(*) as trip_count
	from trips t 
	group by driver_id
)
select 
	dtc.driver_id, 
	d.status, 
	dtc.trip_count 
from driver_trip_count dtc
inner join drivers d 
on dtc.driver_id = d.driver_id
where d.status = 'Inactive';

-- =====================================================================================================

/* 	B5. Early vs. Late Month Trips
	Write a CTE with a CASE WHEN that labels each trip as 'Early (1-15)' or 'Late (16-31)' based on the day-of-month in trip_date.
	Then show trip count and total fare for each label, ordered most trips first.
	Hint: EXTRACT(DAY FROM trip_date) gets you the day-of-month as a number.
*/ 

with trip_period_count as ( 
	select 
	case
		when extract(day from trip_date) between 1 and 15 then 'Early'
		when extract(day from trip_date) between 16 and 31 then 'Late'
		else null
	end as trip_period,
	count(*) as trip_period_count,
	sum(fare) as total_fare_per_period
	from safari.trips
	group by
		case
			when extract(day from trip_date) between 1 and 15 then 'Early'
			when extract(day from trip_date) between 16 and 31 then 'Late'
			else null
		end
)
select * 
from trip_period_count tpc
order by trip_period_count desc;


-- =====================================================================================================


/* 	B6. Nairobi Riders, Ranked
	Write a CTE that computes each rider's total spend, then JOIN it to riders filtering to city = 'Nairobi'. 
	Order by total spend, highest first.
*/

with rider_spend as (
	select 
		rider_id, 
		sum(fare) as rider_total_spend
	from safari.trips t 
	group by rider_id
)
select 
	rs.rider_id, 
	r.rider_name,
	r.city, 
	rs.rider_total_spend 
from rider_spend rs
inner join riders r 
on r.rider_id = rs.rider_id 
where r.city = 'Nairobi'
order by rider_total_spend desc;


-- =====================================================================================================