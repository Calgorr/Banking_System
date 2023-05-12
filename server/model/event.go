package model

type Event struct {
	Type             string `json:"type" form:"type" query:"type"`
	Transaction_time string `json:"transaction_time" form:"transaction_time" query:"transaction_time"`
	From             string `json:"from" form:"from" query:"from"`
	To               string `json:"to" form:"to" query:"to"`
	Amount           int    `json:"amount" form:"amount" query:"amount"`
}
