package config

type DatabaseConfiguration struct {
	Driver           string `mapstructure:"DRIVER"`
	DatabaseName     string `mapstructure:"DATABASE_NAME"`
	DatabaseUsername string `mapstructure:"DATABASE_USERNAME"`
	DatabasePassword string `mapstructure:"DATABASE_PASSWORD"`
	DatabaseHost     string `mapstructure:"DATABASE_HOST"`
	DatabasePort     string `mapstructure:"DATABASE_PORT"`
}

type RedisConfiguration struct {
	RedisHost string `mapstructure:"REDIS_HOST"`
	RedisPort string `mapstructure:"REDIS_PORT"`
}

type ParamsConfiguration struct {
	MasterPassword string `mapstructure:"MASTER_PASSWORD"`

	//Logging
	Sentrydsn   string `mapstructure:"SENTRY_DSN"`
	Environment string `mapstructure:"ENVIRONMENT"`
	Debug       bool   `mapstructure:"DEBUG"`
	Release     string `mapstructure:"RELEASE"`
	StackTract  bool   `mapstructure:"STACK_TRACE"`
	AppBaseUrl  string `mapstructure:"APP_BASE_URL"`
}

type ParamsNotification struct {
	BaseUrl string `mapstructure:"BASE_URL"`
}

type EmailConfiguration struct {
	EmailUser     string `mapstructure:"EMAIL_USER"`
	EmailPassword string `mapstructure:"EMAIL_PASSWORD"`
	EmailHost     string `mapstructure:"EMAIL_HOST"`
	EmailPort     string `mapstructure:"EMAIL_PORT"`
}
