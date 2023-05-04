package main

import (
	"github.com/Calgorr/Banking_System/server/handler"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	handler.RegisterRoutes(e.Group("api"))
	e.Start(":8080")
}
