package utility

import (
	"fmt"
	"github.com/getsentry/sentry-go"
	"github.com/gradely/gradely-backend/pkg/config"
	"log"
	"time"
)

func InitSentryLogger() {
	err := sentry.Init(sentry.ClientOptions{
		Dsn:              config.Params.Sentrydsn,
		Environment:      config.Params.Environment,
		Debug:            config.Params.Debug,
		Release:          config.Params.Release,
		AttachStacktrace: config.Params.StackTract,
	})
	if err != nil {
		log.Fatalf("sentry.Init: %s", err)
	}

	// Flush buffered events before the program terminates.
	defer sentry.Flush(3 * time.Second)
}

func LogErrorSentry(err interface{}, extraData ...string) {
	fmt.Println(err)
	if err != nil && config.Params.Environment != "local" {

		errorMessage, ok := err.(error)
		if !ok {
			sentry.CaptureMessage(fmt.Sprintf("Message: %v", err))
		} else {
			if errorMessage != fmt.Errorf("sql: no rows in result set") {
				sentry.WithScope(func(scope *sentry.Scope) {
					if extraData != nil {
						scope.SetTag("extra-data", extraData[0])
					}
					sentry.CaptureException(errorMessage)
				})
			}
		}
	}
}
