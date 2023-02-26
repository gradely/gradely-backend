package auth

import (
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/repository"
	"github.com/jmoiron/sqlx"
)

type Controller struct {
	Db       *sqlx.DB
	Validate *validator.Validate
	Utility  repository.UtilityRepository
}
