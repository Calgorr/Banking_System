package handler

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func RegisterRoutes(e *echo.Group) {
	e.Use(middleware.Logger())
	//Auth not needed
	v1 := e.Group("")
	v1.POST("login/", Login)
	v1.POST("signup/", SignUp)
}
