package auth

import (
	"github.com/gradely/gradely-backend/model/dto"
)

type ServiceAuth interface {
	AddChild(firstname, lastname string, class int, relationship string, user *dto.UserIdentity) (dto.UserRelationsResponse, error)
	GetStudentRelations(code, email, phone string, currentUser *dto.UserIdentity) ([]dto.UserRelationsResponse, error)
	ConnectToStudent(studentID int, relationship string, user *dto.UserIdentity) error

	//ValidateNumber(number string) (string, error)
	//GenerateLetters(length int) string
}

type serviceAuth struct {
}

func NewAuthService() ServiceAuth {
	return &serviceAuth{}
}

//
//func (util *serviceAuth) AddChild(firstname, lastname string, class int, relationship string, user *dto.UserIdentity) (dto.UserRelationsResponse, error) {
//	panic("implement me")
//}
//
//func (util *serviceAuth) GetStudentRelations(code, email, phone string, currentUser *dto.UserIdentity) ([]dto.UserRelationsResponse, error) {
//	panic("implement me")
//}
//
//func (util *serviceAuth) ConnectToStudent(studentID int, relationship string, user *dto.UserIdentity) error {
//	panic("implement me")
//}
