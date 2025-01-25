# Uber Ride Analysis - Bangalore

This project analyzes ride data from **Uber** in **Bangalore**, for **January 2024**, focusing on metrics like ride completion, cancellation reasons, revenue, and ratings. The analysis leverages **PostgreSQL** for database management and querying to provide actionable insights into ride patterns and customer behavior.

![image](https://github.com/user-attachments/assets/bb0c99ec-9a45-4d8f-b0e0-ef9a9dd1dee6)

## Dataset

The dataset contains 200,000 records and 18 columns. Here's an overview of the data:

> Column Descriptions:

1. **Date:** The date of the ride (string).
2. **Time:** The time of the ride (string).
3. **Booking ID:** Unique identifier for each booking (string).
4. **Booking Status:** Status of the ride (e.g., Success, Incomplete) (string).
5. **Customer ID:** Unique identifier for the customer (string).
6. **Vehicle Type:** Type of vehicle used for the ride (e.g., Uber Go, Go Sedan, Moto) (string).
7. **Pickup Location:** Location where the ride started (string).
8. **Drop Location:** Location where the ride ended (string).
9. **Avg VTAT (Vehicle Turnaround Time):** Average time taken by the vehicle to start the ride (float).
10. **Avg CTAT (Customer Turnaround Time):** Average time taken by the customer to board the vehicle (float).
11. **Cancelled Rides by Customer Reason:** Reason for cancellation by the customer (string, sparsely populated).
12. **Cancelled Rides by Driver Reason:** Reason for cancellation by the driver (string, sparsely populated).
13. **Incomplete Ride Reason:** Reason for an incomplete ride (string, sparsely populated).
14. **Booking Value:** The monetary value of the booking (float).
15. **Payment Method:** Payment method used (e.g., UPI, Wallet, Cash) (string, partially null).
16. **Ride Distance:** Distance covered during the ride (float).
17. **Driver Ratings:** Ratings given by the driver (float, partially null).
18. **Customer Ratings:** Ratings given by the customer (float, partially null).

