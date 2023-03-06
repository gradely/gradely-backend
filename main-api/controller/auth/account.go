package auth

import (
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/repository"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/jmoiron/sqlx"
)

type Controller struct {
	Db       *sqlx.DB
	Validate *validator.Validate
	Utility  repository.GeneralRepository
	Service  auth.ServiceAuth
}

//
//type Service interface {
//	AddChild(firstname, lastname string, class int, relationship string, user *dto.UserIdentity) (dto.UserRelationsResponse, error)
//	GetStudentRelations(code, email, phone string, currentUser *dto.UserIdentity) ([]dto.UserRelationsResponse, error)
//	ConnectToStudent(studentID int, relationship string, user *dto.UserIdentity) error
//}
