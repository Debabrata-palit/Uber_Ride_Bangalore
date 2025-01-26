select * from uber_ride_bangalore

-- Ride Completion Count
select count(*) as completed_rides
from uber_ride_bangalore
where booking_status ='Success'

-- Vehicle-Type Breakdown
select vehicle_type, count(*) as ride_count
from uber_ride_bangalore
group by vehicle_type

-- Top Pickup Locations
select pickup_location, count(*) as ride_count
from uber_ride_bangalore
group by pickup_location
order by ride_count desc
limit 5

-- Top Drop Locations
select drop_location, count(*) as ride_count
from uber_ride_bangalore
group by drop_location
order by ride_count desc
limit 5

-- Average Booking Value by Vehicle Type
select vehicle_type, round(avg(booking_value), 2) as avg_booking_value
from uber_ride_bangalore
group by vehicle_type
order by avg_booking_value desc

-- Payment Method Popularity
select payment_method, count(*) as ride_count
from uber_ride_bangalore
WHERE booking_status = 'Success'
group by payment_method
order by ride_count desc

-- Customer Rating Analysis

-- Vehicles with Most Number of High Ratings (4 or more)
select vehicle_type, 
	count(*) as high_rated_ride_count
from uber_ride_bangalore
where booking_status = 'Success'
	and customer_ratings >= 4
group by vehicle_type
order by high_rated_ride_count desc

-- Vehicles with Most Number of Below Average Ratings
select vehicle_type, 
	count(*) as below_avg_rated_ride_count
from uber_ride_bangalore
where booking_status = 'Success'
	and customer_ratings < (select avg(customer_ratings)
		from uber_ride_bangalore)
group by vehicle_type
order by below_avg_rated_ride_count desc

-- Revenue from Top Pickup Locations
select pickup_location, sum(booking_value) as total_revenue
from uber_ride_bangalore
group by pickup_location
order by total_revenue desc
limit 5

-- Cancelled Rides Count
select count(*) as cancelled_rides
from uber_ride_bangalore
where booking_status not in ('Success', 'Incomplete')

-- Cancellation Reason Breakdown

-- (a) Rides Cancelled by Customer
select cancelled_rides_by_customer_reason, 
	count(*) as customer_cancel_count
from uber_ride_bangalore
where cancelled_rides_by_customer_reason is not null
group by cancelled_rides_by_customer_reason
order by customer_cancel_count desc

-- (b) Rides Cancelled by Customer
select cancelled_rides_by_driver_reason, 
	count(*) as driver_cancel_count
from uber_ride_bangalore
where cancelled_rides_by_driver_reason is not null
group by cancelled_rides_by_driver_reason
order by driver_cancel_count desc

-- Incomplete Rides Count
select count(*) as incomplete_rides
from uber_ride_bangalore
where booking_status = 'Incomplete'

-- Incomplete Ride Reason Breakdown
select incomplete_ride_reason, 
	count(*) as incomplete_ride_count
from uber_ride_bangalore
where incomplete_ride_reason is not null
group by incomplete_ride_reason
order by incomplete_ride_count desc

-- Peak Time Analysis
select 
    concat(
        lpad(extract(hour from time)::text, 2, '0'), 
        ':00 - ', 
        lpad(extract(hour from time)::text, 2, '0'), 
        ':59'
    ) as time_range,
    count(*) as ride_count
from uber_ride_bangalore
group by extract(hour from time)
order by ride_count desc
limit 5

-- Percentage of Each Booking Status
select booking_status, round((count(booking_status)*1.0
	/(select count(*)from uber_ride_bangalore))*100, 2) as rides_percentage
from uber_ride_bangalore
group by booking_status