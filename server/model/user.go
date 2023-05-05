package model

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
)

type User struct {
	Username      string `json:"username" form:"username"`
	Password      string `json:"password" form:"password"`
	Firstname     string `json:"firstname" form:"firstname"`
	Lastname      string `json:"lastname" form:"lastname"`
	Accountnumber string `json:"accountnumber" form:"accountnumber"`
	Nationalid    string `json:"nationalid" form:"nationalid"`
	Dateofbirth   string `json:"dateofbirth" form:"dateofbirth"`
	Type          string `json:"type" form:"type"`
	Interestrate  string `json:"interestrate" form:"interestrate"`
}

func (user *User) Bind(c echo.Context) (*User, error) {
	err := c.Bind(&user)
	if err != nil {
		fmt.Println(err)
		return nil, c.String(http.DefaultMaxHeaderBytes, "bad request")
	}
	return user, nil
}
