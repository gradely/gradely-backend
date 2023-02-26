package model

import "time"

type SchoolAdmin struct {
	ID        int32     `json:"id"`
	SchoolID  int32     `json:"school_id" db:"school_id"`
	UserID    int32     `json:"user_id" db:"user_id"`
	Level     string    `json:"level"`
	Status    int32     `json:"status"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}
