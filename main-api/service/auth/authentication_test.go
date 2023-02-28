package auth

import (
	"github.com/golang-jwt/jwt"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

var getConfig *config.Configuration

func init() {
	config.Setup("../../.env")
	getConfig = config.GetConfig()
}

func TestVerifyToken(t *testing.T) {

	// Set up the test data
	tokenString := "valid_token_string"

	// Create the token with the server secret
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": "1",
		"exp":     time.Now().Add(time.Hour).Unix(),
	})
	tokenString, err := token.SignedString([]byte(getConfig.Server.Secret))
	if err != nil {
		t.Errorf("Error creating token string: %v", err)
	}

	// Call the verifyToken function with the token string
	result, err := verifyToken(tokenString)

	// Check the result
	if err != nil {
		t.Errorf("Expected nil, but got error: %v", err)
	}
	if result == nil {
		t.Errorf("Expected token, but got nil")
	}
}

func TestTokenValid(t *testing.T) {
	// generate a valid JWT token

	token := jwt.New(jwt.SigningMethodHS256)
	token.Claims = jwt.MapClaims{
		"user_id": "1",
		"exp":     time.Now().Add(time.Hour).Unix(),
	}
	tokenString, err := token.SignedString([]byte(getConfig.Server.Secret))
	if err != nil {
		t.Errorf("Error creating token string: %v", err)
	}
	// call TokenValid with valid token
	validToken, err := TokenValid(tokenString)

	// assert valid token and no error returned
	assert.NotNil(t, validToken)
	assert.Nil(t, err)

	// call TokenValid with invalid token
	invalidToken, err := TokenValid("Bearer invalid_token")

	// assert nil token and error returned
	assert.Nil(t, invalidToken)
	assert.NotNil(t, err)
}
