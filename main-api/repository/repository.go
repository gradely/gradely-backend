package repository

import (
	"github.com/gradely/gradely-backend/model"
	"github.com/jmoiron/sqlx"
)

type GeneralRepository interface {
	GetSchoolAdmin(db *sqlx.DB, adminID int) model.SchoolAdmin
	GetTerm() model.TermWeek
	GenerateLetters(n int) string
	ValidateNumber(number string) (string, error)
}

type Repository struct {
	Utility GeneralRepository
}
