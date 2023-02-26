package database

import (
	"database/sql"
	"fmt"
	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/mysql"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/jmoiron/sqlx"
	"log"
)

var (
	Db  *sqlx.DB
	err error
)

func Setup() {
	getConfig := config.GetConfig()

	database := getConfig.Database.DatabaseName
	username := getConfig.Database.DatabaseUsername
	password := getConfig.Database.DatabasePassword
	host := getConfig.Database.DatabaseHost
	port := getConfig.Database.DatabasePort

	conStr := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4&multiStatements=true", username, password, host, port, database)
	if err != nil {
		log.Fatalln(err)
	}

	sqlXDb, err := sqlx.Connect("mysql", conStr)
	if err != nil {
		log.Fatalln("Database connection error: ", err)
	}

	// Ping database to check if connection is alive
	if err := sqlXDb.Ping(); err != nil {
		log.Fatalln("Database is not alive: ", err)
	}

	// Setup migrations for the database
	SetupMigrations(sqlXDb.DB, "db/migration")

	// Auto migrate project models
	Db = sqlXDb
}

// SetupMigrations setup migrations for the database
func SetupMigrations(db *sql.DB, migrationsPath string) {
	// Create a new instance of the MySQL driver
	driver, err := mysql.WithInstance(db, &mysql.Config{})
	if err != nil {
		panic(err)
	}

	// Create a new migration instance
	m, err := migrate.NewWithDatabaseInstance(fmt.Sprintf("file://%s", migrationsPath), "mysql", driver)
	if err != nil {
		panic(err)
	}

	// Run the migrations
	if err := m.Up(); err != nil && err != migrate.ErrNoChange {
		panic(err)
	}

	// Print the current migration version
	version, dirty, err := m.Version()
	if err != nil {
		panic(err)
	}
	fmt.Printf("Current migration version: %v, dirty: %v\n", version, dirty)

	// Close the database connection
	if err := db.Close(); err != nil {
		panic(err)
	}
}

func GetSqlxDb() *sqlx.DB {
	return Db
}
