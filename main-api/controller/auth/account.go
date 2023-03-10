package auth

import (
	"database/sql"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/model/dto"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/gradely/gradely-backend/pkg/middleware"
	"github.com/gradely/gradely-backend/repository"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/gradely/gradely-backend/service/notification"
	service "github.com/gradely/gradely-backend/service/user"
	"github.com/gradely/gradely-backend/utility"
	"github.com/jmoiron/sqlx"
	"net/http"
	"time"
)

type Controller struct {
	Db       *sqlx.DB
	Validate *validator.Validate
	Utility  repository.GeneralRepository
	Service  auth.ServiceAuth
}

// RequestAccountVerification generates a verification code for the current user's account
// and sends it via the specified channel (email or phone).
func (ctrl *Controller) RequestAccountVerification(c *gin.Context) {
	// Parse the request body into a struct
	req := struct {
		Channel string `json:"channel"`
	}{}
	err := c.ShouldBind(&req)
	if err != nil {
		// Return a Bad Request response if there is an error parsing the request body
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Failed to parse request body", err, nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	// Determine the verification type based on the query parameter
	verificationType := "account"
	if param := c.Query("type"); param == "contact" {
		verificationType = "contact"
	}

	// Get the current user from the middleware
	currentUser := middleware.MyIdentity

	// Create an AccountVerificationLog object with a randomly generated code
	avLog := &dto.AccountVerificationLog{
		UserID:     currentUser.ID,
		Code:       utility.GenerateNumbers(6),
		CodeExpiry: time.Now().Add(time.Hour),
		Type:       sql.NullString{String: verificationType, Valid: true},
	}

	// Set the channel to the specified value or default to email
	if req.Channel == "phone" {
		avLog.Channel = "phone"
	} else {
		avLog.Channel = "email"
	}

	// Save the verification log for the specified channel
	status := service.SaveAccVerificationLog(c, avLog)

	// If in a non-production environment, include the verification code in the response
	resp := map[string]interface{}{
		"status": status,
	}

	// If in a non-production environment, include the verification code in the response
	if config.GetConfig().Params.Environment != "production" {
		resp["code"] = avLog.Code
	}

	// Send the verification code to the user via a notification
	go func() {
		err := notification.AccountVerificationCode(currentUser.ID, avLog.Code)
		if err != nil {
			// Log the error if there is one
			utility.LogErrorSentry(err)
		}
	}()

	// Return a success response
	rd := response.BuildResponse(http.StatusOK, "success", resp)
	c.JSON(http.StatusOK, rd)
}
