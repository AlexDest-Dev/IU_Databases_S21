-- Preparing
CREATE TABLE bank_accounts
(uID INTEGER PRIMARY KEY,
 name text,
credit integer);
INSERT INTO bank_accounts(uid, name, credit) VALUES (1, 'John Smith', 1000);
INSERT INTO bank_accounts(uid, name, credit) VALUES (2, 'Alice Cooper', 1000);
INSERT INTO bank_accounts(uid, name, credit) VALUES (3, 'Genry Cavill', 1000);

-- Part 1

UPDATE bank_accounts SET credit = 1000;
--T1
BEGIN;
SAVEPOINT T1;
UPDATE bank_accounts SET credit = credit - 500 WHERE uid = 1 ;
UPDATE bank_accounts SET credit = credit + 500 WHERE uid = 3 ;
--ROLLBACK TO T1;
COMMIT;

--T2
BEGIN;
SAVEPOINT T2;
UPDATE bank_accounts SET credit = credit - 700 WHERE uid = 2 ;
UPDATE bank_accounts SET credit = credit + 700 WHERE uid = 1 ;
--ROLLBACK TO T2;
COMMIT;

--T3
BEGIN;
SAVEPOINT T3;
UPDATE bank_accounts SET credit = credit - 100 WHERE uid = 2 ;
UPDATE bank_accounts SET credit = credit + 100 WHERE uid = 3 ;
--ROLLBACK TO T3;
COMMIT;

SELECT * FROM bank_accounts;


-- Part 2 (with fee)

/*ALTER TABLE bank_accounts ADD COLUMN bank_name text;
UPDATE bank_accounts SET bank_name = 'SpearBank' WHERE uid = 1 OR uid = 3;
UPDATE bank_accounts SET bank_name = 'Tinkoff' WHERE uid = 2;
SELECT * FROM bank_accounts;
INSERT INTO bank_accounts(uid, name, credit) VALUES(4, 'Fee', 0);*/


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
--ROLLBACK TO T3;
COMMIT;

SELECT * FROM bank_accounts;