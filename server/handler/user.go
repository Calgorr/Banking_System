package handler

import (
	"fmt"
	"net/http"

	"github.com/Calgorr/Banking_System/server/authentication"
	db "github.com/Calgorr/Banking_System/server/database"
	"github.com/Calgorr/Banking_System/server/model"

	"github.com/labstack/echo/v4"
)

func Login(c echo.Context) error {
	user := new(model.User)
	user, err := user.Bind(c)
	if userValidation(user) == false {
		return c.String(http.StatusUnauthorized, "invalid credentials")
	}
	token, err := authentication.GenerateJWT()
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusInternalServerError, "internal server error")
	}
	db.Login(user)
	c.Response().Header().Set(echo.HeaderAuthorization, token)
	return c.String(http.StatusOK, "success")
}

func SignUp(c echo.Context) error {
	user := new(model.User)
	user, err := user.Bind(c)
	err = db.AddUser(user)
	if err != nil {
		return c.String(http.StatusConflict, "user already exists")
	}
	return c.String(http.StatusOK, "success")
}

func userValidation(user *model.User) bool {
	user, err := db.GetUser(user)
	if err != nil {
		return false
	}
	return true
}
