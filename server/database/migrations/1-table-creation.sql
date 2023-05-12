create table account (
    account_number integer not null,
    username varchar not null constraint account_pk primary key,
    password varchar not null,
    first_name varchar not null,
    last_name varchar,
    national_id bigint not null,
    date_of_birth date,
    interest_rate double precision default 0,
    type varchar
);

alter table
    account owner to calgor;

create unique index account_account_number_uindex on account (account_number);

create table login_log (
    username varchar not null constraint login_log_username_fk references account,
    login_time timestamp not null,
    constraint login_log_pk primary key (username, login_time)
);

alter table
    login_log owner to calgor;

create table transaction (
    type varchar not null,
    time timestamp not null,
    debtor integer constraint transaction_deposit_fk references account (account_number),
    creditor integer constraint transaction_credit_fk references account (account_number),
    amount real not null,
    id serial not null constraint transaction_pk primary key
);

alter table
    transaction owner to calgor;

create table latest_balance (
    account_number integer not null constraint latest_balance_pk primary key constraint latest_balance_account_fk references account (account_number),
    amount real not null
);

alter table
    latest_balance owner to calgor;

create table snapshot_log (
    id serial not null constraint snapshot_log_pk primary key,
    time timestamp not null
);

alter table
    snapshot_log owner to calgor;