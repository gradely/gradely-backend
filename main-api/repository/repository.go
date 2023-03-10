package repository

import (
	"github.com/gradely/gradely-backend/model"
	"github.com/jmoiron/sqlx"
)

type UtilityRepository interface {
	GetSchoolAdmin(db *sqlx.DB, adminID int) model.SchoolAdmin
	GetTerm() model.TermWeek
}

type Repository struct {
	Utility UtilityRepository
}
