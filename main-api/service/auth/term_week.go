package auth

import (
	"fmt"
	"github.com/gradely/gradely-backend/model"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/jmoiron/sqlx"
	"log"
	"strconv"
	"strings"
	"time"
)

func ValidateSession(session string) error {
	sub := strings.Split(session, "-")
	if len(sub) != 2 {
		return fmt.Errorf("wrong session format, try : 2021-2022")
	}
	_, err := strconv.Atoi(sub[0])
	if err != nil {
		return fmt.Errorf("wrong session format, try : 2021-2022")
	}

	_, err = strconv.Atoi(sub[1])
	if err != nil {
		return fmt.Errorf("wrong session format, try : 2021-2022")
	}
	return nil
}

func GetSessionTermAndWeek(userID int, session string, db *sqlx.DB) (model.TermWeek, error) {
	type termweek struct {
		Term  response.NullString `db:"term" json:"term"`
		Start response.NullInt64  `db:"start" json:"start"`
		End   response.NullInt64  `db:"end" json:"end"`
	}
	if err := ValidateSession(session); err != nil {
		return model.TermWeek{}, err
	}

	userType := ""
	if err := db.Get(&userType, "SELECT type FROM user WHERE id="+strconv.Itoa(userID)); err != nil {
		return model.TermWeek{}, err
	}

	schoolID, err := GetSchoolIDforTermWeek(userID, userType, db)
	if err != nil {
		fmt.Println(err)
	}

	generalInfo, schoolInfo := termweek{}, termweek{}
	sourceQuery := `
	SELECT 
		IF(CURDATE() > DATE(sc.first_term_start)
				AND CURDATE() < DATE(sc.first_term_end),
			'first',
			IF(CURDATE() > DATE(sc.second_term_start)
					AND CURDATE() < DATE(sc.second_term_end),
				'second',
				IF(CURDATE() > DATE(sc.third_term_start)
						AND CURDATE() < DATE(sc.third_term_end),
					'third',
					'neither'))) as term,
		IF(CURDATE() > DATE(sc.first_term_start)
				AND CURDATE() < DATE(sc.first_term_end),
			UNIX_TIMESTAMP(sc.first_term_start),
			IF(CURDATE() > DATE(sc.second_term_start)
					AND CURDATE() < DATE(sc.second_term_end),
				UNIX_TIMESTAMP(sc.second_term_start),
				IF(CURDATE() > DATE(sc.third_term_start)
						AND CURDATE() < DATE(sc.third_term_end),
					UNIX_TIMESTAMP(sc.third_term_start),
					0))) as start,
		IF(CURDATE() > DATE(sc.first_term_start)
				AND CURDATE() < DATE(sc.first_term_end),
			UNIX_TIMESTAMP(sc.first_term_end),
			IF(CURDATE() > DATE(sc.second_term_start)
					AND CURDATE() < DATE(sc.second_term_end),
				UNIX_TIMESTAMP(sc.second_term_end),
				IF(CURDATE() > DATE(sc.third_term_start)
						AND CURDATE() < DATE(sc.third_term_end),
					UNIX_TIMESTAMP(sc.third_term_end),
					0))) as end
		
	FROM
		academy_calendar sc
	WHERE
		sc.session='` + session + `'
	`

	if schoolID != 0 {
		schoolQuery := `
	SELECT 
		IF(CURDATE() > DATE(sc.first_term_start)
				AND CURDATE() < DATE(sc.first_term_end),
			'first',
			IF(CURDATE() > DATE(sc.second_term_start)
					AND CURDATE() < DATE(sc.second_term_end),
				'second',
				IF(CURDATE() > DATE(sc.third_term_start)
						AND CURDATE() < DATE(sc.third_term_end),
					'third',
					'neither'))) as term,
		IF(CURDATE() > DATE(sc.first_term_start)
				AND CURDATE() < DATE(sc.first_term_end),
			UNIX_TIMESTAMP(sc.first_term_start),
			IF(CURDATE() > DATE(sc.second_term_start)
					AND CURDATE() < DATE(sc.second_term_end),
				UNIX_TIMESTAMP(sc.second_term_start),
				IF(CURDATE() > DATE(sc.third_term_start)
						AND CURDATE() < DATE(sc.third_term_end),
					UNIX_TIMESTAMP(sc.third_term_start),
					0))) as start,
		IF(CURDATE() > DATE(sc.first_term_start)
				AND CURDATE() < DATE(sc.first_term_end),
			UNIX_TIMESTAMP(sc.first_term_end),
			IF(CURDATE() > DATE(sc.second_term_start)
					AND CURDATE() < DATE(sc.second_term_end),
				UNIX_TIMESTAMP(sc.second_term_end),
				IF(CURDATE() > DATE(sc.third_term_start)
						AND CURDATE() < DATE(sc.third_term_end),
					UNIX_TIMESTAMP(sc.third_term_end),
					0))) as end
		
	FROM
		school_calendar sc
	WHERE
		sc.school_id = ` + strconv.Itoa(schoolID) + `
	`

		err = db.Get(&schoolInfo, schoolQuery)
		if err != nil {
			fmt.Println(err)
		}
	}

	fmt.Println(sourceQuery)
	err = db.Get(&generalInfo, sourceQuery)
	if err != nil {
		fmt.Println(err)
	}

	if schoolInfo.Term.String != "" && schoolInfo.Term.String != "neither" {
		week := GetWeek(int(schoolInfo.Start.Int64))
		return model.TermWeek{
			Term:    schoolInfo.Term.String,
			Week:    week,
			Session: session,
		}, nil
	}

	if generalInfo.Term.String == "" || generalInfo.Term.String == "neither" {
		err = fmt.Errorf("source academic calendar info not up to date")
		fmt.Println(err)
		fmt.Println(err.Error())
		return model.TermWeek{}, err
	}

	week := GetWeek(int(generalInfo.Start.Int64))
	return model.TermWeek{
		Term:    generalInfo.Term.String,
		Week:    week,
		Session: session,
	}, nil
}

