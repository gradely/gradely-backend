package database

import (
	"fmt"
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

	conStr := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4", username, password, host, port, database)
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

	// Auto migrate project models
	Db = sqlXDb
}

func GetSqlxDb() *sqlx.DB {
	return Db
}
