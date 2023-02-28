package database

import (
	"database/sql"
	"github.com/jmoiron/sqlx"
	"testing"
)

var db *sqlx.DB

func init() {
	MockDatabase()
	db = GetSqlxDb()

}

func TestSetupMigrations(t *testing.T) {
	_, err = db.Exec("SHOW ENGINE INNODB STATUS; SET FOREIGN_KEY_CHECKS=0")
	if err != nil {
		t.Fatal(err)
	}

	SetupMigrations(db.DB, "../../db/migration")

	rows, err := db.Query("SHOW TABLES")
	if err != nil {
		t.Fatal(err)
	}
	defer func(rows *sql.Rows) {
		err := rows.Close()
		if err != nil {
			panic(err)
		}
	}(rows)
	var tables []string
	for rows.Next() {
		var table string
		if err := rows.Scan(&table); err != nil {
			panic(err)
		}
		tables = append(tables, table)
	}
	if err := rows.Err(); err != nil {
		panic(err)
	}

	if len(tables) < 1 {
		t.Fatal("expected more than 1 table, got ", len(tables))
	}
}
