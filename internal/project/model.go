package project

type Project struct {
	ID            int64
	OrganizatinID int64
	Name          string
	CustomerID    int64
	Price         decimal.Decimal
}
