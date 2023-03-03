package middleware

import (
	"github.com/didip/tollbooth"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/jmoiron/sqlx"
	"net/http"
	"strconv"
	"strings"
)

var (
	invalidToken = "Your request was made with invalid credentials."
	noToken      = "Token could not be found!"
)
var MyIdentity *dto.UserIdentity

type connection struct {
	connection *sqlx.DB
}

type authParams struct {
	userType model.UserType
}

// CORS middleware
func CORS() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Allow requests from all domains
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")

		// Allow credentials to be sent
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")

		// Allow these headers to be sent
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")

		// Allow these HTTP methods to be used
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		// If it's an OPTIONS request, return a 204 status code and exit
		if c.Request.Method == http.MethodOptions {
			c.AbortWithStatus(http.StatusNoContent)
			return
		}

		// Call the next handler
		c.Next()
	}
}

// MyLimit middleware
func MyLimit() gin.HandlerFunc {
	// Get the server's rate limit configuration
	getConfig := config.GetConfig()

	// Create a new rate limiter
	limiter := tollbooth.NewLimiter(getConfig.Server.LimitCountPerRequest, nil)

	return func(c *gin.Context) {
		// Check if the request should be rate-limited
		httpError := tollbooth.LimitByRequest(limiter, c.Writer, c.Request)

		// If the request should be rate-limited, return an error response
		if httpError != nil {
			c.AbortWithStatusJSON(httpError.StatusCode, response.UnauthorisedResponse(httpError.StatusCode, httpError.Message, "Unauthorized", invalidToken))
			return
		}

		// Call the next handler
		c.Next()
	}
}

// Security middleware
func Security() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Set various security headers

		// X-XSS-Protection
		c.Writer.Header().Set("X-XSS-Protection", "1; mode=block")

		// HTTP Strict Transport Security
		c.Writer.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload")

		// X-Frame-Options
		c.Writer.Header().Set("X-Frame-Options", "SAMEORIGIN")

		// X-Content-Type-Options
		c.Writer.Header().Set("X-Content-Type-Options", "nosniff")

		// Content Security Policy
		c.Writer.Header().Set("Content-Security-Policy", "default-src 'self';")

		// X-Permitted-Cross-Domain-Policies
		c.Writer.Header().Set("X-Permitted-Cross-Domain-Policies", "none")

		// Referrer-Policy
		c.Writer.Header().Set("Referrer-Policy", "no-referrer")

		// Feature-Policy
		c.Writer.Header().Set("Feature-Policy", "microphone 'none'; camera 'none'")

		// If it's an OPTIONS request, return a 204 status code and exit
		if c.Request.Method == http.MethodOptions {
			c.AbortWithStatus(http.StatusNoContent)
			return
		}

		// Call the next handler
		c.Next()
	}
}

// Authorize is a middleware function that checks if the user is authorized to access the endpoint.
func Authorize(connection *sqlx.DB, userTypes ...model.UserType) gin.HandlerFunc {
	return func(c *gin.Context) {
		userAgent := auth.GetUserAgent(c)

		bearerToken := c.GetHeader("Authorization")
		if bearerToken == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "No token provided", noToken))
			return
		}

		tokenStr := strings.TrimPrefix(bearerToken, "Bearer ")
		if tokenStr == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Invalid token format", invalidToken))
			return
		}

		token, err := auth.TokenValid(tokenStr)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Invalid token", invalidToken))
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Invalid token claims", invalidToken))
			return
		}

		activeUserType, ok := claims["type"].(string)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Missing user type", invalidToken))
			return
		}

		userID, ok := claims["user_id"].(string)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Missing user ID", invalidToken))
			return
		}

		accessUUID, ok := claims["access_uuid"].(string)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Missing access UUID", invalidToken))
			return
		}

		// Check universal access
		if universalAccess, ok := claims["universal_access"].(bool); ok && universalAccess {
			// Universal access token
		} else {
			// Check user authentication
			authUserAgent := userAgent + "-" + userID + "-" + accessUUID
			userId, err := auth.FetchAuth(authUserAgent)
			if err != nil || userId != userID {
				c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Invalid user authentication", invalidToken))
				return
			}
		}

		// Check authorized status
		if authorized, ok := claims["authorised"].(bool); !ok || !authorized {
			c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Not authorized", invalidToken))
			return
		}

		// Check user type authorization
		if len(userTypes) > 0 {
			var authorized bool
			for _, userType := range userTypes {
				if userType == model.UserType(activeUserType) {
					authorized = true
					break
				}
			}
			if !authorized {
				c.AbortWithStatusJSON(http.StatusUnauthorized, response.UnauthorisedResponse(http.StatusUnauthorized, "Unauthorized", "Not authorized for user type", invalidToken))
				return
			}
		}

		userId, _ := strconv.Atoi(userID)
		MyIdentity = &dto.UserIdentity{
			ID:   userId,
			Type: model.UserType(activeUserType),
		}
	}
}
