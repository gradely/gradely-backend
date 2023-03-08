package auth

import (
	"fmt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	"github.com/gradely/gradely-backend/pkg/database"
	"github.com/gradely/gradely-backend/utility"
	"github.com/jmoiron/sqlx"
	"strconv"
	"strings"
	"time"
)

// FindStudentWithCode retrieves student details based on the given student code
func FindStudentWithCode(code string) (*dto.FindStudentResponse, error) {
	// Get a database connection
	db := database.GetSqlxDb()

	// Create a struct to store the retrieved student details
	var user dto.FindStudentResponse

	// Construct a parameterized SQL query to retrieve the required student details
	query := `SELECT 
					us.id,
					us.code,
					us.email,
					us.firstname,
					us.lastname,
					us.phone,
					-- Use the COALESCE function to choose the first non-null value
					COALESCE(NULLIF(us.image, ''), -- Check if the image field is empty
						NULLIF(us.image LIKE '%http%', -- Check if the image field is already a URL
							CONCAT('https://live.gradely.ng/images/users/', us.image)
						)
					) image,
					us.type,
					sch.id school_id,
					sch.name school_name,
					cls.id class_id,
					cls.description class_name
				FROM
					users us
					-- Join the student_school table to get the student's school details
					LEFT JOIN student_school ss ON ss.student_id = us.id AND ss.status = 1 AND ss.is_active_class = 1 AND ss.current_class = 1
					-- Join the schools table to get the school's details
					LEFT JOIN schools sch ON sch.id = ss.school_id
					-- Join the global_class table to get the student's class details
					LEFT JOIN global_class cls ON cls.id = us.class
				WHERE
					-- Use a parameterized query to prevent SQL injection attacks
					us.code = ?
				LIMIT 1`

	// Execute the query and store the results in the user struct
	err := db.Get(&user, query, code)
	if err != nil {
		// Return any errors encountered during query execution
		return nil, err
	}

	if user.ID == 0 {
		// If no user is found with the given code, return a nil response
		return nil, nil
	}

	// Return the retrieved user struct
	return &user, nil
}

// ConnectToStudent connects a parent to a student by creating a record in the parents table
func (util *serviceAuth) ConnectToStudent(studentID int, relationship string, user *dto.UserIdentity) error {
	// Get a database connection
	db := database.GetSqlxDb()

	// Retrieve the student details using the FindByID function
	student, err := FindByID(studentID)
	if err != nil {
		return err
	}

	// Verify that the retrieved user is a student
	if student.Type != "student" {
		return fmt.Errorf("user with ID %d is not a student", studentID)
	}

	// Check if a record already exists in the parents table for the given parent and student
	exists := utility.CheckExist(db, `SELECT id FROM parents WHERE parent_id=? AND student_id=? AND status=1`, user.ID, studentID)
	if exists || studentID == user.ID {
		// If a record already exists or the student ID is the same as the parent ID, return without creating a new record
		return nil
	}

	// Insert a new record in the parents table with the given parent and student IDs, relationship, and status
	insertQuery := `INSERT INTO parents (parent_id, student_id, status, role) VALUES (?, ?, 1, ?)`
	_, err = db.Exec(insertQuery, user.ID, studentID, relationship)
	if err != nil {
		return err
	}

	// Return nil to indicate success
	return nil
}

func (util *serviceAuth) AddChild(firstname, lastname string, class int, relationship string, user *dto.UserIdentity) (dto.UserRelationsResponse, error) {
	db := database.GetSqlxDb()
	child := dto.UserRelationsResponse{}

	// Get the current user's password hash
	var currentUserHash string
	err := db.Get(&currentUserHash, `SELECT password_hash FROM users WHERE id = ?`, user.ID)
	if err != nil {
		return child, err
	}

	// Insert the child user into the database
	insertUser := `
		INSERT INTO users (firstname, lastname, type, password_hash, class)
		VALUES (?, ?, 'student', ?, ?)`
	tx, err := db.Exec(insertUser, firstname, lastname, currentUserHash, class)
	if err != nil {
		return child, err
	}
	childID, err := tx.LastInsertId()
	if err != nil {
		return child, err
	}

	// Generate and update the child user's code
	childCode := util.GenerateUserCode(int(childID))
	updateUser := `UPDATE users SET code = ? WHERE id = ?`
	_, err = db.Exec(updateUser, childCode, childID)
	if err != nil {
		return child, err
	}

	// Get the child user's information
	query := `
		SELECT
			us.id,
			us.code,
			us.email,
			us.firstname,
			us.lastname,
			us.phone,
			COALESCE(
				us.image,
				CONCAT('https://live.gradely.ng/images/users/', us.image)
			) image,
			us.type,
			us.class class_id
		FROM
			users us
		WHERE
			us.id = ?`
	err = db.Get(&child, query, childID)
	if err != nil {
		return child, err
	}

	// Connect the child user to the current user
	err = util.ConnectToStudent(int(childID), relationship, user)
	if err != nil {
		return child, err
	}

	return child, nil
}