func GetWeek(termStart int) int {
	return int((time.Now().Unix() - int64(termStart)) / 604800)
}

func GetSchoolIDforTermWeek(userID int, userType string, db *sqlx.DB) (int, error) {
	schoolID := 0

	db.Get(&schoolID, "SELECT id FROM schools limit 1")
	if userType == "student" {
		sQuery := "SELECT school_id FROM student_school where student_id=" + strconv.Itoa(userID) + " limit 1"
		err := db.Get(&schoolID, sQuery)
		if err != nil {
			return 0, err
		}
		return schoolID, nil
	} else if userType == "teacher" {
		tQuery := "SELECT school_id FROM school_teachers where teacher_id=" + strconv.Itoa(userID) + " limit 1"
		err := db.Get(&schoolID, tQuery)
		if err != nil {
			return 0, err
		}
		return schoolID, nil
	} else if userType == "parent" {
		pQuery := "SELECT ss.school_id FROM parents pt left join student_school ss ON ss.student_id = pt.student_id WHERE pt.parent_id =" + strconv.Itoa(userID) + "  AND ss.school_id is NOT NULL limit 1"
		err := db.Get(&schoolID, pQuery)
		if err != nil {
			return 0, err
		}
		return schoolID, nil
	} else if userType == "school" {
		mySchool := MySchoolObject(userID, db)
		return mySchool.ID, nil
	} else {
		return schoolID, fmt.Errorf("invalid user type")
	}
}

func MySchoolObject(userId int, db *sqlx.DB) model.School {
	var fullStatus int
	fullStatus = 0
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
		fmt.Println(err)
		log.Fatalf("error checking if row exists  %v", err)
	}
	return school
}
