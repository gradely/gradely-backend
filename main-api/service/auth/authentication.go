package auth

import (
	"crypto/rand"
	"database/sql"
	"encoding/base64"
	"errors"
	"fmt"
	"github.com/getsentry/sentry-go"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/gradely/gradely-backend/model"
	"github.com/gradely/gradely-backend/model/dto"
	"github.com/gradely/gradely-backend/pkg/config"
	"github.com/gradely/gradely-backend/pkg/database"
	"github.com/jmoiron/sqlx"
	ua "github.com/mileusna/useragent"
	"github.com/twinj/uuid"
	"golang.org/x/crypto/bcrypt"
	mathRand "math/rand"
	"strconv"
	"strings"
	"time"
)

// Define the minimum length of a secure key
const minSecureKeyLength = 8

// Define an error for when a secure key is too short
var errShortSecureKey = errors.New("length of secure key does not meet minimum requirements")

// StagStr represents a string value that can be used to tag structs
type StagStr struct {
	Value string
}

// ValidateToken validates a user's token and updates the token's expiration time in the database
func ValidateToken(db *sqlx.DB, bearerToken string) (*model.User, error) {
	user, err := TokenVerification(db, bearerToken)
	if err != nil {
		// Return the user and error if the user was retrieved
		if user != nil {
			return user, err
		}
		// Otherwise, just return the error
		return nil, err
	}

	// Update the token and its expiration time in the database
	expires := user.TokenExpires.Time.Add(time.Minute * 1)
	if time.Now().Before(expires) {
		db.MustExec("UPDATE user SET token = ?, token_expires = ? WHERE token = ?;", user.Token, time.Now().AddDate(0, 4, 0), user.Token)
	} else {
		db.MustExec("UPDATE user SET token = ?, token_expires = ? WHERE token = ?;", sql.NullTime{}, sql.NullTime{}, user.Token)
	}
	return user, nil
}

// TokenVerification verifies a user's token and returns the user
func TokenVerification(db *sqlx.DB, tokenString string) (*model.User, error) {
	user := &model.User{}
	if err := db.Get(user, "SELECT id, username, code, firstname, lastname, phone, image, type, status, subscription_expiry, subscription_plan, created_at, updated_at, verification_token, token, is_boarded, mode, verification_status FROM users WHERE token = ?", tokenString); err != nil {
		return user, err
	}
	return user, nil
}

// GetUserByID finds a user by their ID and returns the user
func GetUserByID(db *sqlx.DB, id string) (*model.User, error) {
	user := &model.User{}
	if err := db.Get(user, "SELECT id, username, code, firstname, lastname, phone, image, type, status, subscription_expiry, subscription_plan, created_at, updated_at, verification_token, token, is_boarded, mode, verification_status FROM users WHERE id = ?", id); err != nil {
		return user, err
	}
	return user, nil
}

// GetUserByEmailOrPhone finds a user by their email or phone number and returns the user
func GetUserByEmailOrPhone(db *sqlx.DB, emailOrPhone string) (*model.User, error) {
	user := &model.User{}
	query := `
		SELECT id, code, email, firstname, lastname, phone, IF(image LIKE '%http%', image, CONCAT('https://live.gradely.ng/images/users/', image)) image,
		class, is_boarded, verification_status, password_hash, type 
		FROM users WHERE status != 0 AND (email=? OR phone=? OR code=?)`

	err := db.Get(user, query, emailOrPhone, emailOrPhone, emailOrPhone)
	if err != nil {
		return nil, err
	}

	return user, nil
}

// FindUserByID retrieves a user's data by ID.
func FindUserByID(id int) (model.User, error) {
	user := model.User{}
	base := database.GetSqlxDb()

	err := base.Get(&user, `SELECT id, code, email, firstname, lastname, phone, image, class, is_boarded, verification_status, type FROM users WHERE status != 0 AND id=?`, id)
	if err != nil {
		return user, fmt.Errorf("error while finding user: %w", err)
	}
	return user, nil
}

