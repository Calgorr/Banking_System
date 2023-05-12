CREATE
OR REPLACE PROCEDURE update_balances() LANGUAGE plpgsql AS $ $ DECLARE lastCheck timestamp;

trans_id int4;

trans_type varchar;

deposit_num int4;

credit_num int4;

amnt float4;

dep_last_amnt float4;

crd_last_amnt float4;

crd_user_type varchar;

BEGIN
SELECT
    MAX(time)
FROM
    snapshot_log INTO lastCheck;

FOR trans_id IN
SELECT
    id
FROM
    transaction t
where
    t.time >= lastCheck
    OR lastCheck IS NULL LOOP
SELECT
    type INTO trans_type
FROM
    transaction
WHERE
    id = trans_id;

SELECT
    debtor INTO deposit_num
FROM
    transaction
WHERE
    id = trans_id;

SELECT
    creditor INTO credit_num
FROM
    transaction
WHERE
    id = trans_id;

SELECT
    amount INTO amnt
FROM
    transaction
WHERE
    id = trans_id;

SELECT
    type INTO crd_user_type
FROM
    account
WHERE
    account_number = trans_id;

IF trans_type = 'DEPOSIT' THEN
SELECT
    amount INTO dep_last_amnt
FROM
    latest_balance
where
    account_number = deposit_num;

UPDATE
    latest_balance
SET
    amount = dep_last_amnt + amnt
WHERE
    account_number = deposit_num;

end if;

IF trans_type = 'WITHDRAW' THEN
SELECT
    amount INTO crd_last_amnt
FROM
    latest_balance
where
    account_number = credit_num;

IF crd_last_amnt - amnt < 0
and crd_user_type = 'EMPLOYEE' THEN
UPDATE
    latest_balance
SET
    amount = crd_last_amnt - amnt
WHERE
    account_number = credit_num;

end if;

IF crd_last_amnt - amnt >= 0 THEN
UPDATE
    latest_balance
SET
    amount = crd_last_amnt - amnt
WHERE
    account_number = credit_num;

end if;

end if;

IF trans_type = 'TRANSFER' THEN
SELECT
    amount INTO dep_last_amnt
FROM
    latest_balance
where
    account_number = deposit_num;

SELECT
    amount INTO crd_last_amnt
FROM
    latest_balance
where
    account_number = credit_num;

SELECT
    amount INTO crd_last_amnt
FROM
    latest_balance
where
    account_number = credit_num;

IF dep_last_amnt - amnt < 0
and crd_user_type = 'EMPLOYEE' THEN
UPDATE
    latest_balance
SET
    amount = dep_last_amnt - amnt
WHERE
    account_number = deposit_num;

UPDATE
    latest_balance
SET
    amount = crd_last_amnt + amnt
WHERE
    account_number = credit_num;

end if;

IF dep_last_amnt - amnt >= 0 THEN
UPDATE
    latest_balance
SET
    amount = dep_last_amnt - amnt
WHERE
    account_number = deposit_num;

UPDATE
    latest_balance
SET
    amount = crd_last_amnt + amnt
WHERE
    account_number = credit_num;

end if;

end if;

IF trans_type = 'INTEREST' THEN
SELECT
    amount INTO dep_last_amnt
FROM
    latest_balance
where
    account_number = deposit_num;

UPDATE
    latest_balance
SET
    amount = dep_last_amnt + amnt
WHERE
    account_number = deposit_num;

end if;

END LOOP;

INSERT INTO
    snapshot_log (time)
VALUES
    (now());

END $ $;

CREATE
OR REPLACE FUNCTION check_balance() RETURNS DECIMAL(10, 2) LANGUAGE plpgsql AS $ $ DECLARE user1 int8;

balance float4;

BEGIN
SELECT
    account_number
FROM
    account a
WHERE
    a.username = (
        SELECT
            username
        FROM
            login_log l1
        WHERE
            l1.login_time = (
                SELECT
                    max(l2.login_time)
                FROM
                    login_log l2
            )
    ) INTO user1;

SELECT
    amount INTO balance
FROM
    latest_balance
where
    account_number = user1;

RETURN balance;

END $ $;