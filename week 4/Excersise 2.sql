-- Excersise 2 --
-- 1 --

CREATE OR REPLACE VIEW short_films AS
SELECT * FROM film WHERE length < 50;

CREATE OR REPLACE VIEW adult_films as
SELECT * FROM film WHERE rating = 'NC-17';

-- 2 --

SELECT * FROM adult_films WHERE film_id 
IN (SELECT film_id FROM film_category AS rel, category AS cat 
	WHERE cat.name = 'Sci-Fi' 
	AND cat.category_id = rel.category_id);
	
-- 3 --

CREATE OR REPLACE FUNCTION short_films_refresh()
RETURNS TRIGGER AS
$$
BEGIN
	CREATE OR REPLACE VIEW short_films AS
	SELECT * FROM film WHERE length < 50;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER short_films_refresher
BEFORE INSERT ON payment
EXECUTE PROCEDURE short_films_refresh();