# Uber Ride Analysis - Bangalore

This project analyzes ride data from **Uber** in **Bangalore**, for **January 2024**, focusing on metrics like ride completion, cancellation reasons, revenue, and ratings. The analysis leverages **PostgreSQL** for database management and querying to provide actionable insights into ride patterns and customer behavior. Then **PowerBI** is used for visualization and generating reports.

![image](https://github.com/user-attachments/assets/bb0c99ec-9a45-4d8f-b0e0-ef9a9dd1dee6)

## Dataset Overview

The dataset contains 200,000 records and 18 columns. Here's an overview of the data:

> **Column Descriptions:**

1. `Date:` _The date of the ride._
2. `Time:` _The time of the ride._
3. `Booking ID:` _Unique identifier for each booking._
4. `Booking Status:` _Status of the ride (e.g., Successful, Cancelled, Incomplete)._
5. `Customer ID:` _Unique identifier for the customer._
6. `Vehicle Type:` _Type of vehicle used for the ride._
7. `Pickup Location:` _Location where the ride started._
8. `Drop Location:` _Location where the ride ended._
9. `Avg VTAT (Vehicle Turnaround Time):` _Average time taken by the vehicle to start the ride._
10. `Avg CTAT (Customer Turnaround Time):` _Average time taken by the customer to board the vehicle._
11. `Cancelled Rides by Customer Reason:` _Reason for cancellation by the customer._
12. `Cancelled Rides by Driver Reason:` _Reason for cancellation by the driver._
13. `Incomplete Ride Reason:` _Reason for an incomplete ride._
14. `Booking Value:` _The monetary value of the booking._
15. `Payment Method:` _Payment method used (e.g., UPI, Wallet, Cash)._
16. `Ride Distance:` _Distance covered during the ride._
17. `Driver Ratings:` _Ratings given by the driver._
18. `Customer Ratings:` _Ratings given by the customer._

> **Key Observations:**

- The dataset includes ride metadata, payment details, and reasons for cancellations or incomplete rides.
- Missing data is present in several columns, especially for reasons related to cancellations, payment method and ratings.
  - `Cancelled Rides by Customer Reason`, `Cancelled Rides by Driver Reason`, `Incomplete Ride Reason`: These columns represent specific events (cancellations or incomplete rides). Missing data likely means the ride was completed successfully or cancelled because of other reasons (e.g., if the ride was cancelled by customer then the 'Cancelled Rides by Driver Reason' and 'Incomplete Ride Reason' columns remain blank)
  - `Payment Method`, `Driver Ratings` and `Customer Ratings`: Missing data indicate that the rides were not successful.

## Tech Stack

- **Language:** `SQL`
- **Database:** `PostgreSQL`
- **Tools:** `pgAdmin`, `PowerBI`

## SQL Table Creation Query

```sql
CREATE TABLE uber_ride_bangalore (
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Booking_ID VARCHAR(20) PRIMARY KEY,
    Booking_Status VARCHAR(20) NOT NULL,
    Customer_ID VARCHAR(20) NOT NULL,
    Vehicle_Type VARCHAR(20) NOT NULL,
    Pickup_Location VARCHAR(50) NOT NULL,
    Drop_Location VARCHAR(50) NOT NULL,
    Avg_VTAT FLOAT NOT NULL,
    Avg_CTAT FLOAT NOT NULL,
    Cancelled_Rides_By_Customer_Reason VARCHAR(100),
    Cancelled_Rides_By_Driver_Reason VARCHAR(100),
    Incomplete_Ride_Reason VARCHAR(100),
    Booking_Value FLOAT NOT NULL,
    Payment_Method VARCHAR(20),
    Ride_Distance FLOAT NOT NULL,
    Driver_Ratings FLOAT,
    Customer_Ratings FLOAT
);
```

## Loading Data into PostgreSQL

```sql
COPY uber_ride_bangalore (
    Date, Time, Booking_ID, Booking_Status, Customer_ID, Vehicle_Type, Pickup_Location, Drop_Location, Avg_VTAT, Avg_CTAT,
    Cancelled_Rides_By_Customer_Reason, Cancelled_Rides_By_Driver_Reason, Incomplete_Ride_Reason, Booking_Value, Payment_Method,
    Ride_Distance, Driver_Ratings, Customer_Ratings
)
FROM '/path/to/uber_ride_bangalore.csv' -- Replace with the actual file path
DELIMITER ',' 
CSV HEADER;
```

