CREATE
OR REPLACE PROCEDURE login(username1 varchar, password1 varchar) LANGUAGE plpgsql AS $ $ DECLARE hash_pwd varchar;

select_username varchar;

BEGIN hash_pwd := hashtext(password1);

SELECT
    username
from
    account a
where
    a.username = username1
    and a.password = hash_pwd INTO select_username;

IF select_username IS NULL THEN RAISE EXCEPTION 'Invalid Information.';

END IF;

INSERT INTO
    login_log(username, login_time)
VALUES
    (username1, now());

END $ $;