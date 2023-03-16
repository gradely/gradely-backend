package user

import (
	"github.com/gin-gonic/gin"
	"github.com/gradely/gradely-backend/model/dto"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/pkg/database"
	"github.com/jmoiron/sqlx"
	"net/http"
)

func (util *serviceUser) UpdateUserImage(image string, userID int, db *sqlx.DB) (bool, error) {
	rowChange, err := db.MustExec("UPDATE users SET image=? WHERE id=?", image, userID).RowsAffected()
	return rowChange != 0, err
}

// SaveAccVerificationLog saves the given AccountVerificationLog in the database.
// It returns 1 if the insert operation succeeds and 0 otherwise.
func SaveAccVerificationLog(c *gin.Context, avLog *dto.AccountVerificationLog) int {
	// Get a connection to the database.
	db := database.GetSqlxDb()

	// Build the insert query.
	query := `
		INSERT INTO account_verification_log (
			user_id, channel, code, code_expiry, token, type
		) VALUES (?, ?, ?, ?, ?, ?)
	`

	// Execute the query and get the result.
	result := db.MustExec(query, avLog.UserID, avLog.Channel, avLog.Code, avLog.CodeExpiry, avLog.Token, avLog.Type)

	// Check the number of rows affected by the query.
	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		// If the query didn't affect any rows, build an error response.
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Error accepting request", nil, nil)
		c.JSON(http.StatusBadRequest, rd)
		return 0
	}

	// Return 1 if the insert operation succeeded.
	return 1
}
