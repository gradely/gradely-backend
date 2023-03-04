package utility

import (
	"database/sql"
	"fmt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/pkg/database"
	"github.com/gradely/gradely-backend/pkg/middleware"
	"github.com/gradely/gradely-backend/repository"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/jmoiron/sqlx"
	"log"
	"strconv"
)

type Controller struct {
	Db *sqlx.DB
}
type Util struct {
	Repo repository.Repository
}

func Identity() *model.User {
	db := database.GetSqlxDb()
	userModel, err := auth.GetUserByID(db, strconv.Itoa(middleware.MyIdentity.ID))
	if err != nil {
		log.Println(err)
		middleware.LogErrorSentry(err)
		panic("Not validated")
	}
	return userModel

}

func (util Util) CheckExist(db *sqlx.DB, query string, args ...interface{}) bool {
	var exists bool
	query = fmt.Sprintf("SELECT exists (%s)", query)
	err := db.QueryRow(query, args...).Scan(&exists)
	if err != nil && err != sql.ErrNoRows {
		middleware.LogErrorSentry(err)
		log.Fatalf("error checking if row exists '%s' %v", args, err)
	}
	return exists
}

func MySchoolObject(args ...int) model.School {
	var userId, fullStatus int

	if args == nil {
		userId = middleware.MyIdentity.ID
		fullStatus = 0
	} else {
		fullStatus = args[1]
		userId = args[0]
	}

	db := database.GetSqlxDb()
	fullQuery := `schools.id, schools.user_id, name, slug, logo, basic_subscription, premium_subscription, subscription_expiry, state, country`
	if fullStatus == 1 {
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
		middleware.LogErrorSentry(err)
		//log.Fatalf("error checking if row exists  %v", err)
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
		middleware.LogErrorSentry(err)
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
