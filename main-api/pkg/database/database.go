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

	database := getConfig.Database.Dbname
	username := getConfig.Database.Username
	password := getConfig.Database.Password
	host := getConfig.Database.Host
	port := getConfig.Database.Port

	conStr := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4", username, password, host, port, database)
	if err != nil {
		log.Fatalln(err)
	}

	sqlXDb, err := sqlx.Connect("mysql", conStr)

	if err != nil {
		log.Fatalln("SQLX db error: ", err)
	}

	if err != nil {
		log.Fatalln("SQLX db error: ", err)
	}
	// Change this to true if you want to see SQL queries
	//db.LogMode(getConfig.Database.LogMode)

	// Auto migrate project models
	Db = sqlXDb
}

func GetSqlxDb() *sqlx.DB {
	return Db
}
