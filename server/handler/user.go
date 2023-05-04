package handler

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/Calgorr/Banking_System/server/authentication"
	"github.com/Calgorr/Banking_System/server/model"
	"github.com/labstack/echo/v4"
)

func Login(c echo.Context) error {
	var user *model.User
	user, err := user.Bind(c)
	if userValidation(user) == false {
		return c.String(http.StatusUnauthorized, "invalid credentials")
	}
	token, err := authentication.GenerateJWT()
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusInternalServerError, "internal server error")
	}
	c.Response().Header().Set(echo.HeaderAuthorization, token)

	c.Response().WriteHeader(http.StatusOK)
	return json.NewEncoder(c.Response()).Encode(user)
}

func SignUp(c echo.Context) error {
	var user *model.User
	user, err := user.Bind(c)
	err = db.AddUser(user)
	if err != nil {
		return c.String(http.StatusConflict, "user already exists")
	}
	c.String(http.StatusOK, "success")
	return nil
}

func userValidation(user *model.User) bool {
	user, err := db.GetUser(user.Username, user.Password)
	if err != nil {
		return false
	}
	return true
}
