package database

import (
	"database/sql"
	"fmt"
	"github.com/ory/dockertest/v3"
	"log"
	"testing"
	"time"
)

var db *sql.DB

func TestSetupMigrations(t *testing.T) {
	pool, err := dockertest.NewPool("")
	if err != nil {
		log.Fatalf("failed to create Docker pool: %v", err)
	}
	pool.MaxWait = time.Minute * 2

	// uses pool to try to connect to Docker
	err = pool.Client.Ping()
	if err != nil {
		log.Fatalf("Could not connect to Docker: %s", err)
	}

	// Set up a MySQL container
	resource, err := pool.Run("mysql", "8.0", []string{"MYSQL_ROOT_PASSWORD=secret"})
	if err != nil {
		log.Fatalf("failed to start MySQL container: %v", err)
	}

	// Wait for the MySQL container to start up
	if err := pool.Retry(func() error {
		db, err = sql.Open("mysql", fmt.Sprintf("root:secret@tcp(localhost:%s)/mysql?parseTime=true&charset=utf8mb4&multiStatements=true", resource.GetPort("3306/tcp")))
		if err != nil {
			return err
		}
		return db.Ping()
	}); err != nil {
		log.Fatalf("failed to connect to MySQL container: %v", err)
	}

	// set foreign_key_checks=0
	_, err = db.Exec("SHOW ENGINE INNODB STATUS; SET FOREIGN_KEY_CHECKS=0")
	if err != nil {
		t.Fatal(err)
	}

	SetupMigrations(db, "../../db/migration")

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

//
//func TestSetupMigrationsInvalidInput(t *testing.T) {
//	// Set up a test database
//	//db, err := sql.Open("mysql", "testuser:testpass@tcp(localhost:3306)/testdb")
//	if err != nil {
//		t.Fatalf("failed to connect to test database: %v", err)
//	}
//	defer db.Close()
//
//	// Call the function with an invalid input
//	SetupMigrations(nil)
//
//	// Check that the function panics
//	// Here you can add some assertions to check that the panic message is as expected
//}
//
//func TestSetupMigrationsAlreadyRun(t *testing.T) {
//	// Set up a test database
//	db, err := sql.Open("mysql", "testuser:testpass@tcp(localhost:3306)/testdb")
//	if err != nil {
//		t.Fatalf("failed to connect to test database: %v", err)
//	}
//	defer db.Close()
//
//	// Run the migrations
//	SetupMigrations(db)
//
//	// Run the migrations again
//	SetupMigrations(db)
//
//	// Check that the second call to the function didn't result in any changes
//	// Here you can add some assertions to check that the migration version didn't change
//}
