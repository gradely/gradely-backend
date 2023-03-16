package auth

import (
	"github.com/gin-gonic/gin"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	"github.com/jmoiron/sqlx"
)

type ServiceAuth interface {
	AddChild(firstname, lastname string, class int, relationship string, user *dto.UserIdentity) (dto.UserRelationsResponse, error)
	GetStudentRelations(code, email, phone string, currentUser *dto.UserIdentity) ([]dto.UserRelationsResponse, error)
	ConnectToStudent(studentID int, relationship string, user *dto.UserIdentity) error
	FindStudentWithCode(code string) (*dto.FindStudentResponse, error)
	GetUserByEmailOrPhone(db *sqlx.DB, emailOrPhone string) (*model.User, error)
	CheckPassword(password, hash string) (bool, bool)
	CreateToken(userID int, userType string, universalAccess bool) (*dto.TokenDetailsDTO, error)
	CreateAccessRecord(userid int, td *dto.TokenDetailsDTO, c *gin.Context) error
	ExtractToken(c *gin.Context) string
	GetUserProfile(id int) (dto.UserProfileResponse, error)
}

type serviceAuth struct {
}

func NewAuthService() ServiceAuth {
	return &serviceAuth{}
}
