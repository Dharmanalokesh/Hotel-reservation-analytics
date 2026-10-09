
 -- 1. CREATE DATABASE
CREATE DATABASE hotel_reservation_analytics;
USE hotel_reservation_analytics;
-- 2. CREATE TABLES
-- Order matters: parents before children (FK dependencies)
--   hotels, guests, staff  -->  rooms  -->  bookings  -->  stays

-- Independent tables first
-- hotels
CREATE TABLE hotels (
    hotel_id VARCHAR(20) PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    star_rating INT NOT NULL,
    total_rooms INT NOT NULL DEFAULT 0,
    opened_date VARCHAR(20) NOT NULL,
    CONSTRAINT chk_hotels_star_rating CHECK (star_rating BETWEEN 1 AND 5)
);


-- guests    
CREATE TABLE guests (
    guest_id             VARCHAR(20)   PRIMARY KEY,
    guest_name           VARCHAR(150)  NOT NULL,
    city                 VARCHAR(50),
    guest_type           VARCHAR(20)   NOT NULL,   -- Individual / Corporate
    preferred_room_type  VARCHAR(20),
    loyalty_tier         VARCHAR(20)   DEFAULT 'None',
    account_since        varchar(30)          NOT NULL
);
 
 -- staff
CREATE TABLE staff (
    staff_id     VARCHAR(20)    PRIMARY KEY,
    staff_name   VARCHAR(100)   NOT NULL,
    hire_date    varchar(30)           NOT NULL,
    rating       DECIMAL(3,2),
    department   VARCHAR(30)    NOT NULL,
    is_active    VARCHAR(3)     NOT NULL DEFAULT 'Yes'
);
  
 -- rooms
 -- Depends on hotels
CREATE TABLE rooms (
    room_id          VARCHAR(20)    PRIMARY KEY,
    hotel_id         VARCHAR(20)    NOT NULL,
    room_type        VARCHAR(20)    NOT NULL,
    floor_number     INT,
    max_occupancy    INT            NOT NULL,
    price_per_night  DECIMAL(10,2)  NOT NULL,
    is_active        VARCHAR(3)     NOT NULL DEFAULT 'Yes',
	FOREIGN KEY (hotel_id)
	REFERENCES hotels(hotel_id)
);

 -- Depends on guests, hotels
CREATE TABLE bookings (
    booking_id           VARCHAR(20)    PRIMARY KEY,
    guest_id             VARCHAR(20)    NOT NULL,
    hotel_id             VARCHAR(20)    NOT NULL,
    booking_date         varchar(30)    NOT NULL,
    room_type_requested  VARCHAR(20),
    booking_channel      VARCHAR(30),
    nights_booked        INT            NOT NULL,
    total_amount         DECIMAL(12,2)  NOT NULL,
    FOREIGN KEY (guest_id)
	REFERENCES guests(guest_id),
	FOREIGN KEY (hotel_id)
	REFERENCES hotels(hotel_id)
);

-- Depends on bookings, rooms, staff
CREATE TABLE stays (
    stay_id             VARCHAR(20)   PRIMARY KEY,
    booking_id          VARCHAR(20)   NOT NULL,
    room_id             VARCHAR(20)   NOT NULL,
    staff_id            VARCHAR(20)   NOT NULL,
    check_in_date       varchar(20),    
    check_out_date      varchar(20),
    status              VARCHAR(20)   NOT NULL,
    nights_stayed       INT,
    service_requests    INT           DEFAULT 0,
    stay_duration_hrs   INT,
    
	FOREIGN KEY (booking_id)
	REFERENCES bookings(booking_id),
    
	FOREIGN KEY (room_id)
	REFERENCES rooms(room_id),

	FOREIGN KEY (staff_id)
	REFERENCES staff(staff_id)
);

select* from stays;
 
-- Table: hotels
-- Convert the date column from VARCHAR to DATE

-- Step 1: Create a new column to store the date in proper DATE format
ALTER TABLE hotels ADD COLUMN temp_date DATE;

DESC hotels;

-- Step 2: Copy the data from the old column into the new column, converting it
UPDATE hotels 
SET temp_date = STR_TO_DATE(opened_date, '%Y-%m-%d');

-- Step 3: After copying the data, drop the old VARCHAR column
ALTER TABLE hotels DROP COLUMN opened_date;

-- Step 4: Rename the new column to match the old column's name
ALTER TABLE hotels 
RENAME COLUMN temp_date TO opened_date;

/*Reason:

The opened_date column was stored as VARCHAR because the CSV had dates in YYYY-MM-DD format (e.g. 2013-06-29),
but the column type was still text.I used STR_TO_DATE(opened_date, '%Y-%m-%d') to convert it — %Y reads the year,
%m reads the month,and %d reads the day, matching the exact order and format of the source data. */


-- Table: guests
-- Convert the date column from VARCHAR to DATE

-- Step 1: Create a new column to store the date in proper DATE format
ALTER TABLE guests ADD COLUMN temp_date DATE;

DESC guests;

-- Step 2: Copy the data from the old column into the new column, converting it
UPDATE guests
SET temp_date = STR_TO_DATE(account_since, '%d-%m-%Y');

-- Step 3: After copying the data, drop the old VARCHAR column
ALTER TABLE guests DROP COLUMN account_since;

-- Step 4: Rename the new column to match the old column's name
ALTER TABLE guests 
RENAME COLUMN temp_date TO account_since;