// FindUserAuthByID retrieves user authentication data by ID.
func FindUserAuthByID(id int, mySchool model.School, myIdentity dto.UserIdentity, schoolAdmin model.SchoolAdmin) (dto.UserAuthResponse, error) {
	user := dto.UserAuthResponse{}
	base := database.GetSqlxDb()

	err := base.Get(&user, `SELECT id, code, email, firstname, lastname, phone, image, class, is_boarded, verification_status, type FROM users WHERE status != 0 AND id=?`, id)
	if err != nil {
		return user, fmt.Errorf("error while finding user: %w", err)
	}

	globalClassID, _ := GetGlobalClassWithStudentID(base, id)
	user.Class = &globalClassID

	return GetUserObjectAuth(base, user, mySchool, myIdentity, schoolAdmin)
}

// GetGlobalClassWithStudentID retrieves a student's global class ID from the database.
func GetGlobalClassWithStudentID(db *sqlx.DB, childID int) (int, error) {
	var studentClassID int

	err := db.Get(&studentClassID, `SELECT cls.global_class_id FROM student_school ss left join classes cls on cls.id=ss.class_id  WHERE ss.student_id=?`, childID)
	if err != nil || studentClassID == 0 {
		err := db.Get(&studentClassID, `SELECT IFNULL(class, 0) FROM users WHERE id=?`, childID)
		if err != nil {
			return studentClassID, fmt.Errorf("error while getting global class: %w", err)
		}
	}

	return studentClassID, nil
}

// GetUserProfile retrieves a user's profile data by ID.
func GetUserProfile(id int) (dto.UserProfileResponse, error) {
	user := dto.UserProfileResponse{}
	base := database.GetSqlxDb()

	err := base.Get(&user, `SELECT user.id, code, email, firstname, lastname, phone, image, class, user.is_boarded, verification_status, type, p.id, p.user_id, p.dob, p.mob, p.yob, p.gender, p.address, p.city, p.state, p.country, p.about FROM users 
		LEFT JOIN user_profile p ON p.user_id = user.id
		WHERE status != 0 AND user.id=?`, id)
	if err != nil {
		return user, fmt.Errorf("error while getting user profile: %w", err)
	}

	if user.Dob != nil && user.Mob != nil && user.Yob != nil {
		dob := fmt.Sprintf("%v-%v-%v", *user.Dob, *user.Mob, *user.Yob)
		user.BirthDate = &dob
	}

	return user, nil
}

// GetUserObjectAuth function
func GetUserObjectAuth(base *sqlx.DB, user dto.UserAuthResponse, mySchool model.School, myIdentity dto.UserIdentity, schoolAdmin model.SchoolAdmin) (dto.UserAuthResponse, error) {
	// Instead of an if-else chain, use a switch statement to check the value of myIdentity.Type
	switch myIdentity.Type {
	case "school":
		var isOwner int // Declare the variable with the correct type
		var role string
		if mySchool.UserID == myIdentity.ID {
			isOwner = 1
			role = "Owner"
		} else {
			role = schoolAdmin.Level
		}

		// Update the fields of the user object
		user.SchoolID = mySchool.ID
		user.SchoolSlug = mySchool.Slug
		user.SchoolName = mySchool.Name
		user.Country = mySchool.Country
		user.State = mySchool.State
		user.SchoolOwner = isOwner
		user.Role = role

	case "student":
		var relationshipCount int
		err := base.Get(&relationshipCount, "SELECT COUNT(*) FROM parents WHERE student_id=? AND status = 1", myIdentity.ID)
		if err != nil {
			return user, err
		}

		// Update the field of the user object based on the relationshipCount value
		user.RelationshipStatus = 0
		if relationshipCount > 0 {
			user.RelationshipStatus = 1
		}

		// Update the HaveClass field of the user object
		err = base.Get(&user.HaveClass, "SELECT EXISTS (SELECT id FROM student_school WHERE student_id = ? AND status = 1 AND is_active_class = 1)", myIdentity.ID)
		if err != nil {
			LogErrorSentry(err)
		}

	case "parent":
		var relationshipCount int
		err := base.Get(&relationshipCount, "SELECT COUNT(*) FROM parents WHERE parent_id=? AND status = 1", myIdentity.ID)
		if err != nil {
			return user, err
		}

		// Update the field of the user object based on the relationshipCount value
		user.RelationshipStatus = 0
		if relationshipCount > 0 {
			user.RelationshipStatus = 1
		}

	case "teacher":
		// Update the IsTutor, IsTutorBoarded, and HaveClass fields of the user object
		err := base.Get(&user.IsTutor, "SELECT EXISTS (SELECT schools.id FROM schools INNER JOIN school_teachers st ON st.school_id = schools.id WHERE st.teacher_id = ? AND schools.is_tutor = 1)", myIdentity.ID)
		if err != nil {
			LogErrorSentry(err)
		}

		err = base.Get(&user.IsTutorBoarded, "SELECT EXISTS (SELECT id FROM tutor_profile WHERE tutor_id = ?)", myIdentity.ID)
		if err != nil {
			LogErrorSentry(err)
		}

		err = base.Get(&user.HaveClass, "SELECT EXISTS (SELECT id FROM teacher_class WHERE teacher_id = ? AND status = 1)", myIdentity.ID)
		if err != nil {
			LogErrorSentry(err)
		}
	}

	// Update the TermWeek field of the user object
	session, _ := GetCurrentSession()
	termWeek, err := GetSessionTermAndWeek(myIdentity.ID, session, base)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(session)
	user.TermWeek = termWeek

	return user, nil
}

// CreateToken function creates and returns access and refresh tokens
func CreateToken(userID int, userType string, universalAccess bool) (*dto.TokenDetailsDTO, error) {
	// Get the server configuration
	getConfig := config.GetConfig()

	// Create an empty TokenDetailsDTO object
	td := &dto.TokenDetailsDTO{}

	// Set access token expire time
	td.AtExpiresTime = time.Now().Add(time.Hour * time.Duration(getConfig.Server.AccessTokenExpireDuration))

	// Set refresh token expire time
	td.RtExpiresTime = time.Now().Add(time.Hour * time.Duration(getConfig.Server.RefreshTokenExpireDuration))

	// Generate a new UUID for access and refresh tokens
	td.AccessUuid = uuid.NewV4().String()
	td.RefreshUuid = uuid.NewV4().String()

	// Create access token claims
	userid := strconv.Itoa(userID)
	atClaims := jwt.MapClaims{}
	atClaims["type"] = userType
	atClaims["user_id"] = userid
	atClaims["access_uuid"] = td.AccessUuid
	atClaims["authorised"] = true
	atClaims["universal_access"] = universalAccess
	atClaims["exp"] = time.Now().AddDate(0, 0, 7).Unix() // Set token expiration time

	// Create a new JWT token with claims
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, atClaims)

	// Sign the access token with the server secret
	var err error
	td.AccessToken, err = token.SignedString([]byte(getConfig.Server.Secret))
	if err != nil {
		return nil, err
	}

	// Create refresh token claims
	rtClaims := jwt.MapClaims{}
	rtClaims["type"] = userType
	rtClaims["user_id"] = userid
	rtClaims["refresh_uuid"] = td.RefreshUuid
	rtClaims["access_uuid"] = td.AccessUuid
	rtClaims["universal_access"] = universalAccess
	rtClaims["exp"] = time.Now().AddDate(0, 4, 0).Unix() // Set token expiration time

	// Create a new JWT token with claims
	rtoken := jwt.NewWithClaims(jwt.SigningMethodHS256, rtClaims)

	// Sign the refresh token with the server secret
	td.RefreshToken, err = rtoken.SignedString([]byte(getConfig.Server.Secret))
	if err != nil {
		return nil, err
	}

	// Return the generated tokens
	return td, nil
}

// TokenValid function validates the JWT token
func TokenValid(bearerToken string) (*jwt.Token, error) {
	// Verify the JWT token
	token, err := verifyToken(bearerToken)
	if err != nil {
		if token != nil {
			return token, err
		}
		return nil, err
	}
	// Check if the token is valid
	if !token.Valid {
		return nil, fmt.Errorf("Unauthorized")
	}
	// Return the token if it's valid
	return token, nil
}

// verifyToken function verifies the JWT token
func verifyToken(tokenString string) (*jwt.Token, error) {
	// Get the server configuration
	getConfig := config.GetConfig()

	// Verify the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Check if the signing method is HMAC
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		// Return the server secret
		return []byte(getConfig.Server.Secret), nil
	})
	if err != nil {
		return token, fmt.Errorf("Unauthorized")
	}
	return token, nil
}

// FallbackInsecureKey fallback method for sercure key
func FallbackInsecureKey(length int) (string, error) {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()_+{}|<>?,./:"

	// check if the provided length is secure enough
	if err := CheckSecureKeyLen(length); err != nil {
		return "", err
	}

	// create a new random number generator with a seed based on the current time
	seededRand := mathRand.New(mathRand.NewSource(time.Now().UnixNano()))

	// create a byte slice to store the key
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}

	// return the key as a string
	return string(b), nil
}

// GenerateSecureKey generates a secure key of a given length
func GenerateSecureKey(length int) (string, error) {
	// create a byte slice to store the key
	key := make([]byte, length)

	// check if the provided length is secure enough
	if err := CheckSecureKeyLen(length); err != nil {
		return "", err
	}

	// fill the key with random bytes using the system's cryptographic random number generator
	_, err := rand.Read(key)
	if err != nil {
		// if the random number generator fails, generate a fallback insecure key instead
		return FallbackInsecureKey(length)
	}

	// encode the key as a base64 string and return it
	keyEnc := base64.StdEncoding.EncodeToString(key)
	return keyEnc, nil
}

// CheckSecureKeyLen checks if the provided length is secure enough
func CheckSecureKeyLen(length int) error {
	if length < minSecureKeyLength {
		return errShortSecureKey
	}
	return nil
}

// CheckPassword checks if the provided password matches the given hash, and whether it is a universal password
func CheckPassword(password, hash string, userType model.UserType) (bool, bool) {
	// compare the password with the hash using bcrypt
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	if err == nil {
		return true, false
	}

	// check if the password is a universal password
	if password == config.Params.MasterPassword {
		return false, true
	}

	return false, false
}

// CreateAccessRecord creates an access record in Redis with the provided userid, TokenDetailsDTO and Gin context.
// It extracts the user agent from the Gin context and uses it as a prefix for the Redis key.
// It also deletes any existing Redis keys with the same prefix.
func CreateAccessRecord(userid int, td *dto.TokenDetailsDTO, c *gin.Context) error {
	// Extract user agent from Gin context
	userAgent := GetUserAgent(c)
	// Use user agent and userid as key prefix
	keyPrefix := userAgent + "-" + strconv.Itoa(userid) + "-"
	// Delete any existing Redis keys with the same prefix
	err := DeleteExistingRedisKey(keyPrefix)
	if err != nil {
		return err
	}

	// Convert Unix timestamps to UTC Time objects
	at := time.Unix(td.AtExpiresTime.Unix(), 0)
	rt := time.Unix(td.RtExpiresTime.Unix(), 0)
	now := time.Now()

	// Get Redis client from database package
	rdb := database.GetRedisDb()

	// Set access and refresh tokens in Redis with expiration times
	errAccess := rdb.Set(database.Ctx, keyPrefix+td.AccessUuid, userid, at.Sub(now)).Err()
	if errAccess != nil {
		return errAccess
	}
	errRefresh := rdb.Set(database.Ctx, keyPrefix+td.RefreshUuid, userid, rt.Sub(now)).Err()
	if errRefresh != nil {
		return errRefresh
	}

	// Update user's token information in SQL database
	updateErr := UpdateV2Auth(td.AccessToken, strconv.Itoa(userid), true)
	if updateErr != nil {
		return updateErr
	}

	return nil
}

// ExtractToken extracts the token from the Authorization header in the Gin context.
func ExtractToken(c *gin.Context) string {
	bearToken := c.GetHeader("Authorization")
	strArr := strings.Split(bearToken, " ")
	if len(strArr) == 2 {
		return strArr[1]
	}
	return ""
}

// ExtractTokenMetadata extracts the access details (access token UUID and user ID) from the provided token string.
func ExtractTokenMetadata(tokenstr string) (*dto.AccessDetails, error) {
	// Verify JWT token and get claims
	token, err := verifyToken(tokenstr)
	if err != nil {
		return nil, err
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if ok && token.Valid {
		// Extract access UUID and user ID from claims
		accessUuid, ok := claims["access_uuid"].(string)
		if !ok {
			return nil, err
		}
		userId, err := strconv.ParseUint(fmt.Sprintf("%.f", claims["user_id"]), 10, 64)
		if err != nil {
			return nil, err
		}
		return &dto.AccessDetails{
			AccessUuid: accessUuid,
			UserId:     userId,
		}, nil
	}
	return nil, err
}

// FetchAuth fetches the user ID associated with the provided Redis key from Redis.
func FetchAuth(key string) (string, error) {
	// Get Redis client from database package
	rdb := database.GetRedisDb()
	// Get value associated with key in Redis
	userid, err := rdb.Get(database.Ctx, key).Result()
	if err != nil {
		return "", err
	}
	return userid, nil
}

// GetUserAgent returns the user agent of the current request
func GetUserAgent(c *gin.Context) string {
	uAgent := ua.Parse(c.Request.UserAgent())
	if uAgent.IsAndroid() || uAgent.IsIOS() {
		return "mobile"
	}
	return "web"
}

// DeleteExistingRedisKey deletes the existing Redis key with the given prefix
func DeleteExistingRedisKey(key string) error {
	rdb := database.GetRedisDb()

	// Iterate over all keys with the given prefix
	iter := rdb.Scan(database.Ctx, 0, key+"*", 0).Iterator()
	for iter.Next(database.Ctx) {
		// Delete the key
		if err := rdb.Del(database.Ctx, iter.Val()).Err(); err != nil {
			// If there is an error, panic with the error message
			panic(err)
		}
	}
	if err := iter.Err(); err != nil {
		// If there is an error, panic with the error message
		panic(err)
	}
	return nil
}

// UpdateV2Auth updates the v2 authentication token for the user with the given ID
func UpdateV2Auth(token string, id string, status bool) error {
	base := database.GetSqlxDb()

	var query string
	var err error
	if status {
		// If the status is true, update the token and token_expires fields
		query = `UPDATE users SET token = ?, token_expires = ? WHERE id = ?`
		_, err = base.Exec(query, token, time.Now().AddDate(0, 4, 0), id)
	} else {
		// If the status is false, set the token and token_expires fields to NULL
		query = `UPDATE users SET token = NULL, token_expires = NULL WHERE id = ?`
		_, err = base.Exec(query, id)
	}
	return err
}

// GetCurrentSession returns the current session
func GetCurrentSession() (string, error) {
	base := database.GetSqlxDb()

	var session string
	err := base.Get(&session, "SELECT value FROM options WHERE name = 'school_session'")

	return session, err
}

// LogErrorSentry logs the given error to Sentry
func LogErrorSentry(err interface{}) {
	// Only log the error if it is not nil and the environment is not "local"
	if err != nil && config.Params.Environment != "local" {
		errorMessage, ok := err.(error)
		if !ok {
			// If the error is not an error type, capture the error message
			sentry.CaptureMessage(fmt.Sprintf("Message: %v", err))
		} else {
			// If the error is an error type, capture the exception with the error message
			sentry.WithScope(func(scope *sentry.Scope) {
				sentry.CaptureException(errorMessage)
			})
		}
	}
}

// FindAuthByID FindByID method
func FindAuthByID(id int, mySchool model.School, myIdentity dto.UserIdentity, schoolAdmin model.SchoolAdmin) (dto.UserAuthResponse, error) {
	user := dto.UserAuthResponse{}
	base := database.GetSqlxDb()

	if err := base.Get(&user, `SELECT id, code, email, firstname, lastname, phone, image, class, is_boarded, verification_status, type FROM users WHERE status != 0 AND id=?`, id); err != nil {
		return user, err
	}
	globalClassID, _ := GetGlobalClassWithStudentID(base, id)
	user.Class = &globalClassID
	return GetUserObjectAuth(base, user, mySchool, myIdentity, schoolAdmin)
}
