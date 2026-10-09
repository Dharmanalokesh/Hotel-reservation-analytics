-- =====================================================================
-- StayPoint Hospitality — Sprint 3 & Sprint 4 Analysis Queries
-- =====================================================================
USE hotel_reservation_analytics;

-- =====================================================================
-- SPRINT 3: BASIC DATA EXPLORATION
-- =====================================================================

--  1. What is the total number of guests?
SELECT COUNT(*) AS total_guests FROM guests;
-- total 350 guests

-- 2. What is the total number of bookings?
SELECT COUNT(*) AS total_bookings FROM bookings;
-- total number of bookings 2800
-- 3.What is the total number of stays?
SELECT COUNT(*) AS total_stays FROM stays;
-- total number of stays 3200

-- 4. What are the different room types available?
SELECT DISTINCT room_type FROM rooms;
-- room types:standard,deluxe,executive,suite.
-- total 4 types
-- 5. How many staff members are currently active?
SELECT COUNT(*) AS active_staff FROM staff WHERE is_active = 'Yes';
-- total 63 members currently active
-- 6. What are the different booking channels?
SELECT DISTINCT booking_channel FROM bookings;
-- different booking channels 
-- 1.website,2.walkin,3.travel agent,4.mobile app,5.phone

-- 7. What is the total booking amount across all bookings?
SELECT SUM(total_amount) AS total_booking_amount FROM bookings;
-- total booking amount across all bookings :45823178.73
-- 8. What is the average nights booked per booking?
SELECT AVG(nights_booked) AS avg_nights_booked FROM bookings;
-- average night booked per bookings
-- =====================================================================
-- SPRINT 4.1: UNDERSTAND BOOKING DEMAND
-- =====================================================================

-- Q1: Compare the number of bookings across hotels
SELECT h.hotel_name, h.city, COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN hotels  h  ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name, h.city
ORDER BY total_bookings DESC;
/* Out of 25 hotels, 23 hotels have more than 100 bookings. The highest bookings are recorded 
by StayPoint Kolkata Residency in Kolkata with 129 bookings and StayPoint Mumbai Suites in Mumbai 
with 128 bookings. Both hotels have similar and the highest number of bookings.The lowest bookings are 
recorded by StayPoint Kochi Heights in Kochi and StayPoint Indore Retreat in Indore, with 98 bookings each.*/
 
 
-- 2.Compare bookings across different booking channels.
SELECT booking_channel, COUNT(*) AS total_bookingsn
FROM bookings
GROUP BY booking_channel
ORDER BY total_bookings DESC;
/*Insight: Most bookings come through the website (984) and mobile app (875).
 To increase bookings, improve the website and mobile app experience by making the UI/UX more attractive,
 user-friendly,and engaging, with a focus on these two high-performing channels.*/

-- Q3: Compare bookings based on room type requested.
SELECT room_type_requested, COUNT(*) AS times_requested
FROM bookings
GROUP BY room_type_requested
ORDER BY times_requested DESC;
/*Many people are booking rooms in both the Standard (1,259) and Deluxe (841) categories. */

-- Q4:Examine how booking volume changes over time.
SELECT DATE_FORMAT(booking_date, '%Y-%m') AS booking_month, COUNT(*) AS total_bookings
FROM bookings
GROUP BY booking_month
ORDER BY booking_month;
/*Compared with 2025, bookings increased significantly in 2026. In 2026,bookings started at a higher level, 
with the highest number of bookings reaching 133 in May. Overall,
the data shows a positive year-on-year growth in bookings.*/

-- Q5:Look at the booking amount across different groups.
SELECT h.hotel_id,h.hotel_name,h.city, ROUND(AVG(b.total_amount), 2) AS avg_booking_amount
FROM bookings b
JOIN hotels h
ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY avg_booking_amount DESC;


select * from bookings;
select booking_channel,sum(total_amount) as each_group
from bookings
group by booking_channel
order by each_group desc;


/*Insight:

Website (₹1.53 crore) and Mobile App (₹1.52 crore) together bring in over 80% of total booking revenue,
far ahead of Travel Agent, Walk-in, and Phone combined. This means StayPoint's digital channels aren't 
just the most used — they're also the biggest revenue drivers,so keeping these platforms fast, reliable,
and easy to book through should be a top priority.*/


-- =====================================================================
-- SPRINT 4.2: UNDERSTAND GUEST BOOKING BEHAVIOUR
-- =====================================================================

-- Q1: Compare guests based on the number of bookings they make.
SELECT g.guest_id, g.guest_name, g.guest_type, COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.guest_id, g.guest_name, g.guest_type
ORDER BY total_bookings DESC;

