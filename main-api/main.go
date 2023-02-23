package main

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/gradely/gradely-backend/pkg/database"
	"github.com/gradely/gradely-backend/pkg/router"
	"github.com/jmoiron/sqlx"
	"log"
)

func init() {
	config.Setup()
	database.Setup()
	database.SetupRedis()
}

func main() {
	// Load configuration settings from file
	getConfig := config.GetConfig()

	// Connect to database
	db := database.GetSqlxDb()

	defer func(db *sqlx.DB) {
		err := db.Close()
		if err != nil {

		}
	}(db) // Close database connection when main function exits

	// Initialize validator for request data validation
	validatorRef := validator.New()

	// Setup router with database and validator instances injected as dependencies
	r := router.Setup(db, validatorRef)

	// Start the HTTP server
	address := fmt.Sprintf(":%s", getConfig.Server.Port)
	log.Printf("Server is starting at %s", address)
	if err := r.Run(address); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
