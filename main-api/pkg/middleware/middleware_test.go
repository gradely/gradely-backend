package middleware

import (
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/gradely/gradely-backend/pkg/database"
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"
)

func TestAuthorize(t *testing.T) {
	config.Setup("../../.env")
	database.MockDatabase()
	db := database.GetSqlxDb()
	getConfig := config.GetConfig()
	database.SetupRedis()

	// Create a fake JWT token for testing
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"type":             "teacher",
		"user_id":          "1",
		"access_uuid":      "1234567890",
		"universal_access": true,
		"authorized":       true,
	})

	// Sign the token with a secret key
	tokenString, err := token.SignedString([]byte(getConfig.Server.Secret))
	if err != nil {
		t.Errorf("Failed to sign token: %v", err)
	}

	// Create a fake Gin context for testing
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/", nil)
	req.Header.Set("Authorization", "Bearer "+tokenString)
	c, _ := gin.CreateTestContext(w)
	c.Request = req

	// Call the authorize middleware with an authorized user type
	Authorize(db, model.UserTypeTeacher)(c)

	// Assert that the middleware has set the correct user identity
	expectedUserIdentity := &dto.UserIdentity{
		ID:   1,
		Type: model.UserTypeTeacher,
	}
	if !reflect.DeepEqual(MyIdentity, expectedUserIdentity) {
		t.Errorf("Authorize middleware did not set the expected user identity. Got %v, expected %v", MyIdentity, expectedUserIdentity)
	}

	// Call the authorize middleware with an unauthorized user type
	w = httptest.NewRecorder()
	req, _ = http.NewRequest("GET", "/", nil)
	req.Header.Set("Authorization", "Bearer ")
	c, _ = gin.CreateTestContext(w)
	c.Request = req
	Authorize(db, model.UserTypeTeacher)(c)

	// Assert that the middleware has returned a 401 Unauthorized response
	if w.Code != http.StatusUnauthorized {
		t.Errorf("Authorize middleware did not return a 401 Unauthorized response for unauthorized user type. Got %d, expected %d", w.Code, http.StatusUnauthorized)
	}
}
