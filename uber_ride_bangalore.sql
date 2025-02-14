SELECT * FROM booking_details  
SELECT * FROM ride_details  
SELECT * FROM unsuccessful_rides  

-- Count and Percentage of Each Booking Status (Successful, Cancelled, Incomplete)  

SELECT booking_status,  
	COUNT(booking_status) AS ride_count,  
	ROUND((COUNT(booking_status) * 1.0  
	/(SELECT COUNT(*) FROM booking_details)) * 100, 2) AS rides_percentage  
FROM booking_details  
WHERE booking_status IN ('Success', 'Incomplete')  
GROUP BY booking_status  
UNION  
SELECT 'Cancelled' AS booking_status,  
	 COUNT(booking_status) AS ride_count,  
	 ROUND((COUNT(booking_status) * 1.0  
	 /(SELECT COUNT(*) FROM booking_details)) * 100, 2) AS rides_percentage  
FROM booking_details  
WHERE booking_status LIKE ('Cancelled%')  

-- Cancellation Reason Breakdown  

-- (a) Rides Cancelled by Customer  

SELECT cancelled_rides_by_customer_reason,  
 	COUNT(*) AS customer_cancel_count  
FROM unsuccessful_rides  
WHERE cancelled_rides_by_customer_reason IS NOT NULL  
GROUP BY cancelled_rides_by_customer_reason  
ORDER BY customer_cancel_count DESC  

-- (b) Rides Cancelled by Driver  

SELECT cancelled_rides_by_driver_reason,  
 	COUNT(*) AS driver_cancel_count  
FROM unsuccessful_rides  
WHERE cancelled_rides_by_driver_reason IS NOT NULL  
GROUP BY cancelled_rides_by_driver_reason  
ORDER BY driver_cancel_count DESC  

-- Incomplete Ride Reason Breakdown  

SELECT incomplete_ride_reason,  
 	COUNT(*) AS incomplete_ride_count  
FROM unsuccessful_rides  
WHERE incomplete_ride_reason IS NOT NULL  
GROUP BY incomplete_ride_reason  
ORDER BY incomplete_ride_count DESC  

-- Vehicle-Type Breakdown  

SELECT vehicle_type, COUNT(*) AS ride_count  
FROM ride_details  
GROUP BY vehicle_type  

-- Avg VTAT and Avg CTAT for Each Vehicle  

SELECT vehicle_type, ROUND(AVG(avg_vtat), 2) AS avg_vtat,  
 	ROUND(AVG(avg_ctat), 2) AS avg_ctat  
FROM ride_details  
GROUP BY vehicle_type  

-- Top Pickup Locations  

SELECT pickup_location, COUNT(*) AS ride_count  
FROM ride_details  
GROUP BY pickup_location  
ORDER BY ride_count DESC  
LIMIT 5  

-- Top Drop Locations  

SELECT drop_location, COUNT(*) AS ride_count  
FROM ride_details  
GROUP BY drop_location  
ORDER BY ride_count DESC  
LIMIT 5  

-- Average Booking Value by Vehicle Type  

SELECT vehicle_type, ROUND(AVG(price), 2) AS avg_booking_value  
FROM ride_details  
GROUP BY vehicle_type  
ORDER BY avg_booking_value DESC  

-- Payment Method Popularity  

SELECT r.payment_method, COUNT(*) AS ride_count  
FROM ride_details r  
JOIN booking_details b USING (booking_id)  
WHERE b.booking_status = 'Success'  
GROUP BY r.payment_method  
ORDER BY ride_count DESC  

-- Customer Rating Analysis  

-- (a) Vehicles with Most Number of High Ratings (4 or more)  

SELECT r.vehicle_type,  
 	COUNT(*) AS high_rated_ride_count  
FROM ride_details r  
JOIN booking_details b USING (booking_id)  
WHERE b.booking_status = 'Success'  
 	AND r.customer_ratings >= 4  
GROUP BY r.vehicle_type  
ORDER BY high_rated_ride_count DESC  

-- (b) Vehicles with Most Number of Below Average Ratings  

SELECT r.vehicle_type,  
 	COUNT(*) AS below_avg_rated_ride_count  
FROM ride_details r  
JOIN booking_details b USING (booking_id)  
WHERE b.booking_status = 'Success'  
 	AND r.customer_ratings < (SELECT AVG(customer_ratings)  
  	FROM ride_details)  
GROUP BY r.vehicle_type  
ORDER BY below_avg_rated_ride_count DESC  

-- (c) Average Customer Ratings by Vehicle Type  

SELECT r.vehicle_type,  
 	ROUND(AVG(r.customer_ratings), 1) AS avg_customer_ratings  
FROM ride_details r  
JOIN booking_details b USING (booking_id)  
WHERE b.booking_status = 'Success'  
GROUP BY r.vehicle_type  
ORDER BY avg_customer_ratings DESC  

-- (d) Date with Most Number of High Ratings (4 or more)  

SELECT b.date, COUNT(*) AS high_rated_ride_count  
FROM booking_details b  
JOIN ride_details r USING (booking_id)  
WHERE b.booking_status = 'Success'  
  	AND r.customer_ratings >= 4  
GROUP BY b.date  
ORDER BY high_rated_ride_count DESC  
LIMIT 1

-- Revenue from Top Pickup Locations  

SELECT pickup_location, SUM(price) AS total_revenue  
FROM ride_details  
GROUP BY pickup_location  
ORDER BY total_revenue DESC  
LIMIT 5  

-- Average Revenue Gained from Each Vehicle-Type  

SELECT vehicle_type, ROUND(AVG(price), 2) AS avg_revenue  
FROM ride_details  
GROUP BY vehicle_type  
ORDER BY avg_revenue DESC  

-- Hourly Ride Analysis  

SELECT  
 CONCAT(  
    LPAD(EXTRACT(HOUR FROM time)::TEXT, 2, '0'),  
    ':00 - ',  
    LPAD(EXTRACT(HOUR FROM time)::TEXT, 2, '0'),  
    ':59'  
 ) AS time_range,  
 COUNT(*) AS ride_count  
FROM booking_details  
GROUP BY EXTRACT(HOUR FROM time)
ORDER BY time_range

-- On Which Date in January, the Most Number of Rides were Booked  

-- and What were the Total Successful Bookings and Average Customer Ratings on That Day  

WITH most_booked_date AS (  
	 SELECT b.date, COUNT(*) AS total_bookings  
	 FROM booking_details b  
	 JOIN ride_details r USING (booking_id)  
	 GROUP BY b.date  
),  

succesful_bookings AS (  
	 SELECT b.date, COUNT(*) AS successful_bookings,  
	  ROUND(AVG(r.customer_ratings), 1) AS avg_customer_ratings  
	 FROM booking_details b  
	 JOIN ride_details r USING (booking_id)  
	 WHERE b.booking_status = 'Success'  
	 GROUP BY b.date  
)  

SELECT mbd.date, mbd.total_bookings,  
	 sb.successful_bookings,  
	 sb.avg_customer_ratings  
FROM most_booked_date mbd  
JOIN succesful_bookings sb USING (date)  
ORDER BY mbd.total_bookings DESC  
LIMIT 1
