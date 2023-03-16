package router

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/controller/auth"
	"github.com/gradely/gradely-backend/pkg/middleware"
	auth2 "github.com/gradely/gradely-backend/service/auth"
	"github.com/jmoiron/sqlx"
)

func AuthUrl(r *gin.Engine, db *sqlx.DB, validate *validator.Validate, ApiVersion string) *gin.Engine {

	service := auth2.NewAuthService()
	api := auth.Controller{Db: db, Validate: validate, Service: service}

	// Create auth route group
	authUrl := r.Group(fmt.Sprintf("/%v/auth", ApiVersion))
	{
		authUrl.POST("/login", api.Login)
		authUrl.POST("/refresh", api.RefreshToken)
		authUrl.POST("/find-student-with-code", api.FindStudentWithCode)
	}

	authProfileUrl := r.Group(fmt.Sprintf("/%v/auth", ApiVersion), middleware.Authorize(db))
	{
		authProfileUrl.POST("/check", api.CheckToken)
		authProfileUrl.GET("/profile", api.TokenProfile)
		authProfileUrl.GET("/fetch-profile", api.FetchProfile)
		authProfileUrl.PUT("/profile-image", api.UpdateProfileImage)
		authProfileUrl.POST("/get-relations", api.GetStudentRelations)
		authProfileUrl.POST("/connect-with-student", api.ConnectToStudent)
		authProfileUrl.POST("/add-child", api.AddChild)
	}

	verifyUrl := r.Group(fmt.Sprintf("/%v/auth", ApiVersion), middleware.Authorize(db))
	{
		verifyUrl.POST("/verify-account", api.RequestAccountVerification)
		//verifyUrl.PUT("/verify-account", api.VerifyCode)
		//verifyUrl.PUT("/update-contact-without-code", api.UpdateContactWithoutCode)
	}

	return r
}
