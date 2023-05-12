CREATE OR REPLACE PROCEDURE deposit(amount1 float4)
    LANGUAGE plpgsql
AS
$$
DECLARE
    credit_number int8 ;
BEGIN
    SELECT account_number
    FROM account a
    WHERE a.username = (
        SELECT username
        FROM login_log l1
        WHERE l1.login_time = (SELECT max(l2.login_time) FROM login_log l2))
    INTO credit_number;

    INSERT INTO transaction (type, time, debtor, creditor, amount)
    VALUES ('DEPOSIT', now(), credit_number, null, amount1);
END
$$;


CREATE OR REPLACE PROCEDURE withdraw(amount1 float4)
    LANGUAGE plpgsql
AS
$$
DECLARE
    credit_number int8 ;
BEGIN
    SELECT account_number
    FROM account a
    WHERE a.username = (
        SELECT username
        FROM login_log l1
        WHERE l1.login_time = (SELECT max(l2.login_time) FROM login_log l2))
    INTO credit_number;

    INSERT INTO transaction (type, time, debtor, creditor, amount)
    VALUES ('WITHDRAW', now(), null, credit_number, amount1);
END
$$;

CREATE OR REPLACE PROCEDURE transfer(amount1 float4, creditor1 int8)
    LANGUAGE plpgsql
AS
$$
DECLARE
    debtor_number int8 ;
BEGIN
    SELECT account_number
    FROM account a
    WHERE a.username = (
        SELECT username
        FROM login_log l1
        WHERE l1.login_time = (SELECT max(l2.login_time) FROM login_log l2))
    INTO debtor_number;

    INSERT INTO transaction (type, time, debtor, creditor, amount)
    VALUES ('TRANSFER', now(), debtor_number, creditor1, amount1);
END
$$;

CREATE OR REPLACE PROCEDURE interest_payment()
    LANGUAGE plpgsql
AS
$$
DECLARE
    total     float4 ;
    new_total float4;
    inter     float4;
    user1     int8;
BEGIN
    FOR user1 IN SELECT account_number FROM account a WHERE a.interest_rate IS NOT NULL AND a.interest_rate <> 0
        LOOP
            SELECT amount from latest_balance where account_number = user1 INTO total;
            SELECT interest_rate from account where account_number = user1 INTO inter;
            new_total := (total * inter) / 100;
            INSERT INTO transaction (type, time, debtor, creditor, amount)
            VALUES ('INTEREST', now(), user1, null, new_total);
        END LOOP;
END
$$;