/*Finding: There's a steep drop-off pattern — the top guest (Gwendolyn Klein, Corporate,
64 bookings) has over 8x the bookings of the guest ranked around #10 (32 bookings). Most 
of the 350 guests cluster in the 1-10 booking range, while only about 25-30 guests have booked 15+ times.

Insight: This is a classic 80/20 pattern, where a small group of frequent bookers likely drives a disproportionate
share of total volume. Interestingly, the top 5 heaviest bookers include both Corporate and Individual guests,
showing that highbooking frequency isn't limited to one guest type — some Individual travelers book nearly as
often as Corporate accounts.*/

-- Q2: Identify guests with a higher total booking amount
SELECT g.guest_id, g.guest_name, g.guest_type, SUM(b.total_amount) AS total_spent
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.guest_id, g.guest_name, g.guest_type
ORDER BY total_spent DESC
limit 10;
/*this matter  give simple english and 3 3 lines of both

Finding:
Gwendolyn Klein (Corporate) spent the most overall, at ₹11.96 lakh, well ahead of everyone else. 
Six of the top 10 highest spenders are actually Individual guests,not Corporate. Guests like Michael 
Hoffman and Joseph Hall spent almost as much as, or more than, several Corporate guests.

Insight:
This shows that high-spending guests are not only Corporate accounts. Many Individual guests spend just as much or
even more than some Corporate guests. So StayPoint should not assume Corporate guests are always the most valuable ones.  */
-- Q3:Compare guest activity across hotels.
SELECT g.guest_type,
       COUNT(b.booking_id) AS total_bookings,
       ROUND(AVG(b.total_amount), 2) AS avg_booking_amount,
       ROUND(AVG(b.nights_booked), 2) AS avg_nights_booked
FROM bookings b
JOIN guests g 
ON b.guest_id = g.guest_id
GROUP BY g.guest_type;


/*Finding:
Individual guests made 1,903 bookings, more than double Corporate's 897 bookings. The average booking amount is nearly the same for both — ₹16,497 for
Individual and ₹16,086 for Corporate. Average nights booked is also almost identical, around 3.3 nights for both types.

Insight:
Individual guests generate much higher booking volume than Corporate guests. But on a per-booking basis, both guest types spend and
stay almost the same amount. So Corporate's lower total bookings isn't because they spend less per trip — they simply book less often.*/

-- Q4: Which hotels attract the most guest activity (unique guests)?
SELECT h.hotel_name, COUNT(DISTINCT b.guest_id) AS unique_guests
FROM bookings b
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY unique_guests DESC;
/*Finding:
StayPoint Goa Grand attracts the most unique guests (99), followed closely by Kochi Retreat and Pune Plaza (94 each). 
Kochi Gardens and Ahmedabad Plaza have the fewest unique guests, at 75 each. The gap between the highest and lowest hotel is only 24 guests,
so the spread is fairly narrow.

Insight:
Guest reach is fairly balanced across all 25 hotels, with no property dramatically outperforming or underperforming others. Goa Grand stands out slightly,
possibly due to its leisure/holiday destination appeal compared to business-city hotels. Overall, guest attraction doesn't appear concentrated in just a 
few locations — it's a fairly even spread across the whole chain.*/

-- Q4: Look at differences between Individual and Corporate guests
SELECT g.guest_type,
       COUNT(DISTINCT g.guest_id) AS total_guests,
       COUNT(b.booking_id) AS total_bookings,
       SUM(b.total_amount) AS total_revenue,
       ROUND(AVG(b.total_amount), 2) AS avg_booking_amount,
       ROUND(COUNT(b.booking_id) * 1.0 / COUNT(DISTINCT g.guest_id), 2) AS avg_bookings_per_guest
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.guest_type;

/*Finding:
There are 233 Individual guests and 106 Corporate guests. Corporate guests average 8.46 bookings each, slightly higher than Individual 
guests at 8.17 bookings each. Individual guests bring in far more total revenue (₹3.14 crore) than Corporate guests (₹1.44 crore).

Insight:
Even though Corporate guests book slightly more often per person, there are more than twice as many Individual guests overall, so their combined
revenue is much higher. Average spend per booking is nearly the same for both types. This shows Individual guests are the bigger revenue driver 
for StayPoint simply due to their larger numbers, not because they spend more per trip.*/


