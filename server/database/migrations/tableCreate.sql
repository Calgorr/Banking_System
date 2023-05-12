CREATE TABLE account IF NOT EXISTS (
    accountnumber VARCHAR(20) NOT NULL,
    username VARCHAR(20) NOT NULL PRIMARY KEY,
    password VARCHAR(20) NOT NULL,
    firstname VARCHAR(20) NOT NULL,
    lastname VARCHAR(20) NOT NULL,
    nationalid VARCHAR(20) NOT NULL,
    dateofbirth DATE NOT NULL,
    type VARCHAR(20) NOT NULL,
    interestrate FLOAT default 0.0,
)

ALTER TABLE account OWNER TO calgor;
