-- Excersise 1 --
-- 1 --
SELECT * FROM(SELECT * FROM country ORDER BY country_id ASC) AS C WHERE country_id > 11 AND country_id < 18;

-- 2 --
SELECT * FROM(SELECT * FROM city as C, address as A WHERE C.city_id = A.city_id) 
AS all_addreses
WHERE SUBSTRING(city, 1, 1) = 'A';

-- 3 --
SELECT first_name, last_name, city 
FROM customer AS cus, 
city AS cit, 
address AS addr 
WHERE cit.city_id = addr.city_id AND addr.address_id = cus.address_id;

-- 4 --
SELECT * FROM customer AS cus, payment AS pay 
WHERE pay.customer_id = cus.customer_id AND pay.amount > 11;

-- 5 --
SELECT first_name FROM customer 
GROUP BY first_name HAVING COUNT(first_name) > 1;



