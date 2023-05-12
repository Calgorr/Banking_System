CREATE OR REPLACE PROCEDURE register(username1 varchar, password1 varchar, first_name1 varchar, last_name1 varchar,
                                     national_id1 int8, dob date, interest_rate float4, type varchar)
    LANGUAGE plpgsql
AS
$$
DECLARE
    rate      float4 ;
    age_years INTEGER;
BEGIN
    rate := interest_rate;
    IF type = 'EMPLOYEE' THEN
        rate := 0;
    end if;

    SELECT EXTRACT(YEAR FROM age(current_date, dob)) INTO age_years;

-- Check if age is less than 13
    IF age_years < 13 THEN
        RAISE EXCEPTION 'Age is less than 13.';
    END IF;

    INSERT INTO account (account_number, username, password, first_name, last_name, national_id, date_of_birth,
                         interest_rate, type)
    VALUES (1, username1, hashtext(password1), first_name1, last_name1, national_id1, dob, rate, type);
END
$$;



CREATE OR REPLACE FUNCTION update_user_number()
    RETURNS TRIGGER AS
$$
DECLARE
    user_number     INTEGER;
    unique_username VARCHAR(100);
BEGIN
    unique_username := '';
    WHILE unique_username = ''
        LOOP
            unique_username := to_char(floor(random() * 10000000000000000), 'FM0000000000000000');
            SELECT INTO unique_username CASE
                                            WHEN EXISTS(SELECT 1 FROM account WHERE username = unique_username) THEN ''
                                            ELSE unique_username END;
        END LOOP;
    user_number := (abs(hashtext(NEW.first_name || NEW.last_name || unique_username))) % 10000000000000000;
    UPDATE account SET account_number = user_number where account.username = NEW.username;
    INSERT INTO latest_balance (account_number, amount) VALUES (user_number, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_account_number
    AFTER INSERT
    ON account
    FOR EACH ROW
EXECUTE FUNCTION update_user_number();