-- Q5: Examine guest booking patterns over time.
SELECT YEAR(b.booking_date) AS booking_year, COUNT(*) AS total_bookings, COUNT(DISTINCT b.guest_id) AS unique_guests
FROM bookings b
GROUP BY booking_year
ORDER BY booking_year;


/*Finding (3 lines):
Bookings grew from 885 in 2024 to 1,048 in 2025, along with more unique guests (243 to 282). 
In 2026, bookings dropped to 867 with 261 unique guests, lower than 2025.

Insight (3 lines):
2025 was the strongest year for both bookings and guest reach. The 2026 numbers are not a real decline — they're likely partial, 
since the data only goes up to August 2026 (not a full year). So this drop shouldn't be read as a downturn without checking if 2026 data collection is still incomplete*/

-- extra question
-- Q6: Does loyalty tier relate to booking activity?
SELECT g.loyalty_tier, COUNT(b.booking_id) AS total_bookings, ROUND(AVG(b.total_amount), 2) AS avg_spend
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.loyalty_tier
ORDER BY total_bookings DESC;

/*Finding:
Guests with no loyalty tier ("None") made the most bookings (1,191), more than Gold, Silver, and Platinum combined categories individually.
Gold tier guests have the highest average spend (₹16,865), while Platinum has the lowest (₹15,632). Booking counts drop as tier 
level rises — Platinum has the fewest bookings (309).

Insight:
Loyalty tier doesn't clearly increase booking activity or spend — in fact, Platinum members book the least and spend slightly less
per booking than lower tiers. This suggests the loyalty program isn't strongly driving repeat bookings or higher spending.
StayPoint may want to review whether the loyalty program's benefits are actually motivating guests to book more.  */


-- =====================================================================
-- SPRINT 4.3: EVALUATE STAY PERFORMANCE
-- =====================================================================
-- 1.Compare stay outcomes across different hotels (hotel information is on the bookings table,
-- so you will need to connect bookings and stays).
SELECT h.hotel_id,h.hotel_name,s.status,COUNT(*) AS total_stays
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id,h.hotel_name, s.status
ORDER BY h.hotel_id,total_stays DESC;
-- joining two tables 
SELECT b.hotel_id,s.status,COUNT(*) AS total_stays 
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY b.hotel_id,s.status
ORDER BY b.hotel_id,total_stays DESC;

/*Finding: 
Checked-out is the top status at every hotel, ranging from 70 (Indore Retreat) to 98 (Mumbai Suites).
 No-show and Cancelled counts stay fairly close across most hotels, generally between 10-30 each.

Insight:
 Mumbai Suites has the highest No-show count (31), and Indore Plaza has the highest Cancelled count (26) — these 
 two are worth flagging. Chandigarh Residency stands out with the lowest combined losses (22), making it the best-performing hotel in this comparison. */


-- 2.Examine stay duration.
SELECT status,
       ROUND(AVG(nights_stayed), 2) AS avg_nights_stayed,
       ROUND(AVG(stay_duration_hrs), 2) AS avg_duration_hrs
FROM stays
GROUP BY status;
/*Finding:
 Checked-out stays average 3.29 nights and 81.03 hours. In-progress stays average 2.34 nights and 57.67 hours so far.
 No-show and Cancelled both show 0 nights and 0 hours.

Insight: 
The zeros for No-show and Cancelled are expected, since the guest never actually stayed — there's no real duration to record for those.
 Duration metrics are only meaningful for Checked-out and In-progress stays, and should be excluded when calculating 
 any overall average duration figure, or they'd wrongly drag the number down.*/

