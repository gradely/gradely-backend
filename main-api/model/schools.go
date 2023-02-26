package model

import (
	"database/sql"
	"fmt"
	response "github.com/gradely/gradely-backend/pkg/common"
	"time"
)

type SchoolsNamingFormat string

const (
	SchoolsNamingFormatYear SchoolsNamingFormat = "year"
	SchoolsNamingFormatSs   SchoolsNamingFormat = "ss"
)

func (e *SchoolsNamingFormat) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = SchoolsNamingFormat(s)
	case string:
		*e = SchoolsNamingFormat(s)
	default:
		return fmt.Errorf("unsupported scan type for SchoolsNamingFormat: %T", src)
	}
	return nil
}

type School struct {
	ID            int `db:"id"`
	UserID        int `db:"user_id"`
	Slug          string
	Name          string
	Abbr          string
	Logo          response.NullString
	Banner        response.NullString
	Wallpaper     response.NullString
	Tagline       response.NullString
	About         response.NullString
	Address       response.NullString
	City          response.NullString
	State         *string
	Country       *string
	PostalCode    response.NullString `db:"postal_code"`
	Website       response.NullString
	EstablishDate response.NullString `db:"establish_date"`
	ContactName   response.NullString `db:"contact_name"`
	ContactRole   response.NullString `db:"contact_role"`
	ContactEmail  response.NullString `db:"contact_email"`
	ContactImage  response.NullString `db:"contact_image"`
	Phone         response.NullString
	Phone2        response.NullString
	SchoolEmail   response.NullString `db:"school_email"`
	SchoolType    response.NullString `db:"school_type"`
	CreatedAt     time.Time           `db:"created_at" json:"created_at"`
	// SS is primary, junior and senior secondary school naming format. Yeah is for year1 to year12.
	NamingFormat       SchoolsNamingFormat `db:"naming_format"`
	Timezone           response.NullString
	BoardingType       response.NullString `db:"boarding_type"`
	SubscriptionPlan   response.NullString `db:"subscription_plan"`
	SubscriptionExpiry sql.NullTime        `db:"subscription_expiry"`
	// Basic license count
	BasicSubscription int `db:"basic_subscription"`
	// Premium license count
	PremiumSubscription int `db:"premium_subscription"`
	// Allow teacher to join school class automatically
	TeacherAutoJoinClass sql.NullInt32 `db:"teacher_auto_join_class"`
	// Allow student to join school class automatically
	StudentAutoJoinClass sql.NullInt32 `db:"student_auto_join_class"`
}

type SchoolMini struct {
	ID                 int32         `db:"id"`
	UserID             sql.NullInt32 `db:"user_id"`
	Slug               string
	Name               response.NullString
	Abbr               string
	Logo               response.NullString
	CreatedAt          time.Time `db:"created_at"`
	Timezone           response.NullString
	BoardingType       response.NullString `db:"boarding_type"`
	SubscriptionPlan   response.NullString `db:"subscription_plan"`
	SubscriptionExpiry sql.NullTime        `db:"subscription_expiry"`
	// Basic license count
	BasicSubscription sql.NullInt32 `db:"basic_subscription"`
	// Premium license count
	PremiumSubscription sql.NullInt32 `db:"premium_subscription"`
}
