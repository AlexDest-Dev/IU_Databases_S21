import psycopg2

con = psycopg2.connect(database="postgres", user="postgres",
                       password="88664422", host="127.0.0.1", port="5432")

print("Database opened successfully")
cur = con.cursor()
cur.execute("EXPLAIN ANALYZE SELECT * FROM payment WHERE amount = 5.99;")

analyze_fetched = cur.fetchall()
print(analyze_fetched)
