-- Preparing
CREATE TABLE ledger(
id SERIAL PRIMARY KEY,
t_from integer,
t_to integer,
fee integer,
amount integer,
transaction_date date
);

-- Main part
UPDATE bank_accounts SET credit = 1000 WHERE uid != 4;
UPDATE bank_accounts SET credit = 0 WHERE uid = 4;
--T1
BEGIN;
SAVEPOINT T1;
UPDATE bank_accounts SET credit = credit + 30 WHERE uid = 4 AND 
EXISTS (SELECT * FROM bank_accounts as ba1, bank_accounts as ba2 
		WHERE ba1.uid = 1 and ba2.uid = 3 and ba1.bank_name != ba2.bank_name);
UPDATE bank_accounts SET credit = credit - 30 WHERE uid = 1 AND 
EXISTS (SELECT * FROM bank_accounts as ba1, bank_accounts as ba2 
		WHERE ba1.uid = 1 and ba2.uid = 3 and ba1.bank_name != ba2.bank_name);
UPDATE bank_accounts SET credit = credit - 500 WHERE uid = 1 ;
UPDATE bank_accounts SET credit = credit + 500 WHERE uid = 3 ;
INSERT INTO ledger(t_from, t_to, fee, amount, transaction_date) 
VALUES (1, 3, 0, 500, now());
--ROLLBACK TO T1;
COMMIT;

--T2
BEGIN;
SAVEPOINT T2;
UPDATE bank_accounts SET credit = credit + 30 WHERE uid = 4 AND 
EXISTS (SELECT * FROM bank_accounts as ba1, bank_accounts as ba2 
		WHERE ba1.uid = 1 and ba2.uid = 2 and ba1.bank_name != ba2.bank_name);
UPDATE bank_accounts SET credit = credit - 30 WHERE uid = 2 AND 
EXISTS (SELECT * FROM bank_accounts as ba1, bank_accounts as ba2 
		WHERE ba1.uid = 1 and ba2.uid = 2 and ba1.bank_name != ba2.bank_name);
UPDATE bank_accounts SET credit = credit - 700 WHERE uid = 2 ;
UPDATE bank_accounts SET credit = credit + 700 WHERE uid = 1 ;
INSERT INTO ledger(t_from, t_to, fee, amount, transaction_date) 
VALUES (2, 1, 30, 700, now());
--ROLLBACK TO T2;
COMMIT;

--T3
BEGIN;
SAVEPOINT T3;
UPDATE bank_accounts SET credit = credit + 30 WHERE uid = 4 AND 
EXISTS (SELECT * FROM bank_accounts as ba1, bank_accounts as ba2 
		WHERE ba1.uid = 2 and ba2.uid = 3 and ba1.bank_name != ba2.bank_name);
UPDATE bank_accounts SET credit = credit - 30 WHERE uid = 2 AND 
EXISTS (SELECT * FROM bank_accounts as ba1, bank_accounts as ba2 
		WHERE ba1.uid = 2 and ba2.uid = 3 and ba1.bank_name != ba2.bank_name);
UPDATE bank_accounts SET credit = credit - 100 WHERE uid = 2 ;
UPDATE bank_accounts SET credit = credit + 100 WHERE uid = 3 ;
INSERT INTO ledger(t_from, t_to, fee, amount, transaction_date) 
VALUES (2, 3, 30, 100, now());
--ROLLBACK TO T3;
COMMIT;

SELECT * FROM ledger;