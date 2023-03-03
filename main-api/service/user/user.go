package user

import "github.com/jmoiron/sqlx"

func UpdateUserImage(image string, userID int, db *sqlx.DB) (bool, error) {
	rowChange, err := db.MustExec("UPDATE users SET image=? WHERE id=?", image, userID).RowsAffected()
	return rowChange != 0, err
}
