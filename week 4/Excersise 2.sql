-- Excersise 2 --
-- 1 --

CREATE VIEW short_films AS
SELECT * FROM film WHERE length < 50;

CREATE VIEW adult_films as
SELECT * FROM film WHERE rating = 'NC-17'

-- 2 --

SELECT * FROM adult_films WHERE film_id 
IN (SELECT film_id FROM film_category AS rel, category AS cat 
	WHERE cat.name = 'Sci-Fi' 
	AND cat.category_id = rel.category_id);
	
-- 3 --

CREATE OR REPLACE FUNCTION payment_date_calculator()
RETURNS TRIGGER AS
$$
BEGIN
	NEW.amount = (SELECT rental_duration FROM inventory AS inv, rental AS ren, film WHERE NEW.rental_id = ren.rental_id AND ren.inventory_id = inv.inventory_id AND film.film_id = inv.film_id) * 
				 (SELECT rental_rate FROM inventory AS inv, rental AS ren, film WHERE NEW.rental_id = ren.rental_id AND ren.inventory_id = inv.inventory_id AND film.film_id = inv.film_id);
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_payment
AFTER INSERT ON payment
EXECUTE PROCEDURE payment_date_calculator();