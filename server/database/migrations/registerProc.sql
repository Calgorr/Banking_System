CREATE OR REPLACE PROCEDURE register(username1 varchar, password1 varchar, first_name1 varchar, last_name1 varchar,
                                     national_id1 int8, dob date, interest_rate float4, type varchar)
    LANGUAGE plpgsql
AS
$$
DECLARE
    rate      float4 ;
    age_years INT;
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