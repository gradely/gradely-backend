package dto

import (
	"github.com/gradely/gradely-backend/model"
	"time"
)

type AuthLoginDTO struct {
	Email    string `validate:"required" json:"email"`
	Password string `validate:"required" json:"password"`
	DeviceID string `json:"device_id"`
}

type UserIdentity struct {
	ID   int            `json:"id"`
	Type model.UserType `json:"type"`
}

type UserAuthResponse struct {
	ID                 int            `json:"id"`
	Code               string         `json:"code"`
	Firstname          string         `json:"firstname"`
	Lastname           string         `json:"lastname"`
	Phone              *string        `json:"phone"`
	Image              *string        `json:"image"`
	Type               model.UserType `json:"type"`
	Email              *string        `json:"email"`
	Class              *int           `json:"class"`
	IsBoarded          int            `json:"is_boarded" db:"is_boarded"`
	VerificationStatus int            `json:"verification_status" db:"verification_status"`
	AccessToken        string         `json:"access_token,omitempty"`
	RefreshToken       string         `json:"refresh_token,omitempty"`
	RelationshipStatus int            `json:"relationship_status"`
	SchoolID           int            `json:"school_id"`
	State              *string        `json:"state"`
	Country            *string        `json:"country"`
	SchoolName         string         `json:"school_name"`
	SchoolSlug         string         `json:"school_slug"`
	SchoolOwner        int            `json:"school_owner"`
	Role               string         `json:"role"`
	TermWeek           model.TermWeek `json:"term_week,omitempty"`
	IsTutor            bool           `json:"is_tutor,omitempty"`
	IsTutorBoarded     bool           `json:"is_tutor_boarded,omitempty"`
	HaveClass          bool           `json:"have_class,omitempty"`
}

type UserProfileResponse struct {
	ID                 int            `json:"id"`
	Code               string         `json:"code"`
	Firstname          string         `json:"firstname"`
	Lastname           string         `json:"lastname"`
	Phone              *string        `json:"phone"`
	Image              *string        `json:"image"`
	Type               model.UserType `json:"type"`
	Email              *string        `json:"email"`
	Class              *int           `json:"class"`
	IsBoarded          int            `json:"is_boarded" db:"is_boarded"`
	VerificationStatus int            `json:"verification_status" db:"verification_status"`
	State              *string        `json:"state"`
	Country            *string        `json:"country"`
	//UserProfile        model.UserProfile `json:"user_profile" db:"user_profile"`

	UserID int32 `json:"user_id" db:"user_id"`
	// Date of birth
	Dob *int `json:"-" db:"dob"`
	// Month of birth
	Mob *int `json:"-" db:"mob"`
	// Year of birth
	Yob        *int    `json:"-" db:"yob"`
	Gender     *string `json:"gender"`
	Address    *string `json:"address"`
	City       *string `json:"city"`
	About      *string `json:"about"`
	PostalCode *string `json:"postal_code"`
	BirthDate  *string `json:"birth_date"`
}

type TokenDetailsDTO struct {
	AccessUuid    string `json:"access_uuid"`
	RefreshUuid   string `json:"refresh_uuid"`
	AccessToken   string `json:"access_token"`
	RefreshToken  string `json:"refresh_token"`
	AtExpiresTime time.Time
	RtExpiresTime time.Time
}

type AccessDetails struct {
	AccessUuid string
	UserId     uint64
}

type AuthLoginResponse struct {
	AccessToken     string `json:"access_token"`
	RefreshToken    string `json:"refresh_token"`
	TransmissionKey string `json:"transmission_key"`
}

type FindStudentResponse struct {
	ID         int            `db:"id" json:"id"`
	Code       string         `db:"code" json:"code"`
	Firstname  string         `db:"firstname" json:"firstname"`
	Lastname   string         `db:"lastname" json:"lastname"`
	Phone      *string        `db:"phone" json:"phone"`
	Image      *string        `db:"image" json:"image"`
	Type       model.UserType `db:"type" json:"type"`
	Email      *string        `db:"email" json:"email"`
	SchoolID   *int           `db:"school_id" json:"school_id"`
	SchoolName *string        `db:"school_name" json:"school_name"`
	ClassID    *int           `db:"class_id" json:"class_id"`
	ClassName  *string        `db:"class_name" json:"class_name"`
}

type UserRelationsResponse struct {
	ID        int            `db:"id" json:"id"`
	Code      string         `db:"code" json:"code"`
	Firstname string         `db:"firstname" json:"firstname"`
	Lastname  string         `db:"lastname" json:"lastname"`
	Phone     *string        `db:"phone" json:"phone"`
	Image     *string        `db:"image" json:"image"`
	Type      model.UserType `db:"type" json:"type"`
	Email     *string        `db:"email" json:"email"`
	ClassID   *int           `db:"class_id" json:"class_id"`
}
