package auth

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/gradely/gradely-backend/utility"
	"io"
	"log"
	"net/http"
	"strconv"
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

func (ctrl *Controller) RefreshToken(c *gin.Context) {

	mapToken := map[string]string{}

	decoder := json.NewDecoder(c.Request.Body)
	if err := decoder.Decode(&mapToken); err != nil {
		errs := []string{"REFRESH_TOKEN_ERROR"}
		c.JSON(http.StatusUnprocessableEntity, errs)
		return
	}

	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			fmt.Println(err)
		}
	}(c.Request.Body)
	token, err := auth.TokenValid(mapToken["refresh_token"])
	if err != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, invalidToken)
		return
	}

	claims, ok := token.Claims.(jwt.MapClaims) //the token claims should conform to MapClaims
	if ok && token.Valid {
		userAgent := auth.GetUserAgent(c)
		refreshUuid, ok := claims["refresh_uuid"].(string) //convert the interface to string
		if !ok {
			log.Println(err)
			c.JSON(http.StatusUnprocessableEntity, err)
			return
		}
		userId, err := strconv.ParseUint(claims["user_id"].(string), 10, 64)
		if err != nil {
			c.JSON(http.StatusUnprocessableEntity, "Error occured")
			return
		}

		//Delete the previous Refresh Token
		deleted, delErr := utility.RedisDelete(userAgent + "-" + claims["user_id"].(string) + "-" + refreshUuid)
		if delErr != nil || deleted == 0 { //if any goes wrong
			c.JSON(http.StatusUnauthorized, "unauthorized")
			return
		}

		deleted, delErr = utility.RedisDelete(userAgent + "-" + claims["user_id"].(string) + "-" + claims["access_uuid"].(string))
		if delErr != nil || deleted == 0 { //if any goes wrong
			c.JSON(http.StatusUnauthorized, "unauthorized")
			return
		}
		//Create new pairs of refresh and access tokens
		ts, createErr := auth.CreateToken(int(userId), fmt.Sprintf("%v", claims["type"]), false)
		if createErr != nil {
			c.JSON(http.StatusForbidden, createErr.Error())
			return
		}
		//save the tokens metadata to redis
		saveErr := auth.CreateAccessRecord(int(userId), ts, c)
		if saveErr != nil {
			c.JSON(http.StatusForbidden, saveErr.Error())
			return
		}
		tokens := dto.AuthLoginResponse{
			AccessToken:  ts.AccessToken,
			RefreshToken: ts.RefreshToken,
		}
		c.JSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", tokens))
	} else {
		c.JSON(http.StatusUnauthorized, response.BuildErrorResponse(http.StatusUnauthorized, "error", "refresh expired", nil, nil))
	}
}

func (ctrl *Controller) CheckToken(c *gin.Context) {
	tokenStr := auth.ExtractToken(c)
	userAgent := auth.GetUserAgent(c)
	if tokenStr == "" {
		c.JSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, fmt.Sprint(http.StatusUnauthorized), "Unauthorized", noToken))
		return
	}

	token, err := auth.TokenValid(tokenStr)
	if err != nil {
		c.JSON(http.StatusOK, false)
		return
	}
	claims, ok := token.Claims.(jwt.MapClaims) //the token claims should conform to MapClaims
	if ok && token.Valid {
		accessUuid, ok := claims["access_uuid"].(string) //convert the interface to string
		if !ok {
			c.AbortWithStatusJSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", err))
			return
		}

		authoriseStatus, ok := claims["authorised"].(bool) //check if token is authorised for middleware
		if !ok && !authoriseStatus {
			c.AbortWithStatusJSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", false))
			return
		}

		universalStatus, ok := claims["universal_access"].(bool) //check if token is authorised for middleware
		if ok && universalStatus {
			c.AbortWithStatusJSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", true))
			return
		}

		_, err := auth.FetchAuth(userAgent + "-" + claims["user_id"].(string) + "-" + accessUuid)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", false))
			return
		}

		c.AbortWithStatusJSON(http.StatusOK, response.BuildResponse(http.StatusOK, "success", true))
		return
	}
	c.JSON(http.StatusOK, false)
}
