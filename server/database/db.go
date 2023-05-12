package database

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/Calgorr/Banking_System/server/model"
	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 8080
	user     = "calgor"
	password = "ami1r3ali"
	dbname   = "bank"
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
	fmt.Println(err)
	return err
}

func GetUser(user *model.User) (*model.User, error) {
	var id int
	u := new(model.User)
	connect()
	defer db.Close()
	sqlStatment := "SELECT * FROM account account WHERE username=$1"
	err := db.QueryRow(sqlStatment, user.Username).Scan(&id, &u.Username, &u.Password, &u.Accountnumber, &u.Firstname, &u.Lastname, &u.Nationalid, &u.Dateofbirth, &u.Type, &u.Interestrate)
	if err != nil {
		return nil, err
	}
	if u.Password != user.Password {
		return nil, errors.New("invalid credentials")
	}
	return u, nil
}
func Login(user *model.User) error {
	connect()
	defer db.Close()
	sqlStatement := "CALL PROCEDURE login($1,$2)"
	_, err := db.Exec(sqlStatement, user.Username, user.Password)
	return err
}
func Deposit(event *model.Event) error {
	connect()
	defer db.Close()
	sqlStatement := "CALL PROCEDURE deposit($1)"
	_, err := db.Exec(sqlStatement, event.Amount)
	return err
}

func Withdraw(event *model.Event) error {
	connect()
	defer db.Close()
	sqlStatement := "CALL PROCEDURE withdraw($1)"
	_, err := db.Exec(sqlStatement, event.Amount)
	return err
}