/*Reason:

The account_since column was stored as VARCHAR because the CSV had dates in DD-MM-YYYY format (e.g. 05-12-2017),
which MySQL's DATE type can't read directly. I used STR_TO_DATE(account_since, '%d-%m-%Y') to convert it — %d reads the day,
%m reads the month, and %Y reads the year, matching the exact order and format of the source data.

*/

-- Table: staff
-- Convert the date column from VARCHAR to DATE

-- Step 1: Create a new column to store the date in proper DATE format
ALTER TABLE staff ADD COLUMN temp_date DATE AFTER hire_date;

DESC staff;

-- Step 2: Copy the data from the old column into the new column, converting it
UPDATE staff 
SET temp_date = STR_TO_DATE(hire_date, '%Y-%m-%d');

-- Step 3: After copying the data, drop the old VARCHAR column
ALTER TABLE staff DROP COLUMN hire_date;

-- Step 4: Rename the new column to match the old column's name
ALTER TABLE staff 
RENAME COLUMN temp_date TO hire_date;
/*Reason:
The hire_date column was stored as VARCHAR because the CSV had dates in YYYY-MM-DD format (e.g. 2018-04-24), which is MySQL's native date format
but the column type was still text. I used STR_TO_DATE(hire_date, '%Y-%m-%d') to convert it — %Y reads the year, %m reads the month, and %d reads the day,
matching the exact order and format of the source data. */


-- Table Room
/*
Why the rooms table required no conversion:

The rooms table does not contain any column intended to store date values — its structure only includes room_id,
hotel_id, room_type, floor_number, max_occupancy, price_per_night, and is_active. Since the VARCHAR-to-DATE conversion 
applies specifically to columns holding date data, and no such columnexists in this table, there was nothing to convert. 
The existing data types for all columns are already correct for the values they store. */


-- Table: bookings
-- Convert the booking_date column from VARCHAR to DATE
/*Reason:
The booking_date column was stored as VARCHAR because the CSV had dates in DD-MM-YYYY format (e.g. 05-12-2017),
which MySQL's DATE type can't read directly. I used STR_TO_DATE(booking_date,'%d-%m-%Y') to convert it — %d reads the day,
%m reads the month,and %Y reads the year, matching the exact order and format of the source data.
*/
-- Step 1: Create a new column to store the date in proper DATE format
ALTER TABLE bookings ADD COLUMN temp_date DATE AFTER booking_date;

DESC bookings;

-- Step 2: Copy the data from the old column into the new column, converting it
UPDATE bookings 
SET temp_date = STR_TO_DATE(booking_date, '%d-%m-%Y');

-- Step 3: After copying the data, drop the old VARCHAR column
ALTER TABLE bookings DROP COLUMN booking_date;

-- Step 4: Rename the new column to match the old column's name
ALTER TABLE bookings 
RENAME COLUMN temp_date TO booking_date;
--  Table Stays
-- Convert check_in_date and check_out_date columns from VARCHAR to DATE
/*Reason:
Both columns were stored as VARCHAR because the CSV had dates in DD-MM-YYYY format (e.g. 05-12-2017),
which MySQL's DATE type can't read directly. I used STR_TO_DATE(column,'%d-%m-%Y') to convert it — %d reads the day,
%m reads the month, and %Y reads the year, matching the exact order and format of the source data.
*/

-- ===== CHECK_IN_DATE =====

-- Step 1: Create a new column to store the date in proper DATE format
ALTER TABLE stays ADD COLUMN temp_check_in DATE AFTER check_in_date;
DESC stays;

-- Step 2: Copy the data, converting it
UPDATE stays 
SET temp_check_in = STR_TO_DATE(check_in_date, '%Y-%m-%d');

-- Verify no rows failed conversion before dropping the old column
SELECT check_in_date, temp_check_in 
FROM stays 
WHERE temp_check_in IS NULL AND check_in_date IS NOT NULL;

-- Step 3: Drop the old VARCHAR column
ALTER TABLE stays DROP COLUMN check_in_date;

-- Step 4: Rename the new column to match the old column's name
ALTER TABLE stays 
RENAME COLUMN temp_check_in TO check_in_date;

-- ===== CHECK_OUT_DATE =====

-- Step 1: Create a new column to store the date in proper DATE format
ALTER TABLE stays ADD COLUMN temp_check_out DATE AFTER check_out_date;
DESC stays;

-- Step 2: Copy the data, converting it
UPDATE stays 
SET temp_check_out = STR_TO_DATE(check_out_date, '%Y-%m-%d');

-- Verify no rows failed conversion before dropping the old column
SELECT check_out_date, temp_check_out 
FROM stays 
WHERE temp_check_out IS NULL AND check_out_date IS NOT NULL;

-- Step 3: Drop the old VARCHAR column
ALTER TABLE stays DROP COLUMN check_out_date;

-- Step 4: Rename the new column to match the old column's name
ALTER TABLE stays 
RENAME COLUMN temp_check_out TO check_out_date;

-- Final check
DESC stays;

-- 4. VERIFY THE IMPORT
-- Row counts should match: guests=350, hotels=25, rooms=600,
-- bookings=2800, staff=70, stays=3200

select count(*) from hotels;
select count(*) from guests;
select count(*) from staff;
select count(*) from  rooms;
select count(*) from bookings;
select count(*) from stays;


select * from hotels;
select * from guests;
select * from staff;
select * from  rooms;
select * from bookings;
select * from stays;
select * from stays;