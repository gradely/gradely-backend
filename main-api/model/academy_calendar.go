package model

import (
	"database/sql"
	"time"
)

type AcademyCalendar struct {
	ID              int32        `json:"id"`
	Session         string       `json:"session"`
	Title           string       `json:"title"`
	FirstTermStart  time.Time    `json:"first_term_start"`
	FirstTermEnd    time.Time    `json:"first_term_end"`
	SecondTermStart time.Time    `json:"second_term_start"`
	SecondTermEnd   time.Time    `json:"second_term_end"`
	ThirdTermStart  time.Time    `json:"third_term_start"`
	ThirdTermEnd    time.Time    `json:"third_term_end"`
	Year            string       `json:"year"`
	Status          int          `json:"status"`
	CreatedAt       sql.NullTime `json:"created_at"`
	UpdatedAt       sql.NullTime `json:"updated_at"`
}

type TermWeek struct {
	Term    string `json:"term"`
	Week    int    `json:"week"`
	Session string `json:"session"`
}
