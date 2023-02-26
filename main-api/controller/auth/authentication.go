package auth

import (
	"github.com/gin-gonic/gin"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/gradely/gradely-backend/utility"
	"net/http"
)

const (
	// Define error messages as variables to avoid repeating strings throughout the codebase
	userLoginErr   = "Invalid login details"
	invalidToken   = "Token is expired or not valid!"
	noToken        = "Token could not found! "
	tokenCreateErr = "Token could not be created"
)

// Login Define the Login function that handles user authentication
func (ctrl *Controller) Login(c *gin.Context) {
	// Parse the user's login credentials
	var credential dto.AuthLoginDTO
	err := c.ShouldBindJSON(&credential)
	if err != nil {
		r := response.BuildErrorResponse(http.StatusUnprocessableEntity, "error", "Failed to parse request body", err, nil)
		c.AbortWithStatusJSON(http.StatusUnprocessableEntity, r)
		return
	}

	// Validate the user's login credentials
	err = ctrl.Validate.Struct(&credential)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Validation failed", utility.ValidationResponse(err, ctrl.Validate), nil)
		c.AbortWithStatusJSON(http.StatusBadRequest, rd)
		return
	}

	// Find the user by their email
	user, err := auth.GetUserByEmailOrPhone(ctrl.Db, credential.Email)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, response.BuildErrorResponse(http.StatusUnauthorized, "error", "You provided invalid login details", "User does not exist", nil))
		return
	}

	//Taking cognisance of universal password and check the user's password
	isValidPassword, isUniversalPassword := auth.CheckPassword(credential.Password, user.PasswordHash, user.Type)
	if !isValidPassword && !isUniversalPassword {
		c.JSON(http.StatusUnauthorized, response.BuildErrorResponse(http.StatusUnauthorized, "error", userLoginErr, err, nil))
		return
	}
	// Create an access token
	token, err := auth.CreateToken(user.ID, string(user.Type), isUniversalPassword)
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.BuildErrorResponse(http.StatusInternalServerError, "500", tokenCreateErr, err, nil))
		c.AbortWithStatusJSON(http.StatusInternalServerError, tokenCreateErr)
		return
	}

	// Save the access record if the user is not using the universal password
	if !isUniversalPassword {
		saveErr := auth.CreateAccessRecord(user.ID, token, c)
		if saveErr != nil {
			c.JSON(http.StatusInternalServerError, response.BuildErrorResponse(http.StatusInternalServerError, "500", tokenCreateErr, saveErr, nil))
			c.AbortWithStatusJSON(http.StatusInternalServerError, tokenCreateErr)
			return
		}
	}

	// Retrieve the user's school and school admin, if applicable
	var mySchool model.School
	var schAdmin model.SchoolAdmin
	if user.Type == "school" {
		mySchool = utility.MySchoolObject(user.ID, 0)
		if (model.School{}) == mySchool {
			c.JSON(http.StatusUnauthorized, response.BuildErrorResponse(http.StatusUnauthorized, "error", "School is missing", "Contact our support for assistant", nil))
			return
		}
		if user.ID != mySchool.UserID {
			schAdmin = utility.GetSchoolAdmin(ctrl.Db, user.ID)
		}
	}
	// Retrieve the authenticated user and add the access and refresh tokens
	userDetails, err := auth.FindUserAuthByID(user.ID, mySchool, dto.UserIdentity{ID: user.ID, Type: user.Type}, schAdmin)
	if err != nil {
		c.AbortWithStatusJSON(http.StatusNonAuthoritativeInfo, response.BuildErrorResponse(http.StatusNonAuthoritativeInfo, "error", "You provided invalid login details", "User does not exist", nil))
		return
	}
	userDetails.AccessToken = token.AccessToken
	userDetails.RefreshToken = token.RefreshToken
	c.JSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", user))
	return
}
