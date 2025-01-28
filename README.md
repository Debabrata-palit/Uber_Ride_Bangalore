# Uber Ride Analysis - Bangalore

This project analyzes ride data from **Uber** in **Bangalore**, for **January 2024**, focusing on metrics like ride completion, cancellation reasons, revenue, and ratings. The analysis leverages **PostgreSQL** for database management and querying to provide actionable insights into ride patterns and customer behavior.

![Uber Bengaluru](https://github.com/user-attachments/assets/77998053-4ac7-4cd4-a413-d2d2e13d2fc8)

## Datasets Overview

We have 3 datasets: `booking_details` `ride_details` `unsuccessful_rides`

> **Column Descriptions:**

- **booking_details**

	1. `Date:` _The date of the ride._
	2. `Time:` _The time of the ride._
	3. `Booking ID:` _Unique identifier for each booking._
	4. `Booking Status:` _Status of the ride (e.g., Successful, Cancelled, Incomplete)._

- **ride_details**

	1. `Booking ID:` _Unique identifier for each booking._
 	2. `Vehicle Type:` _Type of vehicle used for the ride._
	3. `Pickup Location:` _Location where the ride started._
	4. `Drop Location:` _Location where the ride ended._
	5. `Avg VTAT (Vehicle Turnaround Time):` _Average time taken by the vehicle to start the ride._
	6. `Avg CTAT (Customer Turnaround Time):` _Average time taken by the customer to board the vehicle._
	7. `Price:` _The monetary value of the booking._
	8. `Payment Method:` _Payment method used (e.g., UPI, Wallet, Cash)._
	9. `Ride Distance:` _Distance covered during the ride._
	10. `Customer Ratings:` _Ratings given by the customer._

- **unsuccessful_rides**
	1. `Booking ID:` _Unique identifier for each booking._
	2. `Booking Status:` _Status of the ride (e.g., Successful, Cancelled, Incomplete)._
  	3. `Cancelled Rides by Customer Reason:` _Reason for cancellation by the customer._
	4. `Cancelled Rides by Driver Reason:` _Reason for cancellation by the driver._
	5. `Incomplete Ride Reason:` _Reason for an incomplete ride._

> **Key Observations:**

- Each dataset contains 200,000 records.
- The datasets include booking details, ride metadata, and reasons for cancellations or incomplete rides.
- Missing data is present in several columns, especially for reasons related to cancellations, payment method and ratings.
  - `Cancelled Rides by Customer Reason`, `Cancelled Rides by Driver Reason`, `Incomplete Ride Reason`: These columns represent specific events (cancellations or incomplete rides). Missing data likely means the ride was completed successfully or cancelled because of other reasons (e.g., if the ride was cancelled by customer then the 'Cancelled Rides by Driver Reason' and 'Incomplete Ride Reason' columns remain blank)
  - `Payment Method`, `Driver Ratings` and `Customer Ratings`: Missing data indicate that the rides were not successful.
- There are 7 unique vehicle types and 51 unique pickup and drop locations.

## Tech Stack

- **Language:** `SQL`
- **Database:** `PostgreSQL`
- **Tools:** `pgAdmin`

## SQL Table Creation Query

```sql
DROP TABLE IF EXISTS booking_details;
DROP TABLE IF EXISTS ride_details;
DROP TABLE IF EXISTS unsuccessful_rides;

CREATE TABLE booking_details (
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Booking_ID VARCHAR(20) PRIMARY KEY,
    Booking_Status VARCHAR(50) NOT NULL
);

CREATE TABLE ride_details (
    Booking_ID VARCHAR(20) PRIMARY KEY,
    Vehicle_Type VARCHAR(20) NOT NULL,
    Pickup_Location VARCHAR(50) NOT NULL,
    Drop_Location VARCHAR(50) NOT NULL,
    Avg_VTAT DECIMAL(10,2) NOT NULL,
    Avg_CTAT DECIMAL(10,2) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Payment_Method VARCHAR(20),
    Ride_Distance DECIMAL(10,2) NOT NULL,
    Customer_Ratings DECIMAL(10,1)
);

CREATE TABLE unsuccessful_rides (
    Booking_ID VARCHAR(20) PRIMARY KEY,
    Booking_Status VARCHAR(50) NOT NULL,
    Cancelled_Rides_By_Customer_Reason VARCHAR(100),
    Cancelled_Rides_By_Driver_Reason VARCHAR(100),
    Incomplete_Ride_Reason VARCHAR(100)
);
```

## Loading Data into PostgreSQL

```sql
COPY booking_details (Date, Time, Booking_ID, Booking_Status)
FROM 'path\to\booking_details.csv' -- Replace with the actual file path
DELIMITER ',' 
CSV HEADER;

COPY ride_details (
	Booking_ID, Vehicle_Type, Pickup_Location, Drop_Location,
	Avg_VTAT, Avg_CTAT, Price, Payment_Method, Ride_Distance,
	Customer_Ratings
)
FROM 'path\to\ride_details.csv' -- Replace with the actual file path
DELIMITER ',' 
CSV HEADER;

COPY unsuccessful_rides (
	Booking_ID, Booking_Status, Cancelled_Rides_By_Customer_Reason,
	Cancelled_Rides_By_Driver_Reason, Incomplete_Ride_Reason
)
FROM 'path\to\unsuccessful_rides.csv' -- Replace with the actual file path
DELIMITER ',' 
CSV HEADER;
```

