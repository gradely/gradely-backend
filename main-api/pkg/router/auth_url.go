package router

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/controller/auth"
	"github.com/jmoiron/sqlx"
)

func AuthUrl(r *gin.Engine, db *sqlx.DB, validate *validator.Validate, ApiVersion string) *gin.Engine {

	api := auth.Controller{Db: db, Validate: validate}

	// Create auth route group
	authUrl := r.Group(fmt.Sprintf("/%v/auth", ApiVersion))
	{
		authUrl.POST("/login", api.Login)
		authUrl.POST("/refresh", api.RefreshToken)
	}

	return r
}
