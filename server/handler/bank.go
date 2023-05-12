package handler

import (
	"github.com/Calgorr/Banking_System/server/model"
	"github.com/labstack/echo/v4"
)

func Deposit(c echo.Context) error {
	event := new(model.Event)
	if err := c.Bind(event); err != nil {
		return err
	}
	switch event.Type {
	case "deposit":
		d
	}

}