-- 3.Compare stay outcomes by status (Checked-out, No-show, Cancelled, 
-- In-progress) — these are not a simple success/failure split, so consider what each status actually represents.
SELECT
    ROUND(SUM(CASE WHEN status = 'Checked-out' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS completed_pct,
    ROUND(SUM(CASE WHEN status = 'In-progress' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS in_progress_pct,
    ROUND(SUM(CASE WHEN status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS lost_pct
FROM stays;

/*Finding: 
66.16% of stays are completed (Checked-out), 1.91% are still in progress, and 31.94% are lost (Cancelled or No-show).

Insight: Nearly one in three bookings never results in a completed stay. Since In-progress is such a small share,
it's not distorting this number — meaning the 31.94% lost rate is a genuine,
meaningful signal that Operations should treat as a real problem, not just noise.
*/

-- 4.Identify hotels with higher booking activity or poorer outcomes.
SELECT h.hotel_name,
       COUNT(*) AS total_stays,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS lost_stays,
       ROUND(SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS lost_rate_pct
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_name
ORDER BY total_stays DESC;

/*Finding:
 Mumbai Residency has the highest stay volume (256) with a moderate lost rate (32.81%). Kochi Palace has the very lost rate overall (39.20%), 
despite only moderate volume. Chandigarh Residency has by far the best lost rate (19.82%), well below the rest of the chain.

Insight:
 High booking volume doesn't automatically mean high or low problems — some lower-volume hotels (Kochi Palace, Indore Plaza) actually perform
 worse than high-volume ones like Mumbai Residency. Chandigarh Residency stands out as a strong outlier worth studying for best practices to reduce cancellations/no-shows elsewhere.

*/

-- 5. Compare stay performance over time
SELECT DATE_FORMAT(s.check_in_date, '%Y-%m') AS check_in_month,
       s.status,
       COUNT(*) AS total_stays
FROM stays s
GROUP BY check_in_month, s.status
ORDER BY check_in_month;

/* Finding:
 Checked-out volume grew steadily, from around 34-56 per month in early 2024 to consistently 74-96 per month by 2026 — roughly double. However, No-show and Cancelled counts
 also grew alongside it, with No-show peaking at 36 (May 2026) and Cancelled peaking at 29 (July 2026), both well above their 2024 levels.

Insight: 
Business growth (more completed stays) is a positive trend, but cancellations and no-shows are growing right along with it rather than shrinking as a share of the business. 
This means the underlying cause of lost stays hasn't been fixed — it's simply scaling up with overall volume, so it needs direct operational attention rather than being expected to improve on its own with growth.
*/
-- =====================================================================
-- SPRINT 4.4: UNDERSTAND STAFF AND ROOM PERFORMANCE
-- =====================================================================

-- 1.Compare the number of stays handled by staff members.
SELECT st.staff_id, st.staff_name, st.department, COUNT(s.stay_id) AS stays_handled
FROM stays s
JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.staff_id, st.staff_name, st.department
ORDER BY stays_handled DESC;
/*Finding: Anthony Humphrey (Housekeeping) handled the most stays overall (59),
followed closely by Jeffrey Chavez and Philip Cannon (both Front Desk, 57 each).
Most staff cluster between 40-55 stays handled, with Margaret Hawkins DDS (Housekeeping) at the low end with just 30.

Insight: 
Workload appears fairly evenly distributed across the 70 staff members — no single person is handling a dramatically
disproportionate number of stays compared to others. The gap between the busiest (59) and least busy (30) staff member
is notable but not extreme,suggesting reasonably balanced staffing rather than a few overworked employees carrying most of the load.
*/


-- 2.Compare staff performance across stay outcomes.

SELECT st.staff_id, st.staff_name, st.rating,COUNT(s.stay_id) AS total_stays,
SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS lost_stays,
ROUND(SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) * 100.0 / COUNT(s.stay_id), 2) AS lost_rate_pct
FROM stays s
JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.staff_id, st.staff_name, st.rating
ORDER BY st.rating DESC;

/*Finding: The highest-rated staff member, Connie Lawrence (4.94), has a relatively low lost rate (23.26%), while the lowest-rated,
Joshua Blair (3.15), actually has a fairly average lost rate (26.79%) — not the worst. The single worst lost rate belongs to Ryan Munoz
 55.00%), who has a mid-range rating of 3.71, not the lowest.

Insight: There's no strong, consistent relationship between staff rating and lost-stay rate — some low-rated staff have average or even good lost rates, 
while some mid-rated staff (like Ryan Munoz) have the worst outcomes in the whole dataset. This suggests that cancellations/no-shows are likely driven more
by guest-side factors (booking channel, room type, hotel) than by which staff member handled the stay, since staff quality doesn't clearly predict this outcome.
*/


-- 3.Examine stay duration across staff members.

-- department
SELECT st.department,
       ROUND(AVG(s.stay_duration_hrs), 2) AS avg_duration_hrs,
       ROUND(AVG(s.service_requests), 2) AS avg_service_requests
FROM stays s
JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.department
ORDER BY avg_service_requests DESC;


-- including staff id staff name
SELECT st.staff_id, st.staff_name, st.department,
       ROUND(AVG(s.nights_stayed), 2) AS avg_nights_stayed,
       ROUND(AVG(s.stay_duration_hrs), 2) AS avg_duration_hrs
FROM stays s
JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.staff_id, st.staff_name, st.department
ORDER BY avg_duration_hrs DESC;

/*Finding: Holly Wood (Housekeeping) handles stays with the longest average duration (3.17 nights, 77.85 hrs). Danny Morgan (Guest Services) handles the shortest 
(1.46 nights, 36.27 hrs) — more than double the gap between the two. Front Desk staff appear frequently at the higher end of the list, while Guest Services staff 
appear more often toward the lower end.

Insight: There's a wide spread in average stay duration by staff member — over 2x difference between the highest and lowest. This could reflect which hotels
 or room types different staff are typically assigned to, rather than staff performance itself, since duration is more likely tied to the guest's booking than 
to who served them. Worth noting this isn't necessarily a "problem" — it's more useful as context for the earlier finding that staff rating doesn't clearly predict lost-stay rate either.
*/

-- 4.Compare room usage across different room types.
SELECT r.room_type, COUNT(s.stay_id) AS total_stays,
       ROUND(AVG(s.nights_stayed), 2) AS avg_nights_stayed
FROM stays s
JOIN rooms r ON s.room_id = r.room_id
GROUP BY r.room_type
ORDER BY total_stays DESC;




-- 5.Look at stay performance across different rooms.
SELECT r.room_type, st.status, COUNT(*) AS outcome_count
FROM rooms r
JOIN stays st ON r.room_id = st.room_id
GROUP BY r.room_type, st.status
ORDER BY r.room_type, outcome_count DESC;

-- Q6: Do larger rooms (higher max_occupancy) get more service requests?
SELECT r.max_occupancy,
       COUNT(s.stay_id) AS total_stays,
       ROUND(AVG(s.service_requests), 2) AS avg_service_requests
FROM stays s
JOIN rooms r ON s.room_id = r.room_id
GROUP BY r.max_occupancy
ORDER BY r.max_occupancy ;


-- Q7: Is there a difference in stay performance (cancellations) between active vs inactive staff?
SELECT st.is_active, COUNT(s.stay_id) AS total_stays,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays
FROM stays s
JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.is_active;
select * from staff;
-- =====================================================================
-- SPRINT 4.5: IDENTIFY BOOKING AND STAY PROBLEMS
-- =====================================================================
-- 1.Examine which bookings resulted in cancellations or no-shows.

SELECT b.booking_id, g.guest_name, b.booking_channel, st.status
FROM bookings b
JOIN stays st ON b.booking_id = st.booking_id
JOIN guests g ON b.guest_id = g.guest_id
WHERE st.status IN ('Cancelled','No-show');
-- count of each channel
SELECT b.booking_channel, COUNT(*) AS problem_count
FROM bookings b
JOIN stays st ON b.booking_id = st.booking_id
WHERE st.status IN ('Cancelled','No-show')
GROUP BY b.booking_channel
ORDER BY problem_count DESC;

-- 2. Identify common stay statuses and problem patterns
SELECT status, COUNT(*) AS total
FROM stays
WHERE status IN ('Cancelled','No-show')
GROUP BY status;

SELECT st.status, COUNT(*) AS total_count
FROM stays st
GROUP BY st.status
ORDER BY total_count DESC;

-- 3. Compare stay performance for bookings with high service request counts
SELECT
    CASE
        WHEN service_requests = 0 THEN '0 requests'
        WHEN service_requests BETWEEN 1 AND 2 THEN '1-2 requests'
        ELSE '3+ requests'
    END AS request_bucket,
    COUNT(*) AS total_stays,
    SUM(CASE WHEN status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays
FROM stays
GROUP BY request_bucket;


SELECT st.status, COUNT(*) AS total_stays
FROM stays st
WHERE st.service_requests > 3   -- threshold for "high" requests
GROUP BY st.status
ORDER BY total_stays DESC;

-- 4. Examine whether certain hotels experience more booking problems
SELECT h.hotel_name,
       COUNT(*) AS total_stays,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays,
       ROUND(SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS problem_rate_pct
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_name
HAVING problem_stays > 0
ORDER BY problem_rate_pct DESC;

-- 5. (Overall) Do certain booking channels contribute more to these problems?
SELECT b.booking_channel,
       COUNT(*) AS total_stays,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays,
       ROUND(SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS problem_rate_pct
FROM stays s
JOIN bookings b ON s.booking_id = b.booking_id
GROUP BY b.booking_channel
ORDER BY problem_rate_pct DESC;

-- Q6: Do specific room types see more cancellations?
SELECT r.room_type,
       COUNT(*) AS total_stays,
       SUM(CASE WHEN s.status IN ('Cancelled','No-show') THEN 1 ELSE 0 END) AS problem_stays
FROM stays s
JOIN rooms r ON s.room_id = r.room_id
GROUP BY r.room_type
ORDER BY problem_stays DESC;





