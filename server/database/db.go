package database

import (
	"database/sql"
	"fmt"

	"github.com/Calgorr/Banking_System/server/model"
	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "calgor"
	password = "ami1r3ali"
	dbname   = "Bank"
)

var (
	db  *sql.DB
	err error
)

func connect() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	err := db.Ping()
	if err != nil {
		panic(err)
	}
}

func AddUser(user *model.User) error {
	connect()
	defer db.Close()
	_, err := db.Exec("Call insert_account($1,$2,$3,$4,$5,$6,$7,$8,$9)", user.Username, user.Password, user.Accountnumber, user.Firstname, user.Lastname, user.Nationalid, user.Dateofbirth, user.Type, user.Interestrate)
	return err
}

func GetUser(user *model.User) error {
	connect()
	defer db.Close()
	sqlStatment := "SELECT * FROM account account WHERE username=$1"
	return db.QueryRow(sqlStatment, user.Username).Scan(&user.Username, &user.Password, &user.Accountnumber, &user.Firstname, &user.Lastname, &user.Nationalid, &user.Dateofbirth, &user.Type, &user.Interestrate)
}
