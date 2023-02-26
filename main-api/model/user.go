package model

import (
	"fmt"
	response "github.com/gradely/gradely-backend/pkg/common"
)

type UserMode string

const (
	UserModePractice UserMode = "practice"
	UserModeExam     UserMode = "exam"
)

func (e *UserMode) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = UserMode(s)
	case string:
		*e = UserMode(s)
	default:
		return fmt.Errorf("unsupported scan type for UserMode: %T", src)
	}
	return nil
}

type UserOauthProvider string

const (
	UserOauthProviderFacebook UserOauthProvider = "facebook"
	UserOauthProviderGoogle   UserOauthProvider = "google"
	UserOauthProviderTwitter  UserOauthProvider = "twitter"
)

func (e *UserOauthProvider) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = UserOauthProvider(s)
	case string:
		*e = UserOauthProvider(s)
	default:
		return nil
	}
	return nil
}

type UserSubscriptionPlan string

const (
	UserSubscriptionPlanFree    UserSubscriptionPlan = "free"
	UserSubscriptionPlanTrial   UserSubscriptionPlan = "trial"
	UserSubscriptionPlanBasic   UserSubscriptionPlan = "basic"
	UserSubscriptionPlanPremium UserSubscriptionPlan = "premium"
)

func (e *UserSubscriptionPlan) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = UserSubscriptionPlan(s)
	case string:
		*e = UserSubscriptionPlan(s)
	default:
		return nil
	}
	return nil
}

type UserType string

const (
	UserTypeStudent UserType = "student"
	UserTypeTeacher UserType = "teacher"
	UserTypeParent  UserType = "parent"
	UserTypeSchool  UserType = "school"
	UserTypeTutor   UserType = "tutor"
)

func (e *UserType) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = UserType(s)
	case string:
		*e = UserType(s)
	default:
		return fmt.Errorf("unsupported scan type for UserType: %T", src)
	}
	return nil
}

// TableName Set User's table name to be `user`
func (User) TableName() string {
	return "user"
}

// User This holds information of gradely users.
type User struct {
	ID                 int
	Username           *string
	Code               string
	Firstname          string
	Lastname           string
	Phone              *string
	Image              *string
	Type               UserType
	AuthKey            string              `db:"auth_key"`
	PasswordHash       string              `db:"password_hash"`
	PasswordResetToken response.NullString `db:"password_reset_token"`
	Email              *string
	// This is student temporary class while the child is yet to be connected to school
	Class *int
	// 10 for active, 9 for inactive and 0 for deleted
	Status             int32
	SubscriptionExpiry response.NullTime    `db:"subscription_expiry"`
	SubscriptionPlan   UserSubscriptionPlan `db:"subscription_plan"`
	CreatedAt          int32                `db:"created_at"`
	UpdatedAt          int32                `db:"updated_at"`
	VerificationToken  response.NullString  `db:"verification_token"`
	OauthProvider      UserOauthProvider    `db:"oauth_provider"`
	Token              response.NullString
	TokenExpires       response.NullTime   `db:"token_expires"`
	OauthUid           response.NullString `db:"oauth_uid"`
	// Last time the website was accessed
	LastAccessed response.NullTime `db:"last_accessed"`
	IsBoarded    int               `db:"is_boarded"`
	// This is used to know if student is in catchup practice or exam mode
	Mode               UserMode
	VerificationStatus int `db:"verification_status"`
}

type UserMiniProfile struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Image string `json:"image"`
	Code  string `json:"code"`
	Email string `json:"email,omitempty"`
	Phone string `json:"phone,omitempty"`
	Type  string `json:"-"`
}

type UserMiniProfile2 struct {
	ID        int     `db:"id" json:"id"`
	Firstname *string `db:"firstname" json:"firstname"`
	Lastname  *string `db:"lastname" json:"lastname"`
	Image     *string `db:"image" json:"image"`
	Code      *string `db:"code" json:"code"`
	Email     *string `db:"email" json:"email"`
	Phone     *string `db:"phone" json:"phone"`
}
