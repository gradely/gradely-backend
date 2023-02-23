package router

import (
	"github.com/gin-contrib/gzip"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/pkg/middleware"
	"github.com/jmoiron/sqlx"
	"net/http"
)

// Setup function initializes and returns a gin Engine with necessary middlewares and routes.
func Setup(db *sqlx.DB, validate *validator.Validate) *gin.Engine {
	// Create a new gin engine.
	r := gin.New()

	// Add necessary middlewares.
	r.Use(gin.Logger())                       // Logs incoming HTTP requests.
	r.Use(gin.Recovery())                     // Recovers from any panics and returns a 500 error.
	r.Use(middleware.CORS())                  // Adds CORS headers to responses.
	r.Use(gzip.Gzip(gzip.DefaultCompression)) // Gzip compresses responses.
	r.Use(middleware.Security())              // Adds additional security headers.
	r.Use(middleware.MyLimit())               // Limits the number of incoming requests.
	middleware.InitSentryLogger()             // Initializes a Sentry logger.

	// Define the API version.
	apiVersion := "v1"

	// Register necessary routes.
	AuthUrl(r, db, validate, apiVersion)

	// Handle requests for unknown routes.
	r.NoRoute(func(c *gin.Context) {
		c.JSON(http.StatusNotFound, gin.H{
			"name":    "Not Found",
			"message": "Page not found.",
			"code":    0,
			"status":  http.StatusNotFound,
		})
	})

	// Return the gin engine.
	return r
}