func (util *serviceAuth) GetStudentRelations(code, email, phone string, currentUser *dto.UserIdentity) ([]dto.UserRelationsResponse, error) {
	var (
		db    = database.GetSqlxDb()
		users []dto.UserRelationsResponse
		user  model.User
	)

	if code != "" {
		user, _ = util.FindByCredentials(code)
	} else if email != "" {
		user, _ = util.FindByCredentials(email)
	} else if phone != "" {
		user, _ = util.FindByCredentials(phone)
	}

	if code == "" && email == "" && phone == "" {
		relations, err := GetAllStudentRelations(db, currentUser.ID, string(currentUser.Type))
		if err != nil {
			return users, err
		}
		users = append(users, relations...)
	} else {
		if user.Type == "student" {
			users = append(users, dto.UserRelationsResponse{
				ID:        user.ID,
				Code:      user.Code,
				Firstname: user.Firstname,
				Lastname:  user.Lastname,
				Phone:     user.Phone,
				Image:     user.Image,
				Type:      user.Type,
				Email:     user.Email,
				ClassID:   user.Class,
			})
		}
	}

	return users, nil
}

func (util *serviceAuth) GenerateUserCode(userID int) string {
	le := 4 - len(strconv.Itoa(userID))
	if le > 4 || le < 1 {
		le = 0
	}
	id := strings.Repeat("0", le) + strconv.Itoa(userID)

	randChar := strings.ToUpper(utility.GenerateLetters(3))
	year := strconv.Itoa(time.Now().Year())

	return randChar + `/` + year + `/` + id
}

func (util *serviceAuth) FindByCredentials(email string) (model.User, error) {
	user := model.User{}
	base := database.GetSqlxDb()

	// Check if email is a valid phone number
	if number, err := utility.ValidateNumber(email); err == nil {
		// Use the phone number to search for the user
		query := `SELECT id, code, email, firstname, lastname, phone, IF(image LIKE '%http%', image, CONCAT('https://live.gradely.ng/images/users/', image)) image, class, is_boarded, verification_status, password_hash, type
				  FROM users
				  WHERE status != 0 AND (phone=? OR code=?)`
		err := base.Get(&user, query, number, email)
		if err != nil {
			return user, err
		}
	} else {
		// Use the email to search for the user
		query := `SELECT id, code, email, firstname, lastname, phone, IF(image LIKE '%http%', image, CONCAT('https://live.gradely.ng/images/users/', image)) image, class, is_boarded, verification_status, password_hash, type
				  FROM users
				  WHERE status != 0 AND email=?`
		err := base.Get(&user, query, email)
		if err != nil {
			return user, err
		}
	}

	return user, nil
}

// GetAllStudentRelations returns a list of students that a user is related to, based on their userType
func GetAllStudentRelations(db *sqlx.DB, currentID int, userType string) ([]dto.UserRelationsResponse, error) {
	var relations []dto.UserRelationsResponse

	// Define the query to be executed based on userType
	var query string
	switch userType {
	case "parent":
		query = `
			SELECT
				distinct us.id,
				us.code,
				us.email,
				us.firstname,
				us.lastname,
				us.phone,
				IFNULL(NULLIF(us.image, ''),
					CONCAT('https://live.gradely.ng/images/users/', us.image)) image,
				us.type,
				us.class class_id
			FROM parents pr
			LEFT JOIN users us ON us.id = pr.student_id
			WHERE pr.parent_id = ?
		`
	case "student":
		query = `
			SELECT
				distinct us.id,
				us.code,
				us.email,
				us.firstname,
				us.lastname,
				us.phone,
				IFNULL(NULLIF(us.image, ''),
					CONCAT('https://live.gradely.ng/images/users/', us.image)) image,
				us.type,
				us.class class_id
			FROM users st
			LEFT JOIN parents pr ON pr.student_id = st.id
			LEFT JOIN parents prr ON prr.parent_id = st.id
			LEFT JOIN parents pr2 ON pr.parent_id = pr2.parent_id
			LEFT JOIN users us ON us.id = pr2.student_id OR us.id=prr.student_id
			WHERE st.id = ? AND us.id != ?
		`
	default:
		return relations, fmt.Errorf("invalid userType: %s", userType)
	}

	// Execute the query and scan the results into a slice of UserRelationsResponse
	rows, err := db.Queryx(query, currentID, currentID)
	if err != nil {
		return relations, err
	}
	defer rows.Close()

	for rows.Next() {
		var p dto.UserRelationsResponse
		if err := rows.StructScan(&p); err != nil {
			fmt.Println(err)
			continue
		}
		relations = append(relations, p)
	}

	if err := rows.Err(); err != nil {
		return relations, err
	}

	return relations, nil
}
