package repository

import (
	"github.com/gradely/gradely-backend/model"
	"github.com/jmoiron/sqlx"
)

type UtilityRepository interface {
	GetSchoolAdmin(db *sqlx.DB, adminID int) model.SchoolAdmin
	GetTerm() model.TermWeek
	GenerateLetters(n int) string
	ValidateNumber(number string) (string, error)
	CheckExist(db *sqlx.DB, query string, args ...interface{}) bool
}

type Repository struct {
	Utility UtilityRepository
}
