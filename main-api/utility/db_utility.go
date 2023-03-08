package utility

import (
	"database/sql"
	"fmt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/pkg/database"
	"github.com/jmoiron/sqlx"
	"log"
)

func CheckExist(db *sqlx.DB, query string, args ...interface{}) bool {
	var exists bool
	query = fmt.Sprintf("SELECT exists (%s)", query)
	err := db.QueryRow(query, args...).Scan(&exists)
	if err != nil && err != sql.ErrNoRows {
		LogErrorSentry(err)
		log.Fatalf("error checking if row exists '%s' %v", args, err)
	}
	return exists
}

func MySchoolObject(userId, completeSchoolObject int) model.School {
	db := database.GetSqlxDb()
	fullQuery := `schools.id, schools.user_id, name, slug, logo, basic_subscription, premium_subscription, subscription_expiry, state, country`
	if completeSchoolObject == 1 {
		fullQuery = `schools.*`
	}

	query := `SELECT ` + fullQuery + ` FROM schools
	LEFT JOIN school_admin ON school_admin.school_id = schools.id
	where schools.user_id = ? OR school_admin.user_id = ?
	ORDER BY schools.id DESC, school_admin.id DESC
	LIMIT 1`

	var school model.School
	err := db.QueryRowx(query, userId, userId).StructScan(&school)

	if err != nil {
		LogErrorSentry(err)
		return model.School{}
	}
	return school
}

func SchoolStudentSubscriptionDetails(school model.School) interface{} {
	query := `SELECT
		  COUNT(CASE WHEN subscription_status = 'basic' THEN 1 END) as basicCount,
		  COUNT(CASE WHEN subscription_status = 'premium' THEN 1 END) as premiumCount
		FROM
		  student_school
		WHERE status = 1 AND is_active_class = 1 AND school_id = ?
		;`
	db := database.GetSqlxDb()
	var basicCount, premiumCount int
	err := db.QueryRowx(query, school.ID).Scan(&basicCount, &premiumCount)

	if err != nil {
		LogErrorSentry(err)
		log.Fatalf("error checking if row exists  %v", err)
	}

	return map[string]interface{}{
		"basic": map[string]interface{}{
			"total":     school.BasicSubscription,
			"used":      basicCount,
			"remaining": school.PremiumSubscription - basicCount,
		},
		"premium": map[string]interface{}{
			"total":     school.BasicSubscription,
			"used":      premiumCount,
			"remaining": school.PremiumSubscription - premiumCount,
		},
	}

}

func GetSchoolAdmin(db *sqlx.DB, adminID int) model.SchoolAdmin {
	return model.SchoolAdmin{}
}
