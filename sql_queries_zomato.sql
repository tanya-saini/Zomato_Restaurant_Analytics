-- ZOMATO RESTAURANT SUCCESS FACTORS — SQL ANALYSIS
-- *************************************************
-- Database: zomato.db (SQLite) | Table: zomato_data
-- Note: "Is Rated" = 1 means Aggregate rating > 0 (i.e. restaurant has actually been rated).
-- Using Is Rated = 1 for rating analysis,since ~22% of restaurants have rating = 0 ("Not rated").


-- 1. RATING DRIVERS: Avg rating by Price Range
SELECT
    "Price range",
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating,
    COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
GROUP BY "Price range"
ORDER BY "Price range";


-- 2. RATING DRIVERS: Rating trend across vote tiers (correlation)
SELECT 
    CASE
	    WHEN "Votes" < 10 THEN "1. Under 10 votes"
	    WHEN "Votes" < 51 THEN "2. 10-50 votes"
		WHEN "Votes" < 201 THEN "3. 51-200 votes"
		WHEN "Votes" < 501 THEN "4. 201-500 votes"
		ELSE "5. 500+ votes"
	END AS "votes_tier",
	ROUND(AVG("Aggregate rating"),2) as avg_rating,
	COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
GROUP BY "votes_tier"
ORDER BY "votes_tier";

-- 3. CONFOUNDING CHECK: Table Booking effect, WITHIN each price tier
SELECT
    "Price range",
    "Has Table booking",
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating,
    COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
GROUP BY "Price range","Has Table booking"
ORDER BY "Price range""Has Table booking";

-- 4. SERVICE IMPACT: Online Delivery effect, WITHIN each price tier
SELECT
    "Price range",
    "Has Online delivery",
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating,
    ROUND(AVG("Votes"),0) AS avg_votes,
    COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
GROUP BY "Price range","Has Online delivery"
ORDER BY "Price range""Has Online delivery";

-- 5. VOTE PREDICTORS: Avg votes by Price Range, Delhi NCR only
SELECT
    "Price range",
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating,
    ROUND(AVG("Votes"),0) AS avg_votes,
    COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
    AND "City" IN ('New Delhi', 'Gurgaon', 'Noida', 'Faridabad', 'Ghaziabad')
GROUP BY "Price range"
ORDER BY "Price range";

-- 6. CUISINE PERFORMANCE: Top 10 cuisines by rating, Delhi NCR only,
--    minimum 100 restaurants for statistical reliability
SELECT
    "Primary cuisine",
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating,
    ROUND(AVG("Votes"),1) AS avg_votes,
    COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
    AND "City" IN ('New Delhi', 'Gurgaon', 'Noida', 'Faridabad', 'Ghaziabad')
GROUP BY "Primary cuisine"
HAVING COUNT(*) > 100
ORDER BY avg_rating DESC
LIMIT 10;

-- 7. CUISINE PERFORMANCE: Bottom 5 cuisines (oversaturated / low quality)
SELECT
    "Primary cuisine",
    ROUND(AVG("Aggregate rating"), 2) AS avg_rating,
    ROUND(AVG("Votes"),1) AS avg_votes,
    COUNT(*) AS restaurant_count
FROM zomato_data
WHERE "Is rated" = "True"
    AND "City" IN ('New Delhi', 'Gurgaon', 'Noida', 'Faridabad', 'Ghaziabad')
GROUP BY "Primary cuisine"
HAVING COUNT(*) > 100
ORDER BY avg_rating 
LIMIT 5;

-- 9. MARKET SATURATION: Restaurant density vs demand 
--    Cuisines with high customer interest but low restaurant count
SELECT 
    "City",
    "Primary cuisine",
    COUNT(*) AS restaurant_count,
    ROUND(AVG("Votes"),1) AS avg_votes
FROM zomato_data
WHERE "Is rated"  = "True"
GROUP BY "City","Primary cuisine"
HAVING COUNT(*) < 5 AND AVG("Votes") > 200
ORDER BY avg_votes DESC
LIMIT 20;







