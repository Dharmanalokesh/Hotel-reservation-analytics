StayPoint Hospitality – Hotel Reservation Analytics SQL

📌 Project Overview

A SQL portfolio project analyzing booking, stay, guest, and staff data for StayPoint, a 25-hotel chain, using MySQL. The project covers database design, data cleaning, and exploratory/business analysis across four sprints, and demonstrates how relational database concepts and SQL queries can answer practical hospitality business questions.

- **Database:** `hotel_reservation_analytics`
- **Tables:** `hotels`, `guests`, `staff`, `rooms`, `bookings`, `stays`
- **Scale:** 25 hotels · 350 guests · 70 staff · 600 rooms · 2,800 bookings · 3,200 stays

🎯 Objectives

Manage hotel and room information in a structured database. Maintain guest profiles and loyalty information. Track staff details and departments. Store booking records across channels. Track stay outcomes such as check-in/check-out, cancellations, and no-shows. Analyze booking demand, guest behaviour, stay performance, and staff/room performance. Generate business-focused insights such as revenue drivers, cancellation risk, and workforce load.

🛠️ Technologies Used

SQL

Relational Database Management System (MySQL)

SQL DDL (CREATE TABLE, ALTER TABLE)

SQL DML (SELECT, UPDATE)

SQL Joins

Aggregate Functions

GROUP BY / HAVING

ORDER BY

CASE

Date Functions (STR_TO_DATE, DATE_FORMAT, YEAR)

Foreign Keys and Constraints

📁 Repository Structure

```
SQL-Project/
│
├── database.sql       -- Schema creation, data-type fixes, verification queries
├── queries.sql         -- Business analysis queries (Sprints 3–4) with findings & insights
├── README.md
└── screenshots/         -- Query results / dashboard screenshots
```

🗂️ Database Structure

The database contains the following six tables, following a parent → child structure to satisfy foreign key dependencies:

```
hotels, guests, staff  →  rooms  →  bookings  →  stays
```

Table | Purpose
--- | ---
hotels | Stores hotel name, city, star rating, and room count
guests | Stores guest personal info, type, and loyalty tier
staff | Stores staff details, department, and active status
rooms | Stores room type, floor, occupancy, and pricing per hotel
bookings | Stores booking transactions made by guests
stays | Stores actual stay records, check-in/out dates, and outcomes

`database.sql` also converts several date columns (`opened_date`, `account_since`, `hire_date`, `booking_date`, `check_in_date`, `check_out_date`) from `VARCHAR` to native `DATE` type using `STR_TO_DATE`, since the source CSVs stored dates as text in mixed formats (`YYYY-MM-DD` and `DD-MM-YYYY`).

🔗 Table Relationships

Main Relationships

rooms.hotel_id → hotels.hotel_id

bookings.guest_id → guests.guest_id

bookings.hotel_id → hotels.hotel_id

stays.booking_id → bookings.booking_id

stays.room_id → rooms.room_id

stays.staff_id → staff.staff_id

📊 Database Tables

hotels
Key columns: hotel_id (PK), hotel_name, city, star_rating, total_rooms, opened_date

guests
Key columns: guest_id (PK), guest_name, city, guest_type (Individual / Corporate), preferred_room_type, loyalty_tier, account_since

staff
Key columns: staff_id (PK), staff_name, hire_date, rating, department, is_active

rooms
Key columns: room_id (PK), hotel_id (FK), room_type, floor_number, max_occupancy, price_per_night, is_active

bookings
Key columns: booking_id (PK), guest_id (FK), hotel_id (FK), booking_date, room_type_requested, booking_channel, nights_booked, total_amount

stays
Key columns: stay_id (PK), booking_id (FK), room_id (FK), staff_id (FK), check_in_date, check_out_date, status (Checked-out / In-progress / Cancelled / No-show), nights_stayed, service_requests, stay_duration_hrs

🔍 Key SQL Analysis (`queries.sql`)

Sprint | Focus
--- | ---
Sprint 3 | Basic data exploration — row counts, distinct room types, booking channels, totals/averages
Sprint 4.1 | Booking demand — bookings by hotel, channel, room type, and over time
Sprint 4.2 | Guest booking behaviour — frequency, spend, Individual vs. Corporate, loyalty tiers
Sprint 4.3 | Stay performance — outcomes by hotel, duration, completed/cancelled/no-show rates over time
Sprint 4.4 | Staff & room performance — workload, ratings vs. lost-stay rate, duration by department
Sprint 4.5 | Booking & stay problems — cancellations/no-shows by channel, hotel, room type, service-request volume

📈 Key Insights

- **Digital channels dominate:** Website and mobile app together drive over 80% of total booking revenue.
- **Individual guests are the bigger revenue driver** overall — not because they spend more per trip, but because there are more than twice as many of them.
- **Loyalty tier doesn't clearly predict spend or frequency** — Platinum members actually book the least, suggesting the loyalty program may not be motivating repeat bookings.
- **~32% of stays never complete** (cancelled or no-show), and this loss rate is growing in step with overall volume rather than shrinking.
- **Staff rating doesn't strongly predict lost-stay rate** — cancellations appear driven more by guest-side or booking-side factors than by staff performance.
- **Chandigarh Residency** stands out as the best-performing hotel on lost-stay rate, a useful benchmark for best practices.

▶️ How to Run

**Step 1: Open a SQL Environment**
Open a MySQL-compatible SQL environment such as MySQL Workbench, the MySQL Command Line, or another compatible SQL client.

**Step 2: Create the Database**
Run `database.sql` first. It creates the database, all six tables with their relationships and constraints, and converts date columns from `VARCHAR` to `DATE`.

**Step 3: Run the Analysis Queries**
Execute `queries.sql` to run the Sprint 3–4 analytical queries against the data.

**Step 4: Explore the Results**
Run the queries individually to examine booking demand, guest behaviour, stay performance, staff/room performance, and booking/stay problems.

🧠 SQL Concepts Demonstrated

CREATE TABLE · ALTER TABLE · SELECT · JOIN · GROUP BY · HAVING · ORDER BY · COUNT() · SUM() · AVG() · ROUND() · CASE · DISTINCT · STR_TO_DATE() · DATE_FORMAT() · YEAR() · LIMIT · Primary Keys · Foreign Keys · CHECK Constraints

💡 Example Business Questions

Which hotels have the highest number of bookings?

Which booking channels bring in the most revenue?

Which room types are requested most often?

Are Individual or Corporate guests more valuable overall?

Does loyalty tier increase booking frequency or spend?

What percentage of stays end up cancelled or as no-shows?

Does staff rating predict lost-stay rate?

Which staff members and rooms carry the heaviest workload?

Which hotels have the highest problem (cancellation/no-show) rate?

⚠️ Notes

This is an academic/demo SQL project using sample hotel reservation data.

The 2026 figures in the dataset are partial (data collected only through mid-2026), so year-over-year comparisons involving 2026 should be read with that in mind.

The staff-rating and lost-rate comparisons in this project are exploratory SQL findings, not validated operational conclusions.

👩‍💻 Author

[SATHISH ADDALA]
SQL / Database Project