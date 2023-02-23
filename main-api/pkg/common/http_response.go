package common

import (
	"fmt"
	"github.com/getsentry/sentry-go"
	"github.com/gradely/gradely-backend/pkg/config"
	"net/http"
	"reflect"
)

type Response struct {
	Status     string      `json:"status,omitempty"`
	Code       int         `json:"code,omitempty"`
	Name       string      `json:"name,omitempty"` //name of the error
	Message    string      `json:"message,omitempty"`
	Error      interface{} `json:"error,omitempty"` //for errors that occur even if request is successful
	Data       interface{} `json:"data,omitempty"`
	Pagination interface{} `json:"pagination,omitempty"`
	Extra      interface{} `json:"extra,omitempty"`
}

//BuildResponse method is to inject data value to dynamic success response
func BuildResponse(code int, message string, data interface{}, pagination ...interface{}) Response {
	res := ResponseMessage(code, "success", "", message, nil, data, pagination, nil)
	return res
}

//BuildErrorResponse method is to inject data value to dynamic failed response
func BuildErrorResponse(code int, status string, message string, err interface{}, data interface{}, logger ...bool) Response {
	if err != nil && config.Params.Environment != "local" {
		errorMessage, ok := err.(error)
		if !ok && logger != nil {
			sentry.CaptureMessage(fmt.Sprintf("Message: %v, Data: %v", message, data))
		} else {
			if errorMessage != fmt.Errorf("sql: no rows in result set") {
				sentry.WithScope(func(scope *sentry.Scope) {
					scope.SetTag("title", message)
					if errorMessage != nil {
						sentry.CaptureException(errorMessage)
					}
				})
			}
		}
	}
	res := ResponseMessage(code, status, "", message, err, data, nil, nil)
	return res
}

// UnauthorisedResponse method for someone not authenticated
func UnauthorisedResponse(code int, status string, name string, message string) Response {
	res := ResponseMessage(http.StatusUnauthorized, status, name, message, nil, nil, nil, nil)
	return res
}

//ResponseMessage method for the central response holder
func ResponseMessage(code int, status string, name string, message string, err interface{}, data interface{}, pagination interface{}, extra interface{}) Response {
	if pagination != nil && reflect.ValueOf(pagination).IsNil() {
		pagination = nil
	}

	res := Response{
		Code:       code,
		Name:       name,
		Status:     status,
		Message:    message,
		Error:      err,
		Data:       data,
		Pagination: pagination,
		Extra:      extra,
	}
	return res
}
