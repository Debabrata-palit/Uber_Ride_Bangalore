select * from booking_details
select * from ride_details
select * from unsuccessful_rides

-- Ride Completion Count
select count(*) as completed_rides
from booking_details
where booking_status ='Success'

-- Cancelled Rides Count
select count(*) as cancelled_rides
from booking_details
where booking_status not in ('Success', 'Incomplete')

-- Cancellation Reason Breakdown

-- (a) Rides Cancelled by Customer
select cancelled_rides_by_customer_reason, 
	count(*) as customer_cancel_count
from unsuccessful_rides
where cancelled_rides_by_customer_reason is not null
group by cancelled_rides_by_customer_reason
order by customer_cancel_count desc

-- (b) Rides Cancelled by Customer
select cancelled_rides_by_driver_reason, 
	count(*) as driver_cancel_count
from unsuccessful_rides
where cancelled_rides_by_driver_reason is not null
group by cancelled_rides_by_driver_reason
order by driver_cancel_count desc

-- Incomplete Rides Count
select count(*) as incomplete_rides
from booking_details
where booking_status = 'Incomplete'

-- Incomplete Ride Reason Breakdown
select incomplete_ride_reason, 
	count(*) as incomplete_ride_count
from unsuccessful_rides
where incomplete_ride_reason is not null
group by incomplete_ride_reason
order by incomplete_ride_count desc

-- Vehicle-Type Breakdown
select vehicle_type, count(*) as ride_count
from ride_details
group by vehicle_type

-- Top Pickup Locations
select pickup_location, count(*) as ride_count
from ride_details
group by pickup_location
order by ride_count desc
limit 5

-- Top Drop Locations
select drop_location, count(*) as ride_count
from ride_details
group by drop_location
order by ride_count desc
limit 5

-- Average Booking Value by Vehicle Type
select vehicle_type, round(avg(price), 2) as avg_booking_value
from ride_details
group by vehicle_type
order by avg_booking_value desc

-- Payment Method Popularity
select r.payment_method, count(*) as ride_count
from ride_details r
join booking_details b using(booking_id)
where b.booking_status = 'Success'
group by r.payment_method
order by ride_count desc

-- Customer Rating Analysis

-- (a) Vehicles with Most Number of High Ratings (4 or more)
select r.vehicle_type, 
	count(*) as high_rated_ride_count
from ride_details r
join booking_details b using (booking_id)
where b.booking_status = 'Success'
	and r.customer_ratings >= 4
group by r.vehicle_type
order by high_rated_ride_count desc

-- (b) Vehicles with Most Number of Below Average Ratings
select r.vehicle_type, 
	count(*) as below_avg_rated_ride_count
from ride_details r
join booking_details b using (booking_id)
where b.booking_status = 'Success'
	and r.customer_ratings < (select avg(customer_ratings)
		from ride_details)
group by r.vehicle_type
order by below_avg_rated_ride_count desc

-- (c) Average Customer Ratings by Vehicle Type
select r.vehicle_type,
	round(avg(r.customer_ratings),1) as avg_customer_ratings
from ride_details r
join booking_details b using(booking_id)
where b.booking_status = 'Success'
group by r.vehicle_type
order by avg_customer_ratings desc

-- Revenue from Top Pickup Locations
select pickup_location, sum(price) as total_revenue
from ride_details
group by pickup_location
order by total_revenue desc
limit 5

-- Peak Time Analysis
select 
    concat(
        lpad(extract(hour from time)::text, 2, '0'), 
        ':00 - ', 
        lpad(extract(hour from time)::text, 2, '0'), 
        ':59'
    ) as time_range,
    count(*) as ride_count
from booking_details
group by extract(hour from time)
order by ride_count desc

-- Percentage of Each Booking Status
select booking_status, round((count(booking_status)*1.0
	/(select count(*)from booking_details))*100, 2) as rides_percentage
from booking_details
group by booking_status

-- On Which Date in January, the Most Number of Rides were Booked
-- and What were the Total Successful Bookings and Average Customer Ratings on That Day
with most_booked_date as(
	select b.date, count(*) as total_bookings
	from booking_details b
	join ride_details r using(booking_id)
	group by b.date
),

succesful_bookings as(
	select b.date, count(*) as successful_bookings,
		round(avg(r.customer_ratings),1) as avg_customer_ratings
	from booking_details b
	join ride_details r using(booking_id)
	where b.booking_status = 'Success'
	group by b.date
)

select mbd.date, mbd.total_bookings,
	sb.successful_bookings,
	sb.avg_customer_ratings
from most_booked_date mbd
join succesful_bookings sb using (date)
order by mbd.total_bookings desc
limit 1