package model

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
)

type User struct {
	Username      string  `json:"username" form:"username"`
	Password      string  `json:"password" form:"password"`
	Firstname     string  `json:"firstname" form:"firstname"`
	Lastname      string  `json:"lastname" form:"lastname"`
	Accountnumber string  `json:"accountnumber" form:"accountnumber"`
	Nationalid    string  `json:"nationalid" form:"nationalid"`
	Dateofbirth   string  `json:"dateofbirth" form:"dateofbirth"`
	Type          string  `json:"type" form:"type"`
	Interestrate  float32 `json:"interestrate" form:"interestrate"`
}

func (user *User) Bind(c echo.Context) (*User, error) {
	err := c.Bind(user)
	if err != nil {
		return nil, c.String(http.StatusConflict, "bad request")
	}
	fmt.Println(user)
	user.Dateofbirth = "2023-04-04"
	user.Interestrate = 0
	return user, nil
}
