package user

import (
	"github.com/jmoiron/sqlx"
)

type ServiceUser interface {
	UpdateUserImage(image string, userID int, db *sqlx.DB) (bool, error)
}

type serviceUser struct {
}

func NewAuthService() ServiceUser {
	return &serviceUser{}
}
