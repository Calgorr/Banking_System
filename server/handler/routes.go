package handler

import "github.com/labstack/echo/v4"

func RegisterRoutes(e *echo.Group) {
	//Auth not needed
	v1 := e.Group("")
	v1.POST("login/", login)
}
