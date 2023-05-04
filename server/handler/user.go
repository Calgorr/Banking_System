package handler

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/Calgorr/Banking_System/server/authentication"
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
