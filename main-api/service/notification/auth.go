package notification

import (
	"fmt"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/pkg/database"
	"strconv"
)

// AccountVerificationCode sends the verification code to the user via email or phone.
func AccountVerificationCode(userID int, code string) error {
	db := database.GetSqlxDb()
	user := struct {
		ID    response.NullInt64  `db:"id" json:"student_id"`
		Email response.NullString `db:"email" json:"phone"`
		Phone response.NullString `db:"phone" json:"email"`
	}{}
	query := `SELECT id, email, phone FROM users where id= ?`
	err := db.Get(&user, query, userID)
	if err != nil {
		return err
	}

	if user.Email.String != "" || user.Phone.String != "" {
		notificationPayload := NotificationModel{
			ActionName: "account_verification",
			ActionData: map[string]interface{}{
				"code":        code,
				"receiver_id": strconv.Itoa(int(user.ID.Int64)),
				"email":       user.Email.String,
				"phone":       user.Phone.String,
			},
		}
		err = notificationPayload.SendNotification()
		if err != nil {
			fmt.Println(err)
		}
	}

	return nil
}
