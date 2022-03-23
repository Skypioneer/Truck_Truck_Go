-- Group 5 Milestone 2 SQL Query Script
-- Project: Truck Truck Go
-- Authors: Bob Brown, Evan Marshall, Clinton Paulus, Jason Wang
-- Date:    10/25/2020

-- 1) A query for finding foods that are less than 20% fat.
-- This can be a “healthy” search option for customers.

SELECT food_name AS Food, nutr_fat_g AS Fat
FROM food f JOIN nutrition n ON f.nutr_id = n.nutr_id
WHERE nutr_fat_g < (nutr_fat_g + nutr_protein_g + nutr_carbohydrates_g) * .2
ORDER BY Fat;

-- 2) Similar to the last query but for low sugar beverages.
-- This query will quench your thirst without the carbs.

SELECT bev_name AS BeverageName, nutr_calories AS Calories
FROM beverage b JOIN nutrition n on b.nutr_id = n.nutr_id
WHERE nutr_calories < 200
ORDER by Calories;

-- 3) A query for finding trucks rated at least 3.
-- This will allow customer to filter by the top rated trucks for lunch
-- if they have to impress someone!

SELECT vend_name as Vendor , AVG(rating_rating) as Rating
FROM vendor v JOIN orders o ON v.vend_id = o.vend_id
JOIN rating r ON r.rating_id = o.rating_id
GROUP BY v.vend_id
HAVING Rating >= 3
ORDER BY Rating desc;

-- 4) This query finds customers with more than 2 ratings. It is for developers
-- to see who the most active users on the platform are.

SELECT contact_fName as First, contact_lName as Last, count(rating_id) as NumberOfRatings
FROM contact_information ci JOIN customer c ON ci.contact_id = c.contact_id
JOIN rating r on c.cust_id = r.cust_id
GROUP BY c.cust_id
HAVING NumberOfRatings > 2
ORDER BY NumberOfRatings desc;

-- 5) This query shows the food trucks open RIGHT NOW! For when you are hungry
-- RIGHT NOW. Will return different trucks depending on when you run the query.

SELECT vend_name as Vendor
FROM vendor v JOIN schedule s on v.vend_id = s.vend_id
JOIN week w on w.week_id = s.week_id
JOIN time t on t.time_id = s.time_id
WHERE w.week_day = DAYNAME(CURDATE())
AND t.time_openTime < TIME(CURTIME())
AND t.time_closeTime > TIME(CURTIME());

-- 6) Sorts the trucks by how expensive they are. You can use this when you
-- are trying to impress a date with a fancy meal or trying to save some cash.

SELECT v.vend_name as Vendor, AVG(f.food_menu_price) AS AvgPrice
FROM food_menu f JOIN vendor v USING (vend_id)
GROUP BY vend_id
ORDER BY AvgPrice ASC;

-- 7) Do you feel like you have been eating at the same places again and
-- again? This query shows you the newest trucks, and limits the trucks shown
-- to only those added to the database in the last year.

SELECT vend_name as Vendor, contact_enrollDate as Enrolled
FROM vendor v JOIN contact_information ci ON v.contact_id = ci.contact_id
WHERE contact_enrollDate  > CURDATE() - 365
ORDER BY Enrolled;

-- 8) Where are all these food trucks? This query shows you how many food
-- trucks the platform has in each city. This could be use by sales staff to
-- decide which cities to target for more trucks!

SELECT loc_city as City, count(vend_id) as NumberOfTrucks
FROM location l JOIN schedule s on l.loc_id = s.loc_id
GROUP BY City
ORDER BY NumberOfTrucks desc;

-- 9) You need to know what food is at the food truck! This query shows you
-- the food menu for a given truck.

SELECT food_name AS FoodName, nutr_calories as Calories, nutr_fat_g as Fat,
      nutr_carbohydrates_g as Carbs, nutr_protein_g as Protein
FROM vendor v JOIN food_menu fm ON v.vend_id = fm.vend_id
JOIN food f ON f.food_id = fm.food_id
JOIN nutrition n on f.nutr_id = n.nutr_id
WHERE vend_name = "Floral and Hardy";

-- 10) The number of good ratings by the enrolled date of the customers.
-- Are newer customer happy with their meals? Is the platform doing a better
-- or worse job?

SELECT c.contact_enrollDate AS EnrollDate , COUNT(r.rating_rating) as NumGoodRatings
FROM contact_information c
JOIN customer cu ON cu.contact_id = c.contact_id
LEFT JOIN rating r ON cu.cust_id = r.cust_id
WHERE r.rating_rating IN (SELECT rating_rating FROM rating WHERE rating_rating >= 4)
GROUP BY EnrollDate
ORDER BY EnrollDate ASC